Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAE0118630
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfLJL0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:26:22 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46963 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfLJL0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:26:22 -0500
Received: by mail-lj1-f195.google.com with SMTP id z17so19383448ljk.13;
        Tue, 10 Dec 2019 03:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VoeC8Gum0YS8PrWDUBi3I1lnOTW9TGly1+knOIyyCDI=;
        b=ti7O1+BetZ4wb1iNJcT+LhATZ56UsFhvPY9rOxTyFWbkKCHdar4f8rvWvVOTiPQH0f
         Cx1Xoye96Rz92POf/POuHrMZOoCUJ0HfiwodSRlXNspsrhFBDPkRhVVXnIx1L9/U/JEc
         eZPshCkeQgbLScgTTgbJlv143tJkY3z7ms7V3rXKziwtkN9k1iKs5QkRySou/054qGFS
         qALvntZYGgsPruhjsJwVcIo6Gy4zYm26oKzqNwYlJv/192f/V3n+jtc17wGlznsc0HDz
         cNQUo9uzckTAABl7FGdjBIeWraK1bCNpUmPDMmfwzsg9pUjcWUwRZVrD+HHYGDPEbXuA
         Tv4Q==
X-Gm-Message-State: APjAAAUR0405Eqt5Mb4kmQL8CDcPHsd2Nk7Z0FqgZOY1te8syXZN9yRE
        Ec85+lU37KcA24PiPBvSrr4=
X-Google-Smtp-Source: APXvYqxIZw+r35NZC4Ca+7QkhDj+4fd5AfViu2/GZkiwjfQ/1roh+yJ8+HobjDos1Jul3JCIOYX1Sw==
X-Received: by 2002:a2e:9143:: with SMTP id q3mr20677028ljg.199.1575977179623;
        Tue, 10 Dec 2019 03:26:19 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id s7sm1576813ljo.43.2019.12.10.03.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:26:18 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedem-0000wH-KQ; Tue, 10 Dec 2019 12:26:20 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/4] USB: atm: ueagle-atm: add missing endpoint check
Date:   Tue, 10 Dec 2019 12:25:58 +0100
Message-Id: <20191210112601.3561-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210112601.3561-1-johan@kernel.org>
References: <20191210112601.3561-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that the interrupt interface has an endpoint before trying to
access its endpoint descriptors to avoid dereferencing a NULL pointer.

The driver binds to the interrupt interface with interface number 0, but
must not assume that this interface or its current alternate setting are
the first entries in the corresponding configuration arrays.

Fixes: b72458a80c75 ("[PATCH] USB: Eagle and ADI 930 usb adsl modem driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.16
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/atm/ueagle-atm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 8b0ea8c70d73..635cf0466b59 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2124,10 +2124,11 @@ static void uea_intr(struct urb *urb)
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
 
@@ -2152,6 +2153,11 @@ static int uea_boot(struct uea_softc *sc)
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
@@ -2163,8 +2169,7 @@ static int uea_boot(struct uea_softc *sc)
 	usb_fill_int_urb(sc->urb_int, sc->usb_dev,
 			 usb_rcvintpipe(sc->usb_dev, UEA_INTR_PIPE),
 			 intr, size, uea_intr, sc,
-			 sc->usb_dev->actconfig->interface[0]->altsetting[0].
-			 endpoint[0].desc.bInterval);
+			 intf->cur_altsetting->endpoint[0].desc.bInterval);
 
 	ret = usb_submit_urb(sc->urb_int, GFP_KERNEL);
 	if (ret < 0) {
@@ -2179,6 +2184,7 @@ static int uea_boot(struct uea_softc *sc)
 	sc->kthread = kthread_create(uea_kthread, sc, "ueagle-atm");
 	if (IS_ERR(sc->kthread)) {
 		uea_err(INS_TO_USBDEV(sc), "failed to create thread\n");
+		ret = PTR_ERR(sc->kthread);
 		goto err2;
 	}
 
@@ -2193,7 +2199,7 @@ static int uea_boot(struct uea_softc *sc)
 	kfree(intr);
 err0:
 	uea_leaves(INS_TO_USBDEV(sc));
-	return -ENOMEM;
+	return ret;
 }
 
 /*
@@ -2548,7 +2554,7 @@ static int uea_bind(struct usbatm_data *usbatm, struct usb_interface *intf,
 		}
 	}
 
-	ret = uea_boot(sc);
+	ret = uea_boot(sc, intf);
 	if (ret < 0)
 		goto error;
 
-- 
2.24.0

