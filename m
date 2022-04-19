Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCA45064E0
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 08:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiDSG5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 02:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbiDSG5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 02:57:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1465030F7F;
        Mon, 18 Apr 2022 23:54:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso1445555pjj.2;
        Mon, 18 Apr 2022 23:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kqvbcpax/5BAvE+/ITwARKXkAXpTcgQy8gm5SuvjC6o=;
        b=S4mhLO+spXNoihYrWOSiuqg4uAn+VblPH2JfsFQCeqpAW/yLpSqrudKuXsKe5xT65q
         Wcm4KBtaopLWodfCOnrGN46YHk4dDBI7xSs/y5mTtJ1zsIWMuZoLibV4XZ2+ydLhlqDu
         8RAXcM7zJJHGCjLcx0UH/WZS7NcKuWpcmxHmTP7+6rEMuX+k6ysVlqKgntwE73OZJiWu
         U0wHNnAPGjM89kieqlfmzEMegCXkPBrW99j2RwtEocJqVIChPbKGK7dUh8y2my0Bmug+
         xy1CkMNDAEsRDTLgKeAdRqprNNy5rqzrW6a5W2NIIdQgw00tUpSgif5RrXZYGqHna2r6
         hrdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kqvbcpax/5BAvE+/ITwARKXkAXpTcgQy8gm5SuvjC6o=;
        b=rRXZPdtsqbsq7Dr1WUI4hxbESH2hybL5eT7aQrLz0T3RmE6toLIsEixt1itXds6gRQ
         I3G+5xWf7Vim0HaQmPzTiTOuNJOmS83HNQZ/T/XFkxCJBBz6tfttJ5OgXZKbB0qOyKBR
         0+6A8hN6SXPWhwlTxTl7G0SbIScIJro6E5Z72+b95oRMbr5U7zPskrypxVE7PkzoosVC
         OkVLDmwzFdB6VTVTEFKKkfYCqMkOb4lkRTRHhk6bEKDUdwNBxFzlHCHwLcQzHl7VBnxX
         +pfdn/CZi/Rt4xugkU+NXF+tYhJc3K/EEgFKeU4P5atJEnxayqHk9DD4LVKIVTuTysb0
         HX6g==
X-Gm-Message-State: AOAM5331sXNk+yUma+y7OAWhJN4rDLxhL55zXeE7iI3vI8j+VZcXK4iw
        Hh0sBXb/0CQHPIyNbu2DKzN+ShpENDe0yPJnKCpycnHo
X-Google-Smtp-Source: ABdhPJwwMGTl3mPiYBEKALnueEoRiJfQukZIEIg81vwAaBGk62VyfOB2IYbCH1bfx0+rgeUDxJEwAA==
X-Received: by 2002:a17:902:ef43:b0:156:9c5d:b0fe with SMTP id e3-20020a170902ef4300b001569c5db0femr14318517plx.158.1650351266500;
        Mon, 18 Apr 2022 23:54:26 -0700 (PDT)
Received: from jason-ThinkPad-T14-Gen-1.lan ([66.187.5.142])
        by smtp.gmail.com with ESMTPSA id q60-20020a17090a17c200b001cd567fecaesm14678960pja.26.2022.04.18.23.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 23:54:25 -0700 (PDT)
From:   Hongyu Xie <xy521521@gmail.com>
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org,
        "sheng . huang" <sheng.huang@ecastech.com>
Subject: [RESEND PATCH -next] USB: serial: pl2303: implement reset_resume member
Date:   Tue, 19 Apr 2022 14:54:08 +0800
Message-Id: <20220419065408.2461091-1-xy521521@gmail.com>
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

