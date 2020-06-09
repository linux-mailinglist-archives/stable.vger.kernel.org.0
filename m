Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663851F4383
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbgFIRx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731621AbgFIRxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8CE20774;
        Tue,  9 Jun 2020 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725230;
        bh=cVDViZWwgHNsufUmT2I+Hp2X1qg/QoZVvKpHAG/7+i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAPwyxAOw1F+WwuWJE6MeFPzxtMg2tT0OqhMoH26skMcDrhCCjoy/T80R99pLkKZl
         3kTf9s7RRLfShGRN9SmHyhBXD1bLhzN9hftq6cEmzzNrNWsH/QR2aIGwliZPOeyIfg
         l9l9PsGqMr/lOABNESYK858+CPUoNkimHn+GITE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Hanselmann <public@hansmi.ch>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.6 22/41] USB: serial: ch341: fix lockup of devices with limited prescaler
Date:   Tue,  9 Jun 2020 19:45:24 +0200
Message-Id: <20200609174114.240869918@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit c432df155919582a3cefa35a8f86256c830fa9a4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ch341.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

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
@@ -160,9 +162,11 @@ static const speed_t ch341_min_rates[] =
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
@@ -188,8 +192,12 @@ static int ch341_get_divisor(speed_t spe
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
@@ -228,7 +236,7 @@ static int ch341_set_baudrate_lcr(struct
 	if (!priv->baud_rate)
 		return -EINVAL;
 
-	val = ch341_get_divisor(priv->baud_rate);
+	val = ch341_get_divisor(priv);
 	if (val < 0)
 		return -EINVAL;
 
@@ -333,6 +341,7 @@ static int ch341_detect_quirks(struct us
 			    CH341_REG_BREAK, 0, buffer, size, DEFAULT_TIMEOUT);
 	if (r == -EPIPE) {
 		dev_dbg(&port->dev, "break control not supported\n");
+		quirks = CH341_QUIRK_LIMITED_PRESCALER;
 		r = 0;
 		goto out;
 	}


