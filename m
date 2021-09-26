Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699F14188A6
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhIZMhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZMhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:37:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 225C461019;
        Sun, 26 Sep 2021 12:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632659764;
        bh=8VpK0bhzsbgRsqnyWjVxJz7Rp3oFS3HWtYYHJZiMwqk=;
        h=Subject:To:Cc:From:Date:From;
        b=nONmLSDXqkmaeU0qNlR1eYRIBuqpfiXgRBja/4F1p25qVt8f6JW9c2zKaZVLAx6GJ
         WvTu8k2TqrV2Es3B4bQBv1FbmjTlK6vrkXrVT21NnXy2F6EjdkjWQdE88IvMsKm7Gc
         gDB8gWifCUOpV/N0cKt/9DbLYx/8zWp86tIYUxyY=
Subject: FAILED: patch "[PATCH] USB: serial: cp210x: fix dropped characters with CP2102" failed to apply to 5.14-stable tree
To:     johan@kernel.org, malte@neo-soft.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 14:36:01 +0200
Message-ID: <1632659761259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c32dfec6c1c36bbbcd5d33e949d99aeb215877ec Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 22 Sep 2021 13:30:59 +0200
Subject: [PATCH] USB: serial: cp210x: fix dropped characters with CP2102

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

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 66a6ac50a4cd..b98454fe08ea 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -258,6 +258,7 @@ struct cp210x_serial_private {
 	speed_t			max_speed;
 	bool			use_actual_rate;
 	bool			no_flow_control;
+	bool			no_event_mode;
 };
 
 enum cp210x_event_state {
@@ -1113,12 +1114,16 @@ static void cp210x_change_speed(struct tty_struct *tty,
 
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
 
@@ -2074,6 +2079,33 @@ static void cp210x_init_max_speed(struct usb_serial *serial)
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
 static int cp210x_get_fw_version(struct usb_serial *serial, u16 value)
 {
 	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
@@ -2109,6 +2141,9 @@ static void cp210x_determine_type(struct usb_serial *serial)
 	}
 
 	switch (priv->partnum) {
+	case CP210X_PARTNUM_CP2102:
+		cp2102_determine_quirks(serial);
+		break;
 	case CP210X_PARTNUM_CP2105:
 	case CP210X_PARTNUM_CP2108:
 		cp210x_get_fw_version(serial, CP210X_GET_FW_VER);

