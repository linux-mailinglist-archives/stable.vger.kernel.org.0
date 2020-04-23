Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAFD1B68E2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgDWXSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:18:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49038 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728281AbgDWXGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:38 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-0004fU-Kr; Fri, 24 Apr 2020 00:06:31 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvN-00E6mB-SS; Fri, 24 Apr 2020 00:06:29 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 24 Apr 2020 00:05:16 +0100
Message-ID: <lsq.1587683028.516575867@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 089/245] USB: atm: ueagle-atm: add missing endpoint check
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 09068c1ad53fb077bdac288869dec2435420bdc4 upstream.

Make sure that the interrupt interface has an endpoint before trying to
access its endpoint descriptors to avoid dereferencing a NULL pointer.

The driver binds to the interrupt interface with interface number 0, but
must not assume that this interface or its current alternate setting are
the first entries in the corresponding configuration arrays.

Fixes: b72458a80c75 ("[PATCH] USB: Eagle and ADI 930 usb adsl modem driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210112601.3561-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/atm/ueagle-atm.c | 18 ++++++++++++------
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
 	if (!intr) {
 		uea_err(INS_TO_USBDEV(sc),
@@ -2211,8 +2217,7 @@ static int uea_boot(struct uea_softc *sc
 	usb_fill_int_urb(sc->urb_int, sc->usb_dev,
 			 usb_rcvintpipe(sc->usb_dev, UEA_INTR_PIPE),
 			 intr, size, uea_intr, sc,
-			 sc->usb_dev->actconfig->interface[0]->altsetting[0].
-			 endpoint[0].desc.bInterval);
+			 intf->cur_altsetting->endpoint[0].desc.bInterval);
 
 	ret = usb_submit_urb(sc->urb_int, GFP_KERNEL);
 	if (ret < 0) {
@@ -2227,6 +2232,7 @@ static int uea_boot(struct uea_softc *sc
 	sc->kthread = kthread_create(uea_kthread, sc, "ueagle-atm");
 	if (IS_ERR(sc->kthread)) {
 		uea_err(INS_TO_USBDEV(sc), "failed to create thread\n");
+		ret = PTR_ERR(sc->kthread);
 		goto err2;
 	}
 
@@ -2241,7 +2247,7 @@ err1:
 	kfree(intr);
 err0:
 	uea_leaves(INS_TO_USBDEV(sc));
-	return -ENOMEM;
+	return ret;
 }
 
 /*
@@ -2604,7 +2610,7 @@ static int uea_bind(struct usbatm_data *
 	if (ret < 0)
 		goto error;
 
-	ret = uea_boot(sc);
+	ret = uea_boot(sc, intf);
 	if (ret < 0)
 		goto error_rm_grp;
 

