Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFF314B6AE
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgA1ODs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbgA1ODr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A510B205F4;
        Tue, 28 Jan 2020 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220227;
        bh=3WYhliuMA03MBRGzECpdvCSDV9LUr6dptENYDYnfFzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrAjLKqWuENMVQjVn+EAxzAaVJTDv1jtWwWnzG/ZShF2kxrYTwpwarXOe1zhWDzNy
         /sLAHDkWdP6CAbxvLqS6KGHhzH+4sPWnTmLU2l0mf8FjH0+o6S54BeowrgcFcx5dYL
         QoRshP9RTLTLVZFDFS5FVy1qattuqudS6cU92I0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 067/104] Input: aiptek - fix endpoint sanity check
Date:   Tue, 28 Jan 2020 15:00:28 +0100
Message-Id: <20200128135826.692736640@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3111491fca4f01764e0c158c5e0f7ced808eef51 upstream.

The driver was checking the number of endpoints of the first alternate
setting instead of the current one, something which could lead to the
driver binding to an invalid interface.

This in turn could cause the driver to misbehave or trigger a WARN() in
usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 8e20cf2bce12 ("Input: aiptek - fix crash on detecting device without endpoints")
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Vladis Dronov <vdronov@redhat.com>
Link: https://lore.kernel.org/r/20191210113737.4016-3-johan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/aiptek.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1802,14 +1802,14 @@ aiptek_probe(struct usb_interface *intf,
 	input_set_abs_params(inputdev, ABS_WHEEL, AIPTEK_WHEEL_MIN, AIPTEK_WHEEL_MAX - 1, 0, 0);
 
 	/* Verify that a device really has an endpoint */
-	if (intf->altsetting[0].desc.bNumEndpoints < 1) {
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
 		dev_err(&intf->dev,
 			"interface has %d endpoints, but must have minimum 1\n",
-			intf->altsetting[0].desc.bNumEndpoints);
+			intf->cur_altsetting->desc.bNumEndpoints);
 		err = -EINVAL;
 		goto fail3;
 	}
-	endpoint = &intf->altsetting[0].endpoint[0].desc;
+	endpoint = &intf->cur_altsetting->endpoint[0].desc;
 
 	/* Go set up our URB, which is called when the tablet receives
 	 * input.


