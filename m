Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE3246A94
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgHQPir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbgHQPih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CAC9208E4;
        Mon, 17 Aug 2020 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678716;
        bh=Awa9szfVnyfHhZXV0EKIVyiunFy+LWKFXGUkDfuCRVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBm2jQiy2fUXfy8WhFwbQOVYHWWCn6odLDwy6n6Q3CbRLWdvpG3k0z0y+HOdxdPrc
         tIlGosLVGrks5KSPUJ3sOzJ+cca8FYRSVMQAWfT2Lj43Fx+JMCas7I4/m5HjQmlgDI
         xbK+Egce6iJq7NR5n/GzavbEyIVyH6umTsg2WwNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.8 430/464] cpufreq: Fix locking issues with governors
Date:   Mon, 17 Aug 2020 17:16:23 +0200
Message-Id: <20200817143854.378982144@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 8cc46ae565c393f77417cb9530b1265eb50f5d2e upstream.

The locking around governors handling isn't adequate currently.

The list of governors should never be traversed without the locking
in place. Also governor modules must not be removed while the code
in them is still in use.

Reported-by: Quentin Perret <qperret@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   58 +++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -621,6 +621,24 @@ static struct cpufreq_governor *find_gov
 	return NULL;
 }
 
+static struct cpufreq_governor *get_governor(const char *str_governor)
+{
+	struct cpufreq_governor *t;
+
+	mutex_lock(&cpufreq_governor_mutex);
+	t = find_governor(str_governor);
+	if (!t)
+		goto unlock;
+
+	if (!try_module_get(t->owner))
+		t = NULL;
+
+unlock:
+	mutex_unlock(&cpufreq_governor_mutex);
+
+	return t;
+}
+
 static unsigned int cpufreq_parse_policy(char *str_governor)
 {
 	if (!strncasecmp(str_governor, "performance", CPUFREQ_NAME_LEN))
@@ -640,28 +658,14 @@ static struct cpufreq_governor *cpufreq_
 {
 	struct cpufreq_governor *t;
 
-	mutex_lock(&cpufreq_governor_mutex);
-
-	t = find_governor(str_governor);
-	if (!t) {
-		int ret;
+	t = get_governor(str_governor);
+	if (t)
+		return t;
 
-		mutex_unlock(&cpufreq_governor_mutex);
+	if (request_module("cpufreq_%s", str_governor))
+		return NULL;
 
-		ret = request_module("cpufreq_%s", str_governor);
-		if (ret)
-			return NULL;
-
-		mutex_lock(&cpufreq_governor_mutex);
-
-		t = find_governor(str_governor);
-	}
-	if (t && !try_module_get(t->owner))
-		t = NULL;
-
-	mutex_unlock(&cpufreq_governor_mutex);
-
-	return t;
+	return get_governor(str_governor);
 }
 
 /**
@@ -815,12 +819,14 @@ static ssize_t show_scaling_available_go
 		goto out;
 	}
 
+	mutex_lock(&cpufreq_governor_mutex);
 	for_each_governor(t) {
 		if (i >= (ssize_t) ((PAGE_SIZE / sizeof(char))
 		    - (CPUFREQ_NAME_LEN + 2)))
-			goto out;
+			break;
 		i += scnprintf(&buf[i], CPUFREQ_NAME_PLEN, "%s ", t->name);
 	}
+	mutex_unlock(&cpufreq_governor_mutex);
 out:
 	i += sprintf(&buf[i], "\n");
 	return i;
@@ -1058,15 +1064,17 @@ static int cpufreq_init_policy(struct cp
 	struct cpufreq_governor *def_gov = cpufreq_default_governor();
 	struct cpufreq_governor *gov = NULL;
 	unsigned int pol = CPUFREQ_POLICY_UNKNOWN;
+	int ret;
 
 	if (has_target()) {
 		/* Update policy governor to the one used before hotplug. */
-		gov = find_governor(policy->last_governor);
+		gov = get_governor(policy->last_governor);
 		if (gov) {
 			pr_debug("Restoring governor %s for cpu %d\n",
 				 policy->governor->name, policy->cpu);
 		} else if (def_gov) {
 			gov = def_gov;
+			__module_get(gov->owner);
 		} else {
 			return -ENODATA;
 		}
@@ -1089,7 +1097,11 @@ static int cpufreq_init_policy(struct cp
 			return -ENODATA;
 	}
 
-	return cpufreq_set_policy(policy, gov, pol);
+	ret = cpufreq_set_policy(policy, gov, pol);
+	if (gov)
+		module_put(gov->owner);
+
+	return ret;
 }
 
 static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)


