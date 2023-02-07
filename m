Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC5068D7D3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjBGNDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjBGNDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53CD3A98
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:03:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EAB0B8198D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1581C4339C;
        Tue,  7 Feb 2023 13:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775010;
        bh=Pgsc/Ke2fc3o8t/JwRY1CzYB/K43bwv9r7tb7aTZx0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLJhffshaCg7cFClvv9Xc3Yny1LZEV0I6h6AHUFGoD5hyTD1SlUOKPQgPM5V/1qap
         aopyq2phj7Hu5ZQq1I5uaCtzxFe6Ebv+syfiirZ3Ff+lVP6cgk7HWekwNRrYAmjS7p
         owxb8srdObxtlJIBQzdDWLFIwJZx8wDBc7awaJbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Xaver Hugl <xaver.hugl@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/208] platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN
Date:   Tue,  7 Feb 2023 13:56:01 +0100
Message-Id: <20230207125639.204225884@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8e60615e8932167057b363c11a7835da7f007106 ]

By default when the system is configured for low power idle in the FADT
the keyboard is set up as a wake source.  This matches the behavior that
Windows uses for Modern Standby as well.

It has been reported that a variety of AMD based designs there are
spurious wakeups are happening where two IRQ sources are active.

For example:
```
PM: Triggering wakeup from IRQ 9
PM: Triggering wakeup from IRQ 1
```

In these designs IRQ 9 is the ACPI SCI and IRQ 1 is the keyboard.
One way to trigger this problem is to suspend the laptop and then unplug
the AC adapter.  The SOC will be in a hardware sleep state and plugging
in the AC adapter returns control to the kernel's s2idle loop.

Normally if just IRQ 9 was active the s2idle loop would advance any EC
transactions and no other IRQ being active would cause the s2idle loop
to put the SOC back into hardware sleep state.

When this bug occurred IRQ 1 is also active even if no keyboard activity
occurred. This causes the s2idle loop to break and the system to wake.

This is a platform firmware bug triggering IRQ1 without keyboard activity.
This occurs in Windows as well, but Windows will enter "SW DRIPS" and
then with no activity enters back into "HW DRIPS" (hardware sleep state).

This issue affects Renoir, Lucienne, Cezanne, and Barcelo platforms. It
does not happen on newer systems such as Mendocino or Rembrandt.

It's been fixed in newer platform firmware.  To avoid triggering the bug
on older systems check the SMU F/W version and adjust the policy at suspend
time for s2idle wakeup from keyboard on these systems. A lot of thought
and experimentation has been given around the timing of disabling IRQ1,
and to make it work the "suspend" PM callback is restored.

Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2115
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1951
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230120191519.15926-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 50 ++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 8d924986381b..be1b49824edb 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
+#include <linux/serio.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
@@ -653,6 +654,33 @@ static int amd_pmc_get_os_hint(struct amd_pmc_dev *dev)
 	return -EINVAL;
 }
 
+static int amd_pmc_czn_wa_irq1(struct amd_pmc_dev *pdev)
+{
+	struct device *d;
+	int rc;
+
+	if (!pdev->major) {
+		rc = amd_pmc_get_smu_version(pdev);
+		if (rc)
+			return rc;
+	}
+
+	if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
+		return 0;
+
+	d = bus_find_device_by_name(&serio_bus, NULL, "serio0");
+	if (!d)
+		return 0;
+	if (device_may_wakeup(d)) {
+		dev_info_once(d, "Disabling IRQ1 wakeup source to avoid platform firmware bug\n");
+		disable_irq_wake(1);
+		device_set_wakeup_enable(d, false);
+	}
+	put_device(d);
+
+	return 0;
+}
+
 static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 {
 	struct rtc_device *rtc_device;
@@ -782,6 +810,25 @@ static struct acpi_s2idle_dev_ops amd_pmc_s2idle_dev_ops = {
 	.check = amd_pmc_s2idle_check,
 	.restore = amd_pmc_s2idle_restore,
 };
+
+static int __maybe_unused amd_pmc_suspend_handler(struct device *dev)
+{
+	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
+
+	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
+		int rc = amd_pmc_czn_wa_irq1(pdev);
+
+		if (rc) {
+			dev_err(pdev->dev, "failed to adjust keyboard wakeup: %d\n", rc);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(amd_pmc_pm, amd_pmc_suspend_handler, NULL);
+
 #endif
 
 static const struct pci_device_id pmc_pci_ids[] = {
@@ -980,6 +1027,9 @@ static struct platform_driver amd_pmc_driver = {
 		.name = "amd_pmc",
 		.acpi_match_table = amd_pmc_acpi_ids,
 		.dev_groups = pmc_groups,
+#ifdef CONFIG_SUSPEND
+		.pm = &amd_pmc_pm,
+#endif
 	},
 	.probe = amd_pmc_probe,
 	.remove = amd_pmc_remove,
-- 
2.39.0



