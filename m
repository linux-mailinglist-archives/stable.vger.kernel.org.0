Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA9F1E773A
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 09:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgE2Hll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 03:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgE2Hlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 03:41:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B8B20810;
        Fri, 29 May 2020 07:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590738100;
        bh=dO7H8/ASzN8PqPoGgz9MHXYUzd4Bu+PpMHZaPiQDv2Q=;
        h=Subject:To:From:Date:From;
        b=niziWEtY86GP3q/NnfgKKMp9ZJb933KQxuhcXWWFEsg01DmIBfrYT5oMhdPQJF+Vr
         PAzZcPpWggdzBT9lcvbjMENWMbHTH+pRJ48HswBESsHNLf5yKQaHmSg+4G5ZaEiuzz
         Rq2yUJnFc5ss3Y4Tft+11G4o4gvCn1h4ul5m63VA=
Subject: patch "USB: serial: ch341: fix lockup of devices with limited prescaler" added to usb-testing
To:     johan@kernel.org, public@hansmi.ch, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 29 May 2020 09:41:28 +0200
Message-ID: <1590738088179163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ch341: fix lockup of devices with limited prescaler

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c432df155919582a3cefa35a8f86256c830fa9a4 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 14 May 2020 11:36:45 +0200
Subject: USB: serial: ch341: fix lockup of devices with limited prescaler

Michael Hanselmann reports that

	[a] subset of all CH341 devices stop responding to bulk
	transfers, usually after the third byte, when the highest
	prescaler bit (0b100) is set. There is one exception, namely a
	prescaler of exactly 0b111 (fact=1, ps=3).

Fix this by forcing a lower base clock (fact = 0) whenever needed.

This specifically makes the standard rates 110, 134 and 200 bps work
again with these devices.

Fixes: 35714565089e ("USB: serial: ch341: reimplement line-speed handling")
Cc: stable <stable@vger.kernel.org>	# 5.5
Reported-by: Michael Hanselmann <public@hansmi.ch>
Link: https://lore.kernel.org/r/20200514141743.GE25962@localhost
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index f2b93f4554a7..89675ee29645 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -73,6 +73,8 @@
 #define CH341_LCR_CS6          0x01
 #define CH341_LCR_CS5          0x00
 
+#define CH341_QUIRK_LIMITED_PRESCALER	BIT(0)
+
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
@@ -160,9 +162,11 @@ static const speed_t ch341_min_rates[] = {
  *		2 <= div <= 256 if fact = 0, or
  *		9 <= div <= 256 if fact = 1
  */
-static int ch341_get_divisor(speed_t speed)
+static int ch341_get_divisor(struct ch341_private *priv)
 {
 	unsigned int fact, div, clk_div;
+	speed_t speed = priv->baud_rate;
+	bool force_fact0 = false;
 	int ps;
 
 	/*
@@ -188,8 +192,12 @@ static int ch341_get_divisor(speed_t speed)
 	clk_div = CH341_CLK_DIV(ps, fact);
 	div = CH341_CLKRATE / (clk_div * speed);
 
+	/* Some devices require a lower base clock if ps < 3. */
+	if (ps < 3 && (priv->quirks & CH341_QUIRK_LIMITED_PRESCALER))
+		force_fact0 = true;
+
 	/* Halve base clock (fact = 0) if required. */
-	if (div < 9 || div > 255) {
+	if (div < 9 || div > 255 || force_fact0) {
 		div /= 2;
 		clk_div *= 2;
 		fact = 0;
@@ -228,7 +236,7 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	if (!priv->baud_rate)
 		return -EINVAL;
 
-	val = ch341_get_divisor(priv->baud_rate);
+	val = ch341_get_divisor(priv);
 	if (val < 0)
 		return -EINVAL;
 
@@ -333,6 +341,7 @@ static int ch341_detect_quirks(struct usb_serial_port *port)
 			    CH341_REG_BREAK, 0, buffer, size, DEFAULT_TIMEOUT);
 	if (r == -EPIPE) {
 		dev_dbg(&port->dev, "break control not supported\n");
+		quirks = CH341_QUIRK_LIMITED_PRESCALER;
 		r = 0;
 		goto out;
 	}
-- 
2.26.2


