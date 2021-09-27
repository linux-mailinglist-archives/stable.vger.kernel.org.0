Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482F541913A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhI0JCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 05:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233593AbhI0JCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 05:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D28660F24;
        Mon, 27 Sep 2021 09:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632733230;
        bh=xAZwg+lSydwOsUcTeez66x1D03IkBwER7qnzAYtH1cs=;
        h=From:To:Cc:Subject:Date:From;
        b=qFPa68IzE/5mgwe7cQSNpMiwKyqTJTCTrlR8RE9SkZq/1y7hMNgn3kbXHJkRlO9b8
         2cYh8ijKNxCqXggFuxDzPDQoqZ6aowhUBC1aPAKhuvdGKAQrS71kNrkbPzrghfXgNN
         snnTnJfC58AR0eCpqjXHN8nAf3mPLE3lGwO40UtH5UUZIhqw7sk0sAfe/zjTr+seF+
         QVjINZAKlnekMNTGE+n4gTx+LPJt7mhBXfCmFI9QB12NnGrxCc6OgS0BxEyq1VasTv
         +xJ5Yf//t4AY93AXd+j9+UuCPPeeYMmxgMkVhWP/9m6YaMFA7QgMMG22RThkCpRLaH
         zIBL17FQfwzHw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mUmUu-0003ld-MN; Mon, 27 Sep 2021 11:00:28 +0200
From:   Johan Hovold <johan@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Malte Di Donato <malte@neo-soft.org>
Subject: [PATCH stable-5.10] USB: serial: cp210x: fix dropped characters with CP2102
Date:   Mon, 27 Sep 2021 11:00:12 +0200
Message-Id: <20210927090012.14437-1-johan@kernel.org>
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
[ johan: backport to 5.10; adjust context, add quirk helper ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 329fc25f78a4..c30c84a7775b 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -260,6 +260,7 @@ struct cp210x_serial_private {
 	speed_t			min_speed;
 	speed_t			max_speed;
 	bool			use_actual_rate;
+	bool			no_event_mode;
 };
 
 enum cp210x_event_state {
@@ -1331,12 +1332,16 @@ static void cp210x_change_speed(struct tty_struct *tty,
 
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
 
@@ -2086,6 +2091,46 @@ static void cp210x_init_max_speed(struct usb_serial *serial)
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
@@ -2106,6 +2151,7 @@ static int cp210x_attach(struct usb_serial *serial)
 
 	usb_set_serial_data(serial, priv);
 
+	cp210x_determine_quirks(serial);
 	cp210x_init_max_speed(serial);
 
 	result = cp210x_gpio_init(serial);
-- 
2.32.0

