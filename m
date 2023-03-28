Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C54A6CC35C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjC1OxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjC1OxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553F1DBD6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D06F761840
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1918C433D2;
        Tue, 28 Mar 2023 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015184;
        bh=9LSW2dqzuyk0H0HULv/1KgDwMP+RdAmfgNEg1FM/cm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYcSshD3+Aa/s1mZNNbaGrIED06aTjBUrxk9r36P/xlBcxhFt1JamQ8U4DCToVYku
         IKF5CjhuJf9FT4H2cLGPNwhhCG4ZIidMNo9PGOa1MU7jT56Ns3dbwSrqxn71JsxWSo
         JU5P4GLprcndGxSwEnsAnxC69hyR+ynSrdG7jlb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.2 195/240] usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver
Date:   Tue, 28 Mar 2023 16:42:38 +0200
Message-Id: <20230328142627.783094075@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 96b96b2a567fb34dd41c87e6cf01f6902ce8cae4 upstream.

Patch changes CDNS_DEVICE_ID in USBSSP PCI Glue driver to remove
the conflict with Cadence USBSS driver.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230309063048.299378-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-pci.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

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
@@ -230,6 +223,8 @@ static const struct pci_device_id cdnsp_
 	  PCI_CLASS_SERIAL_USB_DEVICE, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_CDNS, CDNS_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  CDNS_DRD_IF, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_CDNS, CDNS_DRD_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  CDNS_DRD_IF, PCI_ANY_ID },
 	{ 0, }
 };
 


