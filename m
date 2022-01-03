Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD58483279
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiACO2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:28:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57588 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiACO1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:27:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA0A661117;
        Mon,  3 Jan 2022 14:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38DEC36AEB;
        Mon,  3 Jan 2022 14:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220027;
        bh=MV2zDrUtE+ibT1cbjDtAxUU4j9Hz+kYy8Xu/+LH0vPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs39JGPLU1epWMFc6A1VCCKGmiAg1pqigcCGj4RsULvIKS4LiklVToFxY5NFWNjL8
         af8AM2HX9Zy7jXdBpdu3qM0/gj/e8TMfSlX0gM677VMlf9w8qtc5IW4oMooO9j6ufw
         9nrhWN3aEJQoPOtF+y6VwwdaHEi+Y1wzdeZfb+LY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/37] Input: i8042 - add deferred probe support
Date:   Mon,  3 Jan 2022 15:23:41 +0100
Message-Id: <20220103142051.988148459@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9222ba68c3f4065f6364b99cc641b6b019ef2d42 ]

We've got a bug report about the non-working keyboard on ASUS ZenBook
UX425UA.  It seems that the PS/2 device isn't ready immediately at
boot but takes some seconds to get ready.  Until now, the only
workaround is to defer the probe, but it's available only when the
driver is a module.  However, many distros, including openSUSE as in
the original report, build the PS/2 input drivers into kernel, hence
it won't work easily.

This patch adds the support for the deferred probe for i8042 stuff as
a workaround of the problem above.  When the deferred probe mode is
enabled and the device couldn't be probed, it'll be repeated with the
standard deferred probe mechanism.

The deferred probe mode is enabled either via the new option
i8042.probe_defer or via the quirk table entry.  As of this patch, the
quirk table contains only ASUS ZenBook UX425UA.

The deferred probe part is based on Fabio's initial work.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1190256
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Samuel Čavoj <samuel@cavoj.net>
Link: https://lore.kernel.org/r/20211117063757.11380-1-tiwai@suse.de

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  2 +
 drivers/input/serio/i8042-x86ia64io.h         | 14 +++++
 drivers/input/serio/i8042.c                   | 54 ++++++++++++-------
 3 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e7f71df9daf1c..165abcb656c5b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1487,6 +1487,8 @@
 			architectures force reset to be always executed
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 	i8042.kbdreset	[HW] Reset device connected to KBD port
+	i8042.probe_defer
+			[HW] Allow deferred probing upon i8042 probe errors
 
 	i810=		[HW,DRM]
 
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 202e43a6ffae2..2bd33a28b97cc 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -995,6 +995,17 @@ static const struct dmi_system_id __initconst i8042_dmi_kbdreset_table[] = {
 	{ }
 };
 
