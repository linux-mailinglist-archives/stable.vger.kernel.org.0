Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BC74FCEF8
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbiDLFbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348171AbiDLFbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:31:04 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F149734B84;
        Mon, 11 Apr 2022 22:28:46 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q19so16163771pgm.6;
        Mon, 11 Apr 2022 22:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kqvbcpax/5BAvE+/ITwARKXkAXpTcgQy8gm5SuvjC6o=;
        b=ZcIVE89X1+hWFRJaOVnv6PrxP5fbvf8YB54F5CXTckyzOYq7JYYjwf18poOuGNfuiW
         In1zcr3nEWET11R5AHJi79rz/bM2A+4PvhRC8WxeuPqxsKrjyxrhzdBU+XlznzuZiuNY
         th8OlWBWOZUFuTAMPfEeLdgJ+oCN/CzktkenLhpYojJ/Yy7QndORWCRx/kteXITv7Xyv
         eBNYS97w+YyhyOh0DtbM2E2baPRGLFoupsXp2NpFiKw55GOObcnXHCqAHorXrZHbisH1
         ZmP5ylGcxXWtM38HjTkEqNjJmntSXU14Fi0KKDFIRIHiUsn+MLK9deXry9SDiXBkpJ1t
         bS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kqvbcpax/5BAvE+/ITwARKXkAXpTcgQy8gm5SuvjC6o=;
        b=AHZaVzsbtyqkl/m2cVRwpJP5BBCDx7X7cgUT6VRzK+j3ZnN3xtScYY687z1aa3GnKc
         GpLNqQ04fhjAksnrv9fYDTQPn3dwHkWcalQmAqjVOrOzGPpVim0x3IhHJPD4dQMkHcem
         2W+pORLiZf0SICPBtm3eEGFYWWyNcsJvT1B8f8T/7O2Do5w123ohvapzABYGQIKiDDZB
         ld/wHRnu3yI+SJf5V4sMv8GAVBfU2axOG2fPPULBu5AGSt9J/pgW/1f1Iln6hoQiwZmn
         GpvRfiKzqfBoZltasx7YKRFhg3nP5a1qVRdmhMnIp9Ssd2t60QVBqrkF78Qwc1NwDrq3
         6/aw==
X-Gm-Message-State: AOAM532SCNCvU+BrsTE1QpyPIFlt8gkhGuzyUeKn91wGcmVOIsgJNBz5
        G4n+nspr7fvmukun0u80XbKLDExGU/zmfNj4gpg=
X-Google-Smtp-Source: ABdhPJyoeifAqNgiVXqpYgaoA7v2/HTQtCeSvNVqGRMddCtATt49pV6+TQzimFILxMjRvLYPtnMwww==
X-Received: by 2002:a65:6e0e:0:b0:399:26d7:a224 with SMTP id bd14-20020a656e0e000000b0039926d7a224mr29270516pgb.437.1649741326417;
        Mon, 11 Apr 2022 22:28:46 -0700 (PDT)
Received: from jason-ThinkPad-T14-Gen-1.lan ([66.187.5.142])
        by smtp.gmail.com with ESMTPSA id k6-20020a056a00134600b004faba67f9d4sm38014628pfu.197.2022.04.11.22.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 22:28:45 -0700 (PDT)
From:   Hongyu Xie <xy521521@gmail.com>
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org,
        "sheng . huang" <sheng.huang@ecastech.com>
Subject: [PATCH -next] USB: serial: pl2303: implement reset_resume member
Date:   Tue, 12 Apr 2022 13:28:36 +0800
Message-Id: <20220412052836.123021-1-xy521521@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongyu Xie <xiehongyu1@kylinos.cn>

pl2303.c doesn't have reset_resume for hibernation.
So needs_binding will be set to 1 duiring hibernation.
usb_forced_unbind_intf will be called, and the port minor
will be released (x in ttyUSBx).
It works fine if you have only one USB-to-serial device.
Assume you have 2 USB-to-serial device, nameing A and B.
A gets a smaller minor(ttyUSB0), B gets a bigger one.
And start to hibernate. When your PC is in hibernation,
unplug device A. Then wake up your PC by pressing the
power button. After waking up the whole system, device
B gets ttyUSB0. This will casuse a problem if you were
using those to ports(like opened two minicom process)
before hibernation.
So member reset_resume is needed in usb_serial_driver
pl2303_device.
Codes in pl2303_reset_resume are borrowed from pl2303_open.

As a matter of fact, all driver under drivers/usb/serial
has the same problem except ch341.c.

Cc: stable@vger.kernel.org
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Reported-by: sheng.huang <sheng.huang@ecastech.com>
---
 drivers/usb/serial/pl2303.c | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 88b284d61681..7cc05123b88c 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1218,6 +1218,53 @@ static void pl2303_process_read_urb(struct urb *urb)
 	tty_flip_buffer_push(&port->port);
 }
 
+static int pl2303_configure(struct usb_serial *serial, struct pl2303_serial_private *priv)
+{
+	struct usb_serial_port *port = serial->port[0];
+
+	if (priv->quirks & PL2303_QUIRK_LEGACY) {
+		usb_clear_halt(serial->dev, port->write_urb->pipe);
+		usb_clear_halt(serial->dev, port->read_urb->pipe);
+	} else {
+		/* reset upstream data pipes */
+		if (priv->type == &pl2303_type_data[TYPE_HXN])
+			pl2303_vendor_write(serial, PL2303_HXN_RESET_REG,
+					PL2303_HXN_RESET_UPSTREAM_PIPE |
+					PL2303_HXN_RESET_DOWNSTREAM_PIPE);
+		else {
+			pl2303_vendor_write(serial, 8, 0);
+			pl2303_vendor_write(serial, 9, 0);
+		}
+	}
+	return 0;
+}
+
+static int pl2303_reset_resume(struct usb_serial *serial)
+{
+	struct usb_serial_port *port = serial->port[0];
+	struct pl2303_serial_private *priv = usb_get_serial_port_data(port);
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
+	int ret;
+
+	/* reconfigure pl2303 serial port after bus-reset */
+	pl2303_configure(serial, priv);
+
+	/* Setup termios */
+	if (tty)
+		pl2303_set_termios(tty, port, NULL);
+
+	if (tty_port_initialized(&port->port)) {
+		ret = usb_submit_urb(port->interrupt_in_urb, GFP_NOIO);
+		if (ret) {
+			dev_err(&port->dev, "failed to submit interrupt urb: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	return usb_serial_generic_resume(serial);
+}
+
 static struct usb_serial_driver pl2303_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -1246,6 +1293,7 @@ static struct usb_serial_driver pl2303_device = {
 	.release =		pl2303_release,
 	.port_probe =		pl2303_port_probe,
 	.port_remove =		pl2303_port_remove,
+	.reset_resume =         pl2303_reset_resume,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {
-- 
2.25.1

