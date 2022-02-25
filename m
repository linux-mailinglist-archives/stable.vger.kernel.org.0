Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC07D4C43B1
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 12:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbiBYLec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 06:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbiBYLec (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 06:34:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F3D1DD0FF
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 03:34:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6BD6B82F1F
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 11:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58E6C340E7;
        Fri, 25 Feb 2022 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645788837;
        bh=R2qTQa8oIsPE39dDG5YJAuk51KFgJoPUf+PM0eOz9K0=;
        h=Subject:To:Cc:From:Date:From;
        b=MpVdvZ/aoLwlQCCkye7IowYGbgIQjRKnW8OwHiqvUsukExV4y8OPip7ZtPrKf9E/V
         a//Y8HCEg2YpHd/2DkAuDBdX7QqGjjQUUuLI8K9tD30blthC2Z1k4mEYjEJi5Xufsa
         OWWnQWvhQ36aGn2Vzjx7HiVe1GKXCvIygcs9b1GA=
Subject: FAILED: patch "[PATCH] platform/x86: amd-pmc: Set QOS during suspend on CZN w/ timer" failed to apply to 5.16-stable tree
To:     mario.limonciello@amd.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 12:33:54 +0100
Message-ID: <164578883415493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 68af28426b3ca1bf9ba21c7d8bdd0ff639e5134c Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario.limonciello@amd.com>
Date: Wed, 23 Feb 2022 11:52:37 -0600
Subject: [PATCH] platform/x86: amd-pmc: Set QOS during suspend on CZN w/ timer
 wakeup

commit 59348401ebed ("platform/x86: amd-pmc: Add special handling for
timer based S0i3 wakeup") adds support for using another platform timer
in lieu of the RTC which doesn't work properly on some systems. This path
was validated and worked well before submission. During the 5.16-rc1 merge
window other patches were merged that caused this to stop working properly.

When this feature was used with 5.16-rc1 or later some OEM laptops with the
matching firmware requirements from that commit would shutdown instead of
program a timer based wakeup.

This was bisected to commit 8d89835b0467 ("PM: suspend: Do not pause
cpuidle in the suspend-to-idle path").  This wasn't supposed to cause any
negative impacts and also tested well on both Intel and ARM platforms.
However this changed the semantics of when CPUs are allowed to be in the
deepest state. For the AMD systems in question it appears this causes a
firmware crash for timer based wakeup.

It's hypothesized to be caused by the `amd-pmc` driver sending `OS_HINT`
and all the CPUs going into a deep state while the timer is still being
programmed. It's likely a firmware bug, but to avoid it don't allow setting
CPUs into the deepest state while using CZN timer wakeup path.

If later it's discovered that this also occurs from "regular" suspends
without a timer as well or on other silicon, this may be later expanded to
run in the suspend path for more scenarios.

Cc: stable@vger.kernel.org # 5.16+
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/linux-acpi/BL1PR12MB51570F5BD05980A0DCA1F3F4E23A9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#mee35f39c41a04b624700ab2621c795367f19c90e
Fixes: 8d89835b0467 ("PM: suspend: Do not pause cpuidle in the suspend-to-idle path")
Fixes: 23f62d7ab25b ("PM: sleep: Pause cpuidle later and resume it earlier during system transitions")
Fixes: 59348401ebed ("platform/x86: amd-pmc: Add special handling for timer based S0i3 wakeup"
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220223175237.6209-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 4c72ba68b315..b1103f85a85a 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/pm_qos.h>
 #include <linux/rtc.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
@@ -85,6 +86,9 @@
 #define PMC_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
 
+/* QoS request for letting CPUs in idle states, but not the deepest */
+#define AMD_PMC_MAX_IDLE_STATE_LATENCY	3
+
 #define SOC_SUBSYSTEM_IP_MAX	12
 #define DELAY_MIN_US		2000
 #define DELAY_MAX_US		3000
@@ -131,6 +135,7 @@ struct amd_pmc_dev {
 	struct device *dev;
 	struct pci_dev *rdev;
 	struct mutex lock; /* generic mutex lock */
+	struct pm_qos_request amd_pmc_pm_qos_req;
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbgfs_dir;
 #endif /* CONFIG_DEBUG_FS */
@@ -521,6 +526,14 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	rc = rtc_alarm_irq_enable(rtc_device, 0);
 	dev_dbg(pdev->dev, "wakeup timer programmed for %lld seconds\n", duration);
 
+	/*
+	 * Prevent CPUs from getting into deep idle states while sending OS_HINT
+	 * which is otherwise generally safe to send when at least one of the CPUs
+	 * is not in deep idle states.
+	 */
+	cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req, AMD_PMC_MAX_IDLE_STATE_LATENCY);
+	wake_up_all_idle_cpus();
+
 	return rc;
 }
 
@@ -538,24 +551,31 @@ static int __maybe_unused amd_pmc_suspend(struct device *dev)
 	/* Activate CZN specific RTC functionality */
 	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
 		rc = amd_pmc_verify_czn_rtc(pdev, &arg);
-		if (rc < 0)
-			return rc;
+		if (rc)
+			goto fail;
 	}
 
 	/* Dump the IdleMask before we send hint to SMU */
 	amd_pmc_idlemask_read(pdev, dev, NULL);
 	msg = amd_pmc_get_os_hint(pdev);
 	rc = amd_pmc_send_cmd(pdev, arg, NULL, msg, 0);
-	if (rc)
+	if (rc) {
 		dev_err(pdev->dev, "suspend failed\n");
+		goto fail;
+	}
 
 	if (enable_stb)
 		rc = amd_pmc_write_stb(pdev, AMD_PMC_STB_PREDEF);
-	if (rc)	{
+	if (rc) {
 		dev_err(pdev->dev, "error writing to STB\n");
-		return rc;
+		goto fail;
 	}
 
+	return 0;
+fail:
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
 	return rc;
 }
 
@@ -579,12 +599,15 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
 	/* Write data incremented by 1 to distinguish in stb_read */
 	if (enable_stb)
 		rc = amd_pmc_write_stb(pdev, AMD_PMC_STB_PREDEF + 1);
-	if (rc)	{
+	if (rc)
 		dev_err(pdev->dev, "error writing to STB\n");
-		return rc;
-	}
 
-	return 0;
+	/* Restore the QoS request back to defaults if it was set */
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
+
+	return rc;
 }
 
 static const struct dev_pm_ops amd_pmc_pm_ops = {
@@ -722,6 +745,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	amd_pmc_get_smu_version(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmc_dbgfs_register(dev);
+	cpu_latency_qos_add_request(&dev->amd_pmc_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 	return 0;
 
 err_pci_dev_put:

