Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B44414B993
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgA1Od3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:33:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732869AbgA1OZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14D121739;
        Tue, 28 Jan 2020 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221510;
        bh=C80hO95fUlhePgToChD8CSc4I8Aj6cloQwLGUMaNs+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyyRYAlEw7hxIGLGSb0ZEkRxpnQoes8dIU+2sIfRjgdEw856q2f4dsdV6AjwMYjqu
         x+9CmW/a9TawulEnXH3vSwWAmQMCsrJqVBEkHiWmbn+dXOpKc6g4tPqnRhNPGpb9rk
         2KWKpV3XLXdNr5pqevsuNdCcqWMqhAjKa3/Xl/5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.9 253/271] Input: gtco - fix endpoint sanity check
Date:   Tue, 28 Jan 2020 15:06:42 +0100
Message-Id: <20200128135911.409469855@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a8eeb74df5a6bdb214b2b581b14782c5f5a0cf83 upstream.

The driver was checking the number of endpoints of the first alternate
setting instead of the current one, something which could lead to the
driver binding to an invalid interface.

This in turn could cause the driver to misbehave or trigger a WARN() in
usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 162f98dea487 ("Input: gtco - fix crash on detecting device without endpoints")
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Vladis Dronov <vdronov@redhat.com>
Link: https://lore.kernel.org/r/20191210113737.4016-5-johan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/gtco.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -875,18 +875,14 @@ static int gtco_probe(struct usb_interfa
 	}
 
 	/* Sanity check that a device has an endpoint */
-	if (usbinterface->altsetting[0].desc.bNumEndpoints < 1) {
+	if (usbinterface->cur_altsetting->desc.bNumEndpoints < 1) {
 		dev_err(&usbinterface->dev,
 			"Invalid number of endpoints\n");
 		error = -EINVAL;
 		goto err_free_urb;
 	}
 
-	/*
-	 * The endpoint is always altsetting 0, we know this since we know
-	 * this device only has one interrupt endpoint
-	 */
-	endpoint = &usbinterface->altsetting[0].endpoint[0].desc;
+	endpoint = &usbinterface->cur_altsetting->endpoint[0].desc;
 
 	/* Some debug */
 	dev_dbg(&usbinterface->dev, "gtco # interfaces: %d\n", usbinterface->num_altsetting);
@@ -973,7 +969,7 @@ static int gtco_probe(struct usb_interfa
 	input_dev->dev.parent = &usbinterface->dev;
 
 	/* Setup the URB, it will be posted later on open of input device */
-	endpoint = &usbinterface->altsetting[0].endpoint[0].desc;
+	endpoint = &usbinterface->cur_altsetting->endpoint[0].desc;
 
 	usb_fill_int_urb(gtco->urbinfo,
 			 udev,


