Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE8A29B41A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763851AbgJ0O6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783324AbgJ0O6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5BC20715;
        Tue, 27 Oct 2020 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810685;
        bh=JkQPIbcA5besSeShAidqXjG0dMlW9ZyyeGO2Wb+eEFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ka6Lca6kXb8BMDWrnbywrPnVA/wzfjpNG7Ik5CQWgmOKL8mUEU14PAUdfOfVVhFcc
         he8hSGdeLSAvFnU8dVvcZsAh/cAshA2g/+H5I/Jkb+afoFYXeD2ocHUYyfP7JpGDm2
         TNN9aRhsUu9EpLrWEv5EiV0vjO4q569fbAhIth/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 228/633] coresight: etm4x: Fix etm4_count race by moving cpuhp callbacks to init
Date:   Tue, 27 Oct 2020 14:49:31 +0100
Message-Id: <20201027135533.375581738@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit 2d1a8bfb61ec0177343e99ebd745e3e4ceb0d0d5 ]

etm4_count keeps track of number of ETMv4 registered and on some systems,
a race is observed on etm4_count variable which can lead to multiple calls
to cpuhp_setup_state_nocalls_cpuslocked(). This function internally calls
cpuhp_store_callbacks() which prevents multiple registrations of callbacks
for a given state and due to this race, it returns -EBUSY leading to ETM
probe failures like below.

 coresight-etm4x: probe of 7040000.etm failed with error -16

This race can easily be triggered with async probe by setting probe type
as PROBE_PREFER_ASYNCHRONOUS and with ETM power management property
"arm,coresight-loses-context-with-cpu".

Prevent this race by moving cpuhp callbacks to etm driver init since the
cpuhp callbacks doesn't have to depend on the etm4_count and can be once
setup during driver init. Similarly we move cpu_pm notifier registration
to driver init and completely remove etm4_count usage. Also now we can
use non cpuslocked version of cpuhp callbacks with this movement.

Fixes: 9b6a3f3633a5 ("coresight: etmv4: Fix CPU power management setup in probe() function")
Fixes: 58eb457be028 ("hwtracing/coresight-etm4x: Convert to hotplug state machine")
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 65 +++++++++----------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 6089c481f8f19..a970bd17edf8d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -48,8 +48,6 @@ module_param(pm_save_enable, int, 0444);
 MODULE_PARM_DESC(pm_save_enable,
 	"Save/restore state on power down: 1 = never, 2 = self-hosted");
 
-/* The number of ETMv4 currently registered */
-static int etm4_count;
 static struct etmv4_drvdata *etmdrvdata[NR_CPUS];
 static void etm4_set_default_config(struct etmv4_config *config);
 static int etm4_set_event_filters(struct etmv4_drvdata *drvdata,
@@ -1394,28 +1392,25 @@ static struct notifier_block etm4_cpu_pm_nb = {
 	.notifier_call = etm4_cpu_pm_notify,
 };
 
-/* Setup PM. Called with cpus locked. Deals with error conditions and counts */
-static int etm4_pm_setup_cpuslocked(void)
+/* Setup PM. Deals with error conditions and counts */
+static int __init etm4_pm_setup(void)
 {
 	int ret;
 
-	if (etm4_count++)
-		return 0;
-
 	ret = cpu_pm_register_notifier(&etm4_cpu_pm_nb);
 	if (ret)
-		goto reduce_count;
+		return ret;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING,
-						   "arm/coresight4:starting",
-						   etm4_starting_cpu, etm4_dying_cpu);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING,
+					"arm/coresight4:starting",
+					etm4_starting_cpu, etm4_dying_cpu);
 
 	if (ret)
 		goto unregister_notifier;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
-						   "arm/coresight4:online",
-						   etm4_online_cpu, NULL);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					"arm/coresight4:online",
+					etm4_online_cpu, NULL);
 
 	/* HP dyn state ID returned in ret on success */
 	if (ret > 0) {
@@ -1424,21 +1419,15 @@ static int etm4_pm_setup_cpuslocked(void)
 	}
 
 	/* failed dyn state - remove others */
-	cpuhp_remove_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING);
 
 unregister_notifier:
 	cpu_pm_unregister_notifier(&etm4_cpu_pm_nb);
-
-reduce_count:
-	--etm4_count;
 	return ret;
 }
 
-static void etm4_pm_clear(void)
+static void __init etm4_pm_clear(void)
 {
-	if (--etm4_count != 0)
-		return;
-
 	cpu_pm_unregister_notifier(&etm4_cpu_pm_nb);
 	cpuhp_remove_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING);
 	if (hp_online) {
@@ -1491,22 +1480,12 @@ static int etm4_probe(struct amba_device *adev, const struct amba_id *id)
 	if (!desc.name)
 		return -ENOMEM;
 
-	cpus_read_lock();
 	etmdrvdata[drvdata->cpu] = drvdata;
 
 	if (smp_call_function_single(drvdata->cpu,
 				etm4_init_arch_data,  drvdata, 1))
 		dev_err(dev, "ETM arch init failed\n");
 
-	ret = etm4_pm_setup_cpuslocked();
-	cpus_read_unlock();
-
-	/* etm4_pm_setup_cpuslocked() does its own cleanup - exit on error */
-	if (ret) {
-		etmdrvdata[drvdata->cpu] = NULL;
-		return ret;
-	}
-
 	if (etm4_arch_supported(drvdata->arch) == false) {
 		ret = -EINVAL;
 		goto err_arch_supported;
@@ -1553,7 +1532,6 @@ static int etm4_probe(struct amba_device *adev, const struct amba_id *id)
 
 err_arch_supported:
 	etmdrvdata[drvdata->cpu] = NULL;
-	etm4_pm_clear();
 	return ret;
 }
 
@@ -1591,4 +1569,23 @@ static struct amba_driver etm4x_driver = {
 	.probe		= etm4_probe,
 	.id_table	= etm4_ids,
 };
-builtin_amba_driver(etm4x_driver);
+
+static int __init etm4x_init(void)
+{
+	int ret;
+
+	ret = etm4_pm_setup();
+
+	/* etm4_pm_setup() does its own cleanup - exit on error */
+	if (ret)
+		return ret;
+
+	ret = amba_driver_register(&etm4x_driver);
+	if (ret) {
+		pr_err("Error registering etm4x driver\n");
+		etm4_pm_clear();
+	}
+
+	return ret;
+}
+device_initcall(etm4x_init);
-- 
2.25.1



