Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760692267B6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388208AbgGTQOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388202AbgGTQOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B3792065E;
        Mon, 20 Jul 2020 16:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261641;
        bh=nVE878neXNLc8NO978AlruqasantbqYt4rNkgcCSQrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ou7KWWJDYzTIkbpju5UeLc16H9wgkBaetQ+1DI/WlmerdKMxLX9bi+f4OywkLJumx
         YcxFgysh2xkQefE2O9ST845LmHgAe7D20i58YxGBn0nSUWCxpNVCrhMdNhqluXD9ba
         La/Hvmx91t9qzuXxBbHKAJtQUMPM5nTfjNDuQcdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.7 190/244] coresight: etmv4: Fix CPU power management setup in probe() function
Date:   Mon, 20 Jul 2020 17:37:41 +0200
Message-Id: <20200720152834.877483230@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

commit 9b6a3f3633a5cc928b78627764793b60cb62e0f6 upstream.

The current probe() function calls a pair of cpuhp_xxx API functions to
setup CPU hotplug handling. The hotplug lock is held for the duration of
the two calls and other CPU related code using cpus_read_lock() /
cpus_read_unlock() calls.

The problem is that on error states, goto: statements bypass the
cpus_read_unlock() call. This code has increased in complexity as the
driver has developed.

This patch introduces a pair of helper functions etm4_pm_setup_cpuslocked()
and etm4_pm_clear() which correct the issues above and group the PM code a
little better.

The two functions etm4_cpu_pm_register() and etm4_cpu_pm_unregister() are
dropped as these call cpu_pm_register_notifier() / ..unregister_notifier()
dependent on CONFIG_CPU_PM - but this define is used to nop these functions
out in the pm headers - so the wrapper functions are superfluous.

Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Fixes: e9f5d63f84fe ("hwtracing/coresight-etm4x: Use cpuhp_setup_state_nocalls_cpuslocked()")
Fixes: 58eb457be028 ("hwtracing/coresight-etm4x: Convert to hotplug state machine")
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200701160852.2782823-3-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x.c |   82 ++++++++++++++++----------
 1 file changed, 53 insertions(+), 29 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1399,18 +1399,57 @@ static struct notifier_block etm4_cpu_pm
 	.notifier_call = etm4_cpu_pm_notify,
 };
 
-static int etm4_cpu_pm_register(void)
+/* Setup PM. Called with cpus locked. Deals with error conditions and counts */
+static int etm4_pm_setup_cpuslocked(void)
 {
-	if (IS_ENABLED(CONFIG_CPU_PM))
-		return cpu_pm_register_notifier(&etm4_cpu_pm_nb);
+	int ret;
 
-	return 0;
+	if (etm4_count++)
+		return 0;
+
+	ret = cpu_pm_register_notifier(&etm4_cpu_pm_nb);
+	if (ret)
+		goto reduce_count;
+
+	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING,
+						   "arm/coresight4:starting",
+						   etm4_starting_cpu, etm4_dying_cpu);
+
+	if (ret)
+		goto unregister_notifier;
+
+	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
+						   "arm/coresight4:online",
+						   etm4_online_cpu, NULL);
+
+	/* HP dyn state ID returned in ret on success */
+	if (ret > 0) {
+		hp_online = ret;
+		return 0;
+	}
+
+	/* failed dyn state - remove others */
+	cpuhp_remove_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING);
+
+unregister_notifier:
+	cpu_pm_unregister_notifier(&etm4_cpu_pm_nb);
+
+reduce_count:
+	--etm4_count;
+	return ret;
 }
 
-static void etm4_cpu_pm_unregister(void)
+static void etm4_pm_clear(void)
 {
-	if (IS_ENABLED(CONFIG_CPU_PM))
-		cpu_pm_unregister_notifier(&etm4_cpu_pm_nb);
+	if (--etm4_count != 0)
+		return;
+
+	cpu_pm_unregister_notifier(&etm4_cpu_pm_nb);
+	cpuhp_remove_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING);
+	if (hp_online) {
+		cpuhp_remove_state_nocalls(hp_online);
+		hp_online = 0;
+	}
 }
 
 static int etm4_probe(struct amba_device *adev, const struct amba_id *id)
@@ -1464,24 +1503,15 @@ static int etm4_probe(struct amba_device
 				etm4_init_arch_data,  drvdata, 1))
 		dev_err(dev, "ETM arch init failed\n");
 
-	if (!etm4_count++) {
-		cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING,
-						     "arm/coresight4:starting",
-						     etm4_starting_cpu, etm4_dying_cpu);
-		ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
-							   "arm/coresight4:online",
-							   etm4_online_cpu, NULL);
-		if (ret < 0)
-			goto err_arch_supported;
-		hp_online = ret;
+	ret = etm4_pm_setup_cpuslocked();
+	cpus_read_unlock();
 
-		ret = etm4_cpu_pm_register();
-		if (ret)
-			goto err_arch_supported;
+	/* etm4_pm_setup_cpuslocked() does its own cleanup - exit on error */
+	if (ret) {
+		etmdrvdata[drvdata->cpu] = NULL;
+		return ret;
 	}
 
-	cpus_read_unlock();
-
 	if (etm4_arch_supported(drvdata->arch) == false) {
 		ret = -EINVAL;
 		goto err_arch_supported;
@@ -1528,13 +1558,7 @@ static int etm4_probe(struct amba_device
 
 err_arch_supported:
 	etmdrvdata[drvdata->cpu] = NULL;
-	if (--etm4_count == 0) {
-		etm4_cpu_pm_unregister();
-
-		cpuhp_remove_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING);
-		if (hp_online)
-			cpuhp_remove_state_nocalls(hp_online);
-	}
+	etm4_pm_clear();
 	return ret;
 }
 


