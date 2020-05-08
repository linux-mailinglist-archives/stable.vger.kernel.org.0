Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4FE1CAEB2
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgEHMqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgEHMqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B8621974;
        Fri,  8 May 2020 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941961;
        bh=vT1ohDLykskvWR62HNatjxD7VTjctg1pSVYPi9mKQjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSYI1U9r1fyxBczuqey9W+6lrGTbhBMCBrmqrGkssyl+8a2qvEpPtMAHBgnFErSIG
         6q8yt7JQENr/01fIh36NuN/d2uFYxS2RUclivXmdIHnsk/nvI8xnphtpryjR4MNJt3
         sQIJja6uo0KrD9WoAD3e+NKlUFDjt7aGpQ6+3QC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Juri Lelli <juri.lelli@arm.com>,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 242/312] Revert "cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT"
Date:   Fri,  8 May 2020 14:33:53 +0200
Message-Id: <20200508123141.444339553@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 68e80dae09033d778b98dc88e5bfe8fdade188e5 upstream.

Earlier, when the struct freq-attr was used to represent governor
attributes, the standard cpufreq show/store sysfs attribute callbacks
were applied to the governor tunable attributes and they always acquire
the policy->rwsem lock before carrying out the operation.  That could
have resulted in an ABBA deadlock if governor tunable attributes are
removed under policy->rwsem while one of them is being accessed
concurrently (if sysfs attributes removal wins the race, it will wait
for the access to complete with policy->rwsem held while the attribute
callback will block on policy->rwsem indefinitely).

We attempted to address this issue by dropping policy->rwsem around
governor tunable attributes removal (that is, around invocations of the
->governor callback with the event arg equal to CPUFREQ_GOV_POLICY_EXIT)
in cpufreq_set_policy(), but that opened up race conditions that had not
been possible with policy->rwsem held all the time.

The previous commit, "cpufreq: governor: New sysfs show/store callbacks
for governor tunables", fixed the original ABBA deadlock by adding new
governor specific show/store callbacks.

We don't have to drop rwsem around invocations of governor event
CPUFREQ_GOV_POLICY_EXIT anymore, and original fix can be reverted now.

Fixes: 955ef4833574 (cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT)
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reported-by: Juri Lelli <juri.lelli@arm.com>
Tested-by: Juri Lelli <juri.lelli@arm.com>
Tested-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    5 -----
 include/linux/cpufreq.h   |    4 ----
 2 files changed, 9 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2171,10 +2171,7 @@ static int cpufreq_set_policy(struct cpu
 			return ret;
 		}
 
-		up_write(&policy->rwsem);
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-		down_write(&policy->rwsem);
-
 		if (ret) {
 			pr_err("%s: Failed to Exit Governor: %s (%d)\n",
 			       __func__, old_gov->name, ret);
@@ -2190,9 +2187,7 @@ static int cpufreq_set_policy(struct cpu
 		if (!ret)
 			goto out;
 
-		up_write(&policy->rwsem);
 		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-		down_write(&policy->rwsem);
 	}
 
 	/* new governor failed, so re-start old one */
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -100,10 +100,6 @@ struct cpufreq_policy {
 	 * - Any routine that will write to the policy structure and/or may take away
 	 *   the policy altogether (eg. CPU hotplug), will hold this lock in write
 	 *   mode before doing so.
-	 *
-	 * Additional rules:
-	 * - Lock should not be held across
-	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 	 */
 	struct rw_semaphore	rwsem;
 


