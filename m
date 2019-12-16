Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3C51218A7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfLPR5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbfLPR5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:57:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A1302176D;
        Mon, 16 Dec 2019 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519054;
        bh=OqlRxJ+gCG0jNsJDOzcwV1OoSPzgSFE98BB7xYlWdpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QS6UXKsLEhC9hES5IDOGfKRnsMkYu8Xem/AqLvaihiVNnkAnjZZtG2bORlunRz1yA
         bIHqrELj8tOJLdxdmZvF6ylKhlanFic21DmxNIgsDNNlUlAipVThp6iM/nOZ/JXQFJ
         uXfGXjsxdZJjAnRyg0a1oHFCcAl9CpEimqY/Xhuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 175/267] USB: atm: ueagle-atm: add missing endpoint check
Date:   Mon, 16 Dec 2019 18:48:21 +0100
Message-Id: <20191216174912.090812754@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 09068c1ad53fb077bdac288869dec2435420bdc4 upstream.

Make sure that the interrupt interface has an endpoint before trying to
access its endpoint descriptors to avoid dereferencing a NULL pointer.

The driver binds to the interrupt interface with interface number 0, but
must not assume that this interface or its current alternate setting are
the first entries in the corresponding configuration arrays.

Fixes: b72458a80c75 ("[PATCH] USB: Eagle and ADI 930 usb adsl modem driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210112601.3561-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/atm/ueagle-atm.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2167,10 +2167,11 @@ resubmit:
 /*
  * Start the modem : init the data and start kernel thread
  */
-static int uea_boot(struct uea_softc *sc)
+static int uea_boot(struct uea_softc *sc, struct usb_interface *intf)
 {
-	int ret, size;
 	struct intr_pkt *intr;
+	int ret = -ENOMEM;
+	int size;
 
 	uea_enters(INS_TO_USBDEV(sc));
 
@@ -2195,6 +2196,11 @@ static int uea_boot(struct uea_softc *sc
 	if (UEA_CHIP_VERSION(sc) == ADI930)
 		load_XILINX_firmware(sc);
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
+		ret = -ENODEV;
+		goto err0;
+	}
+
 	intr = kmalloc(size, GFP_KERNEL);
 	if (!intr)
 		goto err0;
@@ -2206,8 +2212,7 @@ static int uea_boot(struct uea_softc *sc
 	usb_fill_int_urb(sc->urb_int, sc->usb_dev,
 			 usb_rcvintpipe(sc->usb_dev, UEA_INTR_PIPE),
 			 intr, size, uea_intr, sc,
-			 sc->usb_dev->actconfig->interface[0]->altsetting[0].
-			 endpoint[0].desc.bInterval);
+			 intf->cur_altsetting->endpoint[0].desc.bInterval);
 
 	ret = usb_submit_urb(sc->urb_int, GFP_KERNEL);
 	if (ret < 0) {
@@ -2222,6 +2227,7 @@ static int uea_boot(struct uea_softc *sc
 	sc->kthread = kthread_create(uea_kthread, sc, "ueagle-atm");
 	if (IS_ERR(sc->kthread)) {
 		uea_err(INS_TO_USBDEV(sc), "failed to create thread\n");
+		ret = PTR_ERR(sc->kthread);
 		goto err2;
 	}
 
@@ -2236,7 +2242,7 @@ err1:
 	kfree(intr);
 err0:
 	uea_leaves(INS_TO_USBDEV(sc));
-	return -ENOMEM;
+	return ret;
 }
 
 /*
@@ -2597,7 +2603,7 @@ static int uea_bind(struct usbatm_data *
 	if (ret < 0)
 		goto error;
 
-	ret = uea_boot(sc);
+	ret = uea_boot(sc, intf);
 	if (ret < 0)
 		goto error_rm_grp;
 


