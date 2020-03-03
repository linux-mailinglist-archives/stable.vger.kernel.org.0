Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13460178268
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbgCCSK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:10:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731869AbgCCRuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A316020870;
        Tue,  3 Mar 2020 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257815;
        bh=31kHG0BAluI6gkdGu5e/N0FV4Jh66A/f502Pb61ffs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bsez5VXT6JMh0hr45pnt736Oa8vsZWi41VhqBl0MJjOZA0RjjiDvDmeYqjqgi+saT
         yYszcX1VkhSxES7acFszLLMaxFYrF/CjSldphi8EbSfeRQ3neQa08IuWNy5o3Ya4HQ
         d6mUjycRJg6TLYpRmCqD9xfk4sTdroL+FvbOVW28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.5 100/176] cpufreq: Fix policy initialization for internal governor drivers
Date:   Tue,  3 Mar 2020 18:42:44 +0100
Message-Id: <20200303174316.398372405@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f5739cb0b56590d68d8df8a44659893b6d0084c3 upstream.

Before commit 1e4f63aecb53 ("cpufreq: Avoid creating excessively
large stack frames") the initial value of the policy field in struct
cpufreq_policy set by the driver's ->init() callback was implicitly
passed from cpufreq_init_policy() to cpufreq_set_policy() if the
default governor was neither "performance" nor "powersave".  After
that commit, however, cpufreq_init_policy() must take that case into
consideration explicitly and handle it as appropriate, so make that
happen.

Fixes: 1e4f63aecb53 ("cpufreq: Avoid creating excessively large stack frames")
Link: https://lore.kernel.org/linux-pm/39fb762880c27da110086741315ca8b111d781cd.camel@gmail.com/
Reported-by: Artem Bityutskiy <dedekind1@gmail.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1074,9 +1074,17 @@ static int cpufreq_init_policy(struct cp
 			pol = policy->last_policy;
 		} else if (def_gov) {
 			pol = cpufreq_parse_policy(def_gov->name);
-		} else {
-			return -ENODATA;
+			/*
+			 * In case the default governor is neiter "performance"
+			 * nor "powersave", fall back to the initial policy
+			 * value set by the driver.
+			 */
+			if (pol == CPUFREQ_POLICY_UNKNOWN)
+				pol = policy->policy;
 		}
+		if (pol != CPUFREQ_POLICY_PERFORMANCE &&
+		    pol != CPUFREQ_POLICY_POWERSAVE)
+			return -ENODATA;
 	}
 
 	return cpufreq_set_policy(policy, gov, pol);


