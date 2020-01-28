Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE37814BAD1
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgA1OOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729819AbgA1OOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A486B2468E;
        Tue, 28 Jan 2020 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220848;
        bh=N2yMitmW+bURp6dgZaaSsfFa0kb7TjFta9YQBQYuVVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHi1ykTYpyWrnmlHc3zJn1rphENKV2YddNx/JMY1KVc99+tC0paZVAQNqzuwtnGhQ
         JLTsrmSb6Egasnh05BbvjuN5966zIAZ4sL7cTp0+uek/r1vYumq1J84qq5eANcCNSc
         iZ1Ag95uYPMFFEp4P9AOedB0pa0UjyalgXHBbZTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 171/183] Input: gtco - fix endpoint sanity check
Date:   Tue, 28 Jan 2020 15:06:30 +0100
Message-Id: <20200128135846.827190584@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
@@ -876,18 +876,14 @@ static int gtco_probe(struct usb_interfa
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
@@ -974,7 +970,7 @@ static int gtco_probe(struct usb_interfa
 	input_dev->dev.parent = &usbinterface->dev;
 
 	/* Setup the URB, it will be posted later on open of input device */
-	endpoint = &usbinterface->altsetting[0].endpoint[0].desc;
+	endpoint = &usbinterface->cur_altsetting->endpoint[0].desc;
 
 	usb_fill_int_urb(gtco->urbinfo,
 			 gtco->usbdev,


