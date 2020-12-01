Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335EA2C9A1F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgLAIz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgLAIzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:55:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 974A02224D;
        Tue,  1 Dec 2020 08:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812892;
        bh=VvoB9O3rvgqVIAQwDatIjWbfAN0MypYcrzKss5mVpEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGybDBatXs0JivLZpLlmZ6hB1UvxNXPm49B6ZrA+NKnmH/fEh9nKvVP860k78i9PM
         g/XZMIiCJem6i5Ot4YlJSL7pLLTEWLDsnuQgaLRGstZcQz/qeGm6gKyvdCSZRtT3Eu
         73m5wBekPhTpZ1xj5rAn5/eIpIwTIMcD17AiUkEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Marius Iacob <themariusus@gmail.com>
Subject: [PATCH 4.9 12/42] Input: i8042 - allow insmod to succeed on devices without an i8042 controller
Date:   Tue,  1 Dec 2020 09:53:10 +0100
Message-Id: <20201201084642.756650256@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b1884583fcd17d6a1b1bba94bbb5826e6b5c6e17 ]

The i8042 module exports several symbols which may be used by other
modules.

Before this commit it would refuse to load (when built as a module itself)
on systems without an i8042 controller.

This is a problem specifically for the asus-nb-wmi module. Many Asus
laptops support the Asus WMI interface. Some of them have an i8042
controller and need to use i8042_install_filter() to filter some kbd
events. Other models do not have an i8042 controller (e.g. they use an
USB attached kbd).

Before this commit the asus-nb-wmi driver could not be loaded on Asus
models without an i8042 controller, when the i8042 code was built as
a module (as Arch Linux does) because the module_init function of the
i8042 module would fail with -ENODEV and thus the i8042_install_filter
symbol could not be loaded.

This commit fixes this by exiting from module_init with a return code
of 0 if no controller is found.  It also adds a i8042_present bool to
make the module_exit function a no-op in this case and also adds a
check for i8042_present to the exported i8042_command function.

The latter i8042_present check should not really be necessary because
when builtin that function can already be used on systems without
an i8042 controller, but better safe then sorry.

Reported-and-tested-by: Marius Iacob <themariusus@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201008112628.3979-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index c84c685056b99..6b648339733fa 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -125,6 +125,7 @@ module_param_named(unmask_kbd_data, i8042_unmask_kbd_data, bool, 0600);
 MODULE_PARM_DESC(unmask_kbd_data, "Unconditional enable (may reveal sensitive data) of normally sanitize-filtered kbd data traffic debug log [pre-condition: i8042.debug=1 enabled]");
 #endif
 
+static bool i8042_present;
 static bool i8042_bypass_aux_irq_test;
 static char i8042_kbd_firmware_id[128];
 static char i8042_aux_firmware_id[128];
@@ -343,6 +344,9 @@ int i8042_command(unsigned char *param, int command)
 	unsigned long flags;
 	int retval;
 
+	if (!i8042_present)
+		return -1;
+
 	spin_lock_irqsave(&i8042_lock, flags);
 	retval = __i8042_command(param, command);
 	spin_unlock_irqrestore(&i8042_lock, flags);
@@ -1597,12 +1601,15 @@ static int __init i8042_init(void)
 
 	err = i8042_platform_init();
 	if (err)
-		return err;
+		return (err == -ENODEV) ? 0 : err;
 
 	err = i8042_controller_check();
 	if (err)
 		goto err_platform_exit;
 
+	/* Set this before creating the dev to allow i8042_command to work right away */
+	i8042_present = true;
+
 	pdev = platform_create_bundle(&i8042_driver, i8042_probe, NULL, 0, NULL, 0);
 	if (IS_ERR(pdev)) {
 		err = PTR_ERR(pdev);
@@ -1621,6 +1628,9 @@ static int __init i8042_init(void)
 
 static void __exit i8042_exit(void)
 {
+	if (!i8042_present)
+		return;
+
 	platform_device_unregister(i8042_platform_device);
 	platform_driver_unregister(&i8042_driver);
 	i8042_platform_exit();
-- 
2.27.0



