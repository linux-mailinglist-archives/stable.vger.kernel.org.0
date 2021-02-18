Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCE31F12B
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 21:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBRUlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 15:41:46 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54028 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhBRUkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 15:40:23 -0500
Date:   Thu, 18 Feb 2021 20:39:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613680781;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7uhS9/H1Kq5DnXviFTbVDNSgBtybxd6It87sw9+bfE=;
        b=lnrUuAIphfQKTIrM+BhIJ9iuOYUm6HANiu3p6l2/eyMEsAt+q4KmCHRL8RabIVyJ1IYg1r
        Mw8Oi9o0rdow3pw5E168uOlLUC/gV9xU8BzPE4ZAgc1f+lM9GStME947mbvAvDEgDyiy4r
        TPe2s9YbpL5piidrqNtrbZgCeGjXs9nJpwUSvpFoCNtKyTNTTLDkTGEAGnVpGCNfC7PKYr
        IhW63x5/g+MlTk2VoR0sY95+4WsPrqRMEer0BNeyNKJFF3/yRFSrr3la7cVoSZie5aPDfs
        yCktITi8QiQKPzz6oappvSVk5isdzyUR6uoY+y8TUsyq5XtWR59yTreIYEnzJg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613680781;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7uhS9/H1Kq5DnXviFTbVDNSgBtybxd6It87sw9+bfE=;
        b=86iYd0wYmYZQq/lVoHACrgJaSwQZXQAm6CTpvqUY3MNilkxzIdEqgnePX7xbRGn/MQhYNq
        Rcu1Tq+1lh1G9lAw==
From:   "thermal-bot for Viresh Kumar" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-pm@vger.kernel.org
To:     linux-pm@vger.kernel.org
Subject: [thermal: thermal/next] thermal: cpufreq_cooling:
 freq_qos_update_request() returns < 0 on error
Cc:     "v5.7+" <stable@vger.kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        rui.zhang@intel.com, amitk@kernel.org
In-Reply-To: =?utf-8?q?=3Cb2b7e84944937390256669df5a48ce5abba0c1ef=2E16135?=
 =?utf-8?q?40713=2Egit=2Eviresh=2Ekumar=40linaro=2Eorg=3E?=
References: =?utf-8?q?=3Cb2b7e84944937390256669df5a48ce5abba0c1ef=2E161354?=
 =?utf-8?q?0713=2Egit=2Eviresh=2Ekumar=40linaro=2Eorg=3E?=
MIME-Version: 1.0
Message-ID: <161368078026.20312.13727207651031195020.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the thermal/next branch of thermal:

Commit-ID:     a51afb13311cd85b2f638c691b2734622277d8f5
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git//a51afb13311cd85b2f638c691b2734622277d8f5
Author:        Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate:    Wed, 17 Feb 2021 11:18:58 +05:30
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Wed, 17 Feb 2021 18:53:19 +01:00

thermal: cpufreq_cooling: freq_qos_update_request() returns < 0 on error

freq_qos_update_request() returns 1 if the effective constraint value
has changed, 0 if the effective constraint value has not changed, or a
negative error code on failures.

The frequency constraints for CPUs can be set by different parts of the
kernel. If the maximum frequency constraint set by other parts of the
kernel are set at a lower value than the one corresponding to cooling
state 0, then we will never be able to cool down the system as
freq_qos_update_request() will keep on returning 0 and we will skip
updating cpufreq_state and thermal pressure.

Fix that by doing the updates even in the case where
freq_qos_update_request() returns 0, as we have effectively set the
constraint to a new value even if the consolidated value of the
actual constraint is unchanged because of external factors.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Reported-by: Thara Gopinath <thara.gopinath@linaro.org>
Fixes: f12e4f66ab6a ("thermal/cpu-cooling: Update thermal pressure in case of a maximum frequency capping")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Thara Gopinath<thara.gopinath@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/b2b7e84944937390256669df5a48ce5abba0c1ef.1613540713.git.viresh.kumar@linaro.org
---
 drivers/thermal/cpufreq_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index 612f063..ddc166e 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -441,7 +441,7 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 	frequency = get_state_freq(cpufreq_cdev, state);
 
 	ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
-	if (ret > 0) {
+	if (ret >= 0) {
 		cpufreq_cdev->cpufreq_state = state;
 		cpus = cpufreq_cdev->policy->cpus;
 		max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));
