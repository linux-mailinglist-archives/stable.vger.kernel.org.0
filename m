Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4821A480418
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhL0THT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:07:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhL0TGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06A67B8113F;
        Mon, 27 Dec 2021 19:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B45BC36AFA;
        Mon, 27 Dec 2021 19:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631979;
        bh=rwGS9BX89pQDJJ3puaGbr1gD4wHw3mT3R4g5L/zM3u8=;
        h=From:To:Cc:Subject:Date:From;
        b=AHedOd8ODCEefLWqntNPweFb7mJvS+JAGv7hmsgYM0DkQNbilA1i1pgnzlXbJFolq
         3qBJoAI7ztwlDngz4hQZUAGLvs/ZEVCpYGB0y60pRUiyvGr2GdeC2dKNcBpEJgd8GY
         qvdYlf//hW0davZZAGtCzKfytpbr3IkH+NC0ylEgQaW4elJaGO3Ze3pkVqKW1sQPte
         /iaZHeziJDmZVJbY6qSGBOq2hGgdUOkEvvaGlyNoD5VAS034FpVzcejp+0R9vZmscM
         vrAxkc88uf5PxEhuC3pOTqraiWr8mB0OPu33SP8QrAmI76f8PnDgx/IuXqhiyaWJeZ
         XQ/ixI+lKXHDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, corbet@lwn.net,
        paulmck@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
        peterz@infradead.org, jroedel@suse.de, maz@kernel.org,
        macro@orcam.me.uk, viresh.kumar@linaro.org, robin.murphy@arm.com,
        rdunlap@infradead.org, vbabka@suse.cz, mpdesouza@suse.com,
        po-hsu.lin@canonical.com, arnd@arndb.de, adobriyan@gmail.com,
        tyson@tyson.me, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/6] Input: i8042 - add deferred probe support
Date:   Mon, 27 Dec 2021 14:06:05 -0500
Message-Id: <20211227190615.1043350-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index f179e20eb8a0b..662f9ed730e69 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1439,6 +1439,8 @@
 			architectures force reset to be always executed
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 	i8042.kbdreset	[HW] Reset device connected to KBD port
+	i8042.probe_defer
+			[HW] Allow deferred probing upon i8042 probe errors
 
 	i810=		[HW,DRM]
 
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index c218e107c0c8f..29179d42b467a 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -999,6 +999,17 @@ static const struct dmi_system_id __initconst i8042_dmi_kbdreset_table[] = {
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
@@ -1318,6 +1329,9 @@ static int __init i8042_platform_init(void)
 	if (dmi_check_system(i8042_dmi_kbdreset_table))
 		i8042_kbdreset = true;
 
+	if (dmi_check_system(i8042_dmi_probe_defer_table))
+		i8042_probe_defer = true;
+
 	/*
 	 * A20 was already enabled during early kernel init. But some buggy
 	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index c60593c8d2be5..082afbf088d67 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -48,6 +48,10 @@ static bool i8042_unlock;
 module_param_named(unlock, i8042_unlock, bool, 0);
 MODULE_PARM_DESC(unlock, "Ignore keyboard lock.");
 
+static bool i8042_probe_defer;
+module_param_named(probe_defer, i8042_probe_defer, bool, 0);
+MODULE_PARM_DESC(probe_defer, "Allow deferred probing.");
+
 enum i8042_controller_reset_mode {
 	I8042_RESET_NEVER,
 	I8042_RESET_ALWAYS,
@@ -702,7 +706,7 @@ static int i8042_set_mux_mode(bool multiplex, unsigned char *mux_version)
  * LCS/Telegraphics.
  */
 
-static int __init i8042_check_mux(void)
+static int i8042_check_mux(void)
 {
 	unsigned char mux_version;
 
@@ -731,10 +735,10 @@ static int __init i8042_check_mux(void)
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
@@ -761,7 +765,7 @@ static irqreturn_t __init i8042_aux_test_irq(int irq, void *dev_id)
  * verifies success by readinng CTR. Used when testing for presence of AUX
  * port.
  */
-static int __init i8042_toggle_aux(bool on)
+static int i8042_toggle_aux(bool on)
 {
 	unsigned char param;
 	int i;
@@ -789,7 +793,7 @@ static int __init i8042_toggle_aux(bool on)
  * the presence of an AUX interface.
  */
 
-static int __init i8042_check_aux(void)
+static int i8042_check_aux(void)
 {
 	int retval = -1;
 	bool irq_registered = false;
@@ -996,7 +1000,7 @@ static int i8042_controller_init(void)
 
 		if (i8042_command(&ctr[n++ % 2], I8042_CMD_CTL_RCTR)) {
 			pr_err("Can't read CTR while initializing i8042\n");
-			return -EIO;
+			return i8042_probe_defer ? -EPROBE_DEFER : -EIO;
 		}
 
 	} while (n < 2 || ctr[0] != ctr[1]);
@@ -1311,7 +1315,7 @@ static void i8042_shutdown(struct platform_device *dev)
 	i8042_controller_reset(false);
 }
 
-static int __init i8042_create_kbd_port(void)
+static int i8042_create_kbd_port(void)
 {
 	struct serio *serio;
 	struct i8042_port *port = &i8042_ports[I8042_KBD_PORT_NO];
@@ -1339,7 +1343,7 @@ static int __init i8042_create_kbd_port(void)
 	return 0;
 }
 
-static int __init i8042_create_aux_port(int idx)
+static int i8042_create_aux_port(int idx)
 {
 	struct serio *serio;
 	int port_no = idx < 0 ? I8042_AUX_PORT_NO : I8042_MUX_PORT_NO + idx;
@@ -1376,13 +1380,13 @@ static int __init i8042_create_aux_port(int idx)
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
 
@@ -1392,7 +1396,7 @@ static void __init i8042_free_aux_ports(void)
 	}
 }
 
-static void __init i8042_register_ports(void)
+static void i8042_register_ports(void)
 {
 	int i;
 
@@ -1444,7 +1448,7 @@ static void i8042_free_irqs(void)
 	i8042_aux_irq_registered = i8042_kbd_irq_registered = false;
 }
 
-static int __init i8042_setup_aux(void)
+static int i8042_setup_aux(void)
 {
 	int (*aux_enable)(void);
 	int error;
@@ -1486,7 +1490,7 @@ static int __init i8042_setup_aux(void)
 	return error;
 }
 
-static int __init i8042_setup_kbd(void)
+static int i8042_setup_kbd(void)
 {
 	int error;
 
@@ -1536,7 +1540,7 @@ static int i8042_kbd_bind_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-static int __init i8042_probe(struct platform_device *dev)
+static int i8042_probe(struct platform_device *dev)
 {
 	int error;
 
@@ -1601,6 +1605,7 @@ static struct platform_driver i8042_driver = {
 		.pm	= &i8042_pm_ops,
 #endif
 	},
+	.probe		= i8042_probe,
 	.remove		= i8042_remove,
 	.shutdown	= i8042_shutdown,
 };
@@ -1611,7 +1616,6 @@ static struct notifier_block i8042_kbd_bind_notifier_block = {
 
 static int __init i8042_init(void)
 {
-	struct platform_device *pdev;
 	int err;
 
 	dbg_init();
@@ -1627,17 +1631,29 @@ static int __init i8042_init(void)
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

