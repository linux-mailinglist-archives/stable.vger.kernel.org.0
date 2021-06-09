Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DAB3A1AB9
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 18:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhFIQS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 12:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232495AbhFIQS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 12:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1777A6139A;
        Wed,  9 Jun 2021 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623255422;
        bh=aoS4Nnr3dcAhxk6EA9eUFcd5+UkcmrXUimOJqrEi27k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2/qkVBVtviahH0/vxhJxxYc5ZZmxxync5cEbVkLZxWTNQtdocwCcw+MaZdOpGzhK
         WnhN2QqOr+A6UutFN+UiAp2JnghVrq8QG+tYwhDq98r+CnRXNntNV154VpBdhXmbJt
         yF4vTm+V5D2Aj8kUOoIqNfAji2GAoSmPGiauLmUHC0DU1rxJ9k+n6agUmAu+rJCD8b
         u8kCbVunw3EhV4u4X3HIBEM43lerqqj45rAjRqe7We+iVGy3c/q0RUZkH5LOmMhvvC
         s2tTnfQAXhCgsfbUZzTgVC53qJyaGYnrPVq2uImCfRDPttnQqbcm4U4nl6GyxBgMqS
         nDWGz7+w9HYMQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lr0sx-0002Tp-3m; Wed, 09 Jun 2021 18:16:55 +0200
From:   Johan Hovold <johan@kernel.org>
To:     David Frey <dpfrey@gmail.com>,
        =?UTF-8?q?Alex=20Villac=C3=ADs=20Lasso?= <a_villacis@palosanto.com>
Cc:     linux-usb@vger.kernel.org, Pho Tran <pho.tran@silabs.com>,
        Tung Pham <tung.pham@silabs.com>, Hung.Nguyen@silabs.com,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] USB: serial: cp210x: fix CP2102N-A01 modem control
Date:   Wed,  9 Jun 2021 18:15:09 +0200
Message-Id: <20210609161509.9459-1-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YL87Na0MycRA6/fW@hovoldconsulting.com>
References: <YL87Na0MycRA6/fW@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CP2102N revision A01 (firmware version <= 1.0.4) has a buggy
flow-control implementation that uses the ulXonLimit instead of
ulFlowReplace field of the flow-control settings structure (erratum
CP2102N_E104).

A recent change that set the input software flow-control limits
incidentally broke RTS control for these devices when CRTSCTS is not set
as the new limits would always enable hardware flow control.

Fix this by explicitly disabling flow control for the buggy firmware
versions and only updating the input software flow-control limits when
IXOFF is requested. This makes sure that the terminal settings matches
the default zero ulXonLimit (ulFlowReplace) for these devices.

Reported-by: David Frey <dpfrey@gmail.com>
Reported-by: Alex Villacís Lasso <a_villacis@palosanto.com>
Fixes: f61309d9c96a ("USB: serial: cp210x: set IXOFF thresholds")
Cc: stable@vger.kernel.org      # 5.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 64 ++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 5 deletions(-)

David and Alex,

Would you mind testing this one with your CP2108N-A01? I've verified it
against a CP2108N-A02 (fw 1.0.8) here.

Johan


diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index ee595d1bea0a..910bc965e6cd 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -252,9 +252,11 @@ struct cp210x_serial_private {
 	u8			gpio_input;
 #endif
 	u8			partnum;
+	u32			fw_version;
 	speed_t			min_speed;
 	speed_t			max_speed;
 	bool			use_actual_rate;
+	bool			no_flow_control;
 };
 
 enum cp210x_event_state {
@@ -398,6 +400,7 @@ struct cp210x_special_chars {
 
 /* CP210X_VENDOR_SPECIFIC values */
 #define CP210X_READ_2NCONFIG	0x000E
+#define CP210X_GET_FW_VER_2N	0x0010
 #define CP210X_READ_LATCH	0x00C2
 #define CP210X_GET_PARTNUM	0x370B
 #define CP210X_GET_PORTCONFIG	0x370C
@@ -1122,6 +1125,7 @@ static bool cp210x_termios_change(const struct ktermios *a, const struct ktermio
 static void cp210x_set_flow_control(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
+	struct cp210x_serial_private *priv = usb_get_serial_data(port->serial);
 	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
 	struct cp210x_special_chars chars;
 	struct cp210x_flow_ctl flow_ctl;
@@ -1129,6 +1133,15 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 	u32 ctl_hs;
 	int ret;
 
+	/*
+	 * Some CP2102N interpret ulXonLimit as ulFlowReplace (erratum
+	 * CP2102N_E104). Report back that flow control is not supported.
+	 */
+	if (priv->no_flow_control) {
+		tty->termios.c_cflag &= ~CRTSCTS;
+		tty->termios.c_iflag &= ~(IXON | IXOFF);
+	}
+
 	if (old_termios &&
 			C_CRTSCTS(tty) == (old_termios->c_cflag & CRTSCTS) &&
 			I_IXON(tty) == (old_termios->c_iflag & IXON) &&
@@ -1185,19 +1198,20 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 		port_priv->crtscts = false;
 	}
 
-	if (I_IXOFF(tty))
+	if (I_IXOFF(tty)) {
 		flow_repl |= CP210X_SERIAL_AUTO_RECEIVE;
-	else
+
+		flow_ctl.ulXonLimit = cpu_to_le32(128);
+		flow_ctl.ulXoffLimit = cpu_to_le32(128);
+	} else {
 		flow_repl &= ~CP210X_SERIAL_AUTO_RECEIVE;
+	}
 
 	if (I_IXON(tty))
 		flow_repl |= CP210X_SERIAL_AUTO_TRANSMIT;
 	else
 		flow_repl &= ~CP210X_SERIAL_AUTO_TRANSMIT;
 
-	flow_ctl.ulXonLimit = cpu_to_le32(128);
-	flow_ctl.ulXoffLimit = cpu_to_le32(128);
-
 	dev_dbg(&port->dev, "%s - ctrl = 0x%02x, flow = 0x%02x\n", __func__,
 			ctl_hs, flow_repl);
 
@@ -1908,6 +1922,45 @@ static void cp210x_init_max_speed(struct usb_serial *serial)
 	priv->use_actual_rate = use_actual_rate;
 }
 
+static int cp210x_get_fw_version(struct usb_serial *serial, u16 value)
+{
+	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
+	u8 ver[3];
+	int ret;
+
+	ret = cp210x_read_vendor_block(serial, REQTYPE_DEVICE_TO_HOST, value,
+			ver, sizeof(ver));
+	if (ret)
+		return ret;
+
+	dev_dbg(&serial->interface->dev, "%s - %d.%d.%d\n", __func__,
+			ver[0], ver[1], ver[2]);
+
+	priv->fw_version = ver[0] << 16 | ver[1] << 8 | ver[2];
+
+	return 0;
+}
+
+static void cp210x_determine_quirks(struct usb_serial *serial)
+{
+	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
+	int ret;
+
+	switch (priv->partnum) {
+	case CP210X_PARTNUM_CP2102N_QFN28:
+	case CP210X_PARTNUM_CP2102N_QFN24:
+	case CP210X_PARTNUM_CP2102N_QFN20:
+		ret = cp210x_get_fw_version(serial, CP210X_GET_FW_VER_2N);
+		if (ret)
+			break;
+		if (priv->fw_version <= 0x10004)
+			priv->no_flow_control = true;
+		break;
+	default:
+		break;
+	}
+}
+
 static int cp210x_attach(struct usb_serial *serial)
 {
 	int result;
@@ -1928,6 +1981,7 @@ static int cp210x_attach(struct usb_serial *serial)
 
 	usb_set_serial_data(serial, priv);
 
+	cp210x_determine_quirks(serial);
 	cp210x_init_max_speed(serial);
 
 	result = cp210x_gpio_init(serial);
-- 
2.31.1

