Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9C56BCEA8
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCPLqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCPLqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:46:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EF9A1FF5
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 04:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38A4FB820CB
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 11:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D0CC433EF;
        Thu, 16 Mar 2023 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678967167;
        bh=s6IX7znc58EQtVW6oapiuCRxTEMZAl/OR9hhfXLn9ww=;
        h=Subject:To:From:Date:From;
        b=yt/FI5lr8CuA7nIAF+2v2P/ZEXLl5JFrVqxKJZR6Z/wxVxxmRI+akqVgE6nokjozK
         2EDJWku/f56zXcctgfTrqJ5+vmZ3+siQpv8ZlV0WgwJM6G5ha5jV+4NlOz78gJT41N
         c0WJXlGkIMgYb7UDyD1O3ZKZj7QDAbZRqWI8BeiQ=
Subject: patch "usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Mar 2023 12:45:50 +0100
Message-ID: <167896715021548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 96b96b2a567fb34dd41c87e6cf01f6902ce8cae4 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Thu, 9 Mar 2023 01:30:48 -0500
Subject: usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver

Patch changes CDNS_DEVICE_ID in USBSSP PCI Glue driver to remove
the conflict with Cadence USBSS driver.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230309063048.299378-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-pci.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-pci.c b/drivers/usb/cdns3/cdnsp-pci.c
index efd54ed918b9..7b151f5af3cc 100644
--- a/drivers/usb/cdns3/cdnsp-pci.c
+++ b/drivers/usb/cdns3/cdnsp-pci.c
@@ -29,30 +29,23 @@
 #define PLAT_DRIVER_NAME	"cdns-usbssp"
 
 #define CDNS_VENDOR_ID		0x17cd
-#define CDNS_DEVICE_ID		0x0100
+#define CDNS_DEVICE_ID		0x0200
+#define CDNS_DRD_ID		0x0100
 #define CDNS_DRD_IF		(PCI_CLASS_SERIAL_USB << 8 | 0x80)
 
 static struct pci_dev *cdnsp_get_second_fun(struct pci_dev *pdev)
 {
-	struct pci_dev *func;
-
 	/*
 	 * Gets the second function.
-	 * It's little tricky, but this platform has two function.
-	 * The fist keeps resources for Host/Device while the second
-	 * keeps resources for DRD/OTG.
+	 * Platform has two function. The fist keeps resources for
+	 * Host/Device while the secon keeps resources for DRD/OTG.
 	 */
-	func = pci_get_device(pdev->vendor, pdev->device, NULL);
-	if (!func)
-		return NULL;
+	if (pdev->device == CDNS_DEVICE_ID)
+		return  pci_get_device(pdev->vendor, CDNS_DRD_ID, NULL);
+	else if (pdev->device == CDNS_DRD_ID)
+		return pci_get_device(pdev->vendor, CDNS_DEVICE_ID, NULL);
 
-	if (func->devfn == pdev->devfn) {
-		func = pci_get_device(pdev->vendor, pdev->device, func);
-		if (!func)
-			return NULL;
-	}
-
-	return func;
+	return NULL;
 }
 
 static int cdnsp_pci_probe(struct pci_dev *pdev,
@@ -230,6 +223,8 @@ static const struct pci_device_id cdnsp_pci_ids[] = {
 	  PCI_CLASS_SERIAL_USB_DEVICE, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_CDNS, CDNS_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  CDNS_DRD_IF, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_CDNS, CDNS_DRD_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  CDNS_DRD_IF, PCI_ANY_ID },
 	{ 0, }
 };
 
-- 
2.40.0