+static const struct dmi_system_id i8042_dmi_probe_defer_table[] __initconst = {
+	{
+		/* ASUS ZenBook UX425UA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
+		},
+	},
+	{ }
+};
+
 #endif /* CONFIG_X86 */
 
 #ifdef CONFIG_PNP
@@ -1314,6 +1325,9 @@ static int __init i8042_platform_init(void)
 	if (dmi_check_system(i8042_dmi_kbdreset_table))
 		i8042_kbdreset = true;
 
+	if (dmi_check_system(i8042_dmi_probe_defer_table))
+		i8042_probe_defer = true;
+
 	/*
 	 * A20 was already enabled during early kernel init. But some buggy
 	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 6ff6b5710dd4e..bb76ff2f6b1d8 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -44,6 +44,10 @@ static bool i8042_unlock;
 module_param_named(unlock, i8042_unlock, bool, 0);
 MODULE_PARM_DESC(unlock, "Ignore keyboard lock.");
 
+static bool i8042_probe_defer;
+module_param_named(probe_defer, i8042_probe_defer, bool, 0);
+MODULE_PARM_DESC(probe_defer, "Allow deferred probing.");
+
 enum i8042_controller_reset_mode {
 	I8042_RESET_NEVER,
 	I8042_RESET_ALWAYS,
@@ -709,7 +713,7 @@ static int i8042_set_mux_mode(bool multiplex, unsigned char *mux_version)
  * LCS/Telegraphics.
  */
 
-static int __init i8042_check_mux(void)
+static int i8042_check_mux(void)
 {
 	unsigned char mux_version;
 
@@ -738,10 +742,10 @@ static int __init i8042_check_mux(void)
 /*
  * The following is used to test AUX IRQ delivery.
  */
-static struct completion i8042_aux_irq_delivered __initdata;
-static bool i8042_irq_being_tested __initdata;
+static struct completion i8042_aux_irq_delivered;
+static bool i8042_irq_being_tested;
 
-static irqreturn_t __init i8042_aux_test_irq(int irq, void *dev_id)
+static irqreturn_t i8042_aux_test_irq(int irq, void *dev_id)
 {
 	unsigned long flags;
 	unsigned char str, data;
@@ -768,7 +772,7 @@ static irqreturn_t __init i8042_aux_test_irq(int irq, void *dev_id)
  * verifies success by readinng CTR. Used when testing for presence of AUX
  * port.
  */
-static int __init i8042_toggle_aux(bool on)
+static int i8042_toggle_aux(bool on)
 {
 	unsigned char param;
 	int i;
@@ -796,7 +800,7 @@ static int __init i8042_toggle_aux(bool on)
  * the presence of an AUX interface.
  */
 
-static int __init i8042_check_aux(void)
+static int i8042_check_aux(void)
 {
 	int retval = -1;
 	bool irq_registered = false;
@@ -1003,7 +1007,7 @@ static int i8042_controller_init(void)
 
 		if (i8042_command(&ctr[n++ % 2], I8042_CMD_CTL_RCTR)) {
 			pr_err("Can't read CTR while initializing i8042\n");
-			return -EIO;
+			return i8042_probe_defer ? -EPROBE_DEFER : -EIO;
 		}
 
 	} while (n < 2 || ctr[0] != ctr[1]);
@@ -1318,7 +1322,7 @@ static void i8042_shutdown(struct platform_device *dev)
 	i8042_controller_reset(false);
 }
 
-static int __init i8042_create_kbd_port(void)
+static int i8042_create_kbd_port(void)
 {
 	struct serio *serio;
 	struct i8042_port *port = &i8042_ports[I8042_KBD_PORT_NO];
@@ -1346,7 +1350,7 @@ static int __init i8042_create_kbd_port(void)
 	return 0;
 }
 
-static int __init i8042_create_aux_port(int idx)
+static int i8042_create_aux_port(int idx)
 {
 	struct serio *serio;
 	int port_no = idx < 0 ? I8042_AUX_PORT_NO : I8042_MUX_PORT_NO + idx;
@@ -1383,13 +1387,13 @@ static int __init i8042_create_aux_port(int idx)
 	return 0;
 }
 
-static void __init i8042_free_kbd_port(void)
+static void i8042_free_kbd_port(void)
 {
 	kfree(i8042_ports[I8042_KBD_PORT_NO].serio);
 	i8042_ports[I8042_KBD_PORT_NO].serio = NULL;
 }
 
-static void __init i8042_free_aux_ports(void)
+static void i8042_free_aux_ports(void)
 {
 	int i;
 
@@ -1399,7 +1403,7 @@ static void __init i8042_free_aux_ports(void)
 	}
 }
 
-static void __init i8042_register_ports(void)
+static void i8042_register_ports(void)
 {
 	int i;
 
@@ -1440,7 +1444,7 @@ static void i8042_free_irqs(void)
 	i8042_aux_irq_registered = i8042_kbd_irq_registered = false;
 }
 
-static int __init i8042_setup_aux(void)
+static int i8042_setup_aux(void)
 {
 	int (*aux_enable)(void);
 	int error;
@@ -1482,7 +1486,7 @@ static int __init i8042_setup_aux(void)
 	return error;
 }
 
-static int __init i8042_setup_kbd(void)
+static int i8042_setup_kbd(void)
 {
 	int error;
 
@@ -1532,7 +1536,7 @@ static int i8042_kbd_bind_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-static int __init i8042_probe(struct platform_device *dev)
+static int i8042_probe(struct platform_device *dev)
 {
 	int error;
 
@@ -1597,6 +1601,7 @@ static struct platform_driver i8042_driver = {
 		.pm	= &i8042_pm_ops,
 #endif
 	},
+	.probe		= i8042_probe,
 	.remove		= i8042_remove,
 	.shutdown	= i8042_shutdown,
 };
@@ -1607,7 +1612,6 @@ static struct notifier_block i8042_kbd_bind_notifier_block = {
 
 static int __init i8042_init(void)
 {
-	struct platform_device *pdev;
 	int err;
 
 	dbg_init();
@@ -1623,17 +1627,29 @@ static int __init i8042_init(void)
 	/* Set this before creating the dev to allow i8042_command to work right away */
 	i8042_present = true;
 
-	pdev = platform_create_bundle(&i8042_driver, i8042_probe, NULL, 0, NULL, 0);
-	if (IS_ERR(pdev)) {
-		err = PTR_ERR(pdev);
+	err = platform_driver_register(&i8042_driver);
+	if (err)
 		goto err_platform_exit;
+
+	i8042_platform_device = platform_device_alloc("i8042", -1);
+	if (!i8042_platform_device) {
+		err = -ENOMEM;
+		goto err_unregister_driver;
 	}
 
+	err = platform_device_add(i8042_platform_device);
+	if (err)
+		goto err_free_device;
+
 	bus_register_notifier(&serio_bus, &i8042_kbd_bind_notifier_block);
 	panic_blink = i8042_panic_blink;
 
 	return 0;
 
+err_free_device:
+	platform_device_put(i8042_platform_device);
+err_unregister_driver:
+	platform_driver_unregister(&i8042_driver);
  err_platform_exit:
 	i8042_platform_exit();
 	return err;
-- 
2.34.1



