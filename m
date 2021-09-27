Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE096419B3D
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhI0RQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236591AbhI0RO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF219611C3;
        Mon, 27 Sep 2021 17:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762641;
        bh=5Su/h08uk/DNWDgXS4Cp5PL5uW4xFcBOJhy/xdwTe7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNdIaLwrrP0Ho99qENVbn8D0++T7se1rIxURf2d/mDnvSUSxvo+QN92/fAvJyrH7p
         niUjV9RlnKyLtUipIMDj4GGiVpt0/T4MmC4+oHRO56dDBeUgNnSMz4d05Dud5Do1jG
         jJA/2QoWzLWAYC4iodJfY1+8D5V1XvZJdGm1aK6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malte Di Donato <malte@neo-soft.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 101/103] USB: serial: cp210x: fix dropped characters with CP2102
Date:   Mon, 27 Sep 2021 19:03:13 +0200
Message-Id: <20210927170229.265199262@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit c32dfec6c1c36bbbcd5d33e949d99aeb215877ec upstream.

Some CP2102 do not support event-insertion mode but return no error when
attempting to enable it.

This means that any event escape characters in the input stream will not
be escaped by the device and consequently regular data may be
interpreted as escape sequences and be removed from the stream by the
driver.

The reporter's device has batch number DCL00X etched into it and as
discovered by the SHA2017 Badge team, counterfeit devices with that
marking can be detected by sending malformed vendor requests. [1][2]

Tests confirm that the possibly counterfeit CP2102 returns a single byte
in response to a malformed two-byte part-number request, while an
original CP2102 returns two bytes. Assume that every CP2102 that behaves
this way also does not support event-insertion mode (e.g. cannot report
parity errors).

[1] https://mobile.twitter.com/sha2017badge/status/1167902087289532418
[2] https://hackaday.com/2017/08/14/hands-on-with-the-shacamp-2017-badge/#comment-3903376

Reported-by: Malte Di Donato <malte@neo-soft.org>
Tested-by: Malte Di Donato <malte@neo-soft.org>
Fixes: a7207e9835a4 ("USB: serial: cp210x: add support for line-status events")
Cc: stable@vger.kernel.org	# 5.9
Link: https://lore.kernel.org/r/20210922113100.20888-1-johan@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |   46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -261,6 +261,7 @@ struct cp210x_serial_private {
 	speed_t			min_speed;
 	speed_t			max_speed;
 	bool			use_actual_rate;
+	bool			no_event_mode;
 };
 
 enum cp210x_event_state {
@@ -1332,12 +1333,16 @@ static void cp210x_change_speed(struct t
 
 static void cp210x_enable_event_mode(struct usb_serial_port *port)
 {
+	struct cp210x_serial_private *priv = usb_get_serial_data(port->serial);
 	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
 	int ret;
 
 	if (port_priv->event_mode)
 		return;
 
+	if (priv->no_event_mode)
+		return;
+
 	port_priv->event_state = ES_DATA;
 	port_priv->event_mode = true;
 
@@ -2087,6 +2092,46 @@ static void cp210x_init_max_speed(struct
 	priv->use_actual_rate = use_actual_rate;
 }
 
+static void cp2102_determine_quirks(struct usb_serial *serial)
+{
+	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
+	u8 *buf;
+	int ret;
+
+	buf = kmalloc(2, GFP_KERNEL);
+	if (!buf)
+		return;
+	/*
+	 * Some (possibly counterfeit) CP2102 do not support event-insertion
+	 * mode and respond differently to malformed vendor requests.
+	 * Specifically, they return one instead of two bytes when sent a
+	 * two-byte part-number request.
+	 */
+	ret = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+			CP210X_VENDOR_SPECIFIC, REQTYPE_DEVICE_TO_HOST,
+			CP210X_GET_PARTNUM, 0, buf, 2, USB_CTRL_GET_TIMEOUT);
+	if (ret == 1) {
+		dev_dbg(&serial->interface->dev,
+				"device does not support event-insertion mode\n");
+		priv->no_event_mode = true;
+	}
+
+	kfree(buf);
+}
+
+static void cp210x_determine_quirks(struct usb_serial *serial)
+{
+	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
+
+	switch (priv->partnum) {
+	case CP210X_PARTNUM_CP2102:
+		cp2102_determine_quirks(serial);
+		break;
+	default:
+		break;
+	}
+}
+
 static int cp210x_attach(struct usb_serial *serial)
 {
 	int result;
@@ -2107,6 +2152,7 @@ static int cp210x_attach(struct usb_seri
 
 	usb_set_serial_data(serial, priv);
 
+	cp210x_determine_quirks(serial);
 	cp210x_init_max_speed(serial);
 
 	result = cp210x_gpio_init(serial);


