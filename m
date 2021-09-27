Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D336419132
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 10:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhI0JAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 05:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233519AbhI0JAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 05:00:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 150E960F24;
        Mon, 27 Sep 2021 08:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632733139;
        bh=2cr9DQzqdSZbGaYqRWHzcqDvTP+iY0z0NEltArLDvX8=;
        h=From:To:Cc:Subject:Date:From;
        b=WzhHmhc9Ny6DZ39mO5xvBFFl2s1OgfZNbCw85ofuKZZxVPwfKSYZh95lwivr42PnK
         aeUwf/wmb6Gt6ky+uqsPwOcLyG5l63alV3cXezfFu5MT7UNxGKQZ/vWHZhvak3MzWq
         wdl40SSEf4NyeREtTjs387OCaGA0k2YKlxZUKL973uT+Iiv88VGCHjsCby++r43VNs
         MMVOVCNzHh4kFfFu8ClNw6BgD/0UFUECNpKpwl2hL/L7IYZ1pwdTyI9PoZHm4mDSNy
         4QfnStXHUs60yreM/EXx1BtOJfOgSJoKgxUvsNNTWIgAuOME6iUR/qxYvdEVOVF+WB
         rLYQOAhFZRt+g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mUmTR-0003kI-Hj; Mon, 27 Sep 2021 10:58:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Malte Di Donato <malte@neo-soft.org>
Subject: [PATCH stable-5.14] USB: serial: cp210x: fix dropped characters with CP2102
Date:   Mon, 27 Sep 2021 10:58:19 +0200
Message-Id: <20210927085819.14346-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Link: https://lore.kernel.org/r/20210922113100.20888-1-johan@kernel.org
Cc: stable@vger.kernel.org	# 5.9
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: backport to 5.14; adjust context ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index d48bed5782a5..8ae3dca0384a 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -258,6 +258,7 @@ struct cp210x_serial_private {
 	speed_t			max_speed;
 	bool			use_actual_rate;
 	bool			no_flow_control;
+	bool			no_event_mode;
 };
 
 enum cp210x_event_state {
@@ -1112,12 +1113,16 @@ static void cp210x_change_speed(struct tty_struct *tty,
 
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
 
@@ -2097,6 +2102,33 @@ static void cp210x_init_max_speed(struct usb_serial *serial)
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
@@ -2122,6 +2154,9 @@ static void cp210x_determine_quirks(struct usb_serial *serial)
 	int ret;
 
 	switch (priv->partnum) {
+	case CP210X_PARTNUM_CP2102:
+		cp2102_determine_quirks(serial);
+		break;
 	case CP210X_PARTNUM_CP2102N_QFN28:
 	case CP210X_PARTNUM_CP2102N_QFN24:
 	case CP210X_PARTNUM_CP2102N_QFN20:
-- 
2.32.0

