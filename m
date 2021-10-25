Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7053C439F11
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhJYTRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233815AbhJYTRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A1B4600D3;
        Mon, 25 Oct 2021 19:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189281;
        bh=PgNQvzE+8QdulzOOEO+c+cEBGSB8D6ePzPKb3hUMeJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1HwZxsTWYuj2ucIFNkqVWQ72btKST+/HhC5ykFUzgrqdnJxBtwP8kWd7c8/RIIh3
         BXpwmTK2GePNGXcRh0UMSUSCT6PsiNnrSUsh6yASBQ2Q1Vkg6t+BZwFkW39Q78f0p6
         qC/zwLegO/t4zGN2ksYXxjqRPlWJkVu1IsatqoQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Martynov <mar.kolya@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.4 03/44] xhci: Enable trust tx length quirk for Fresco FL11 USB controller
Date:   Mon, 25 Oct 2021 21:13:44 +0200
Message-Id: <20211025190929.326119077@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Martynov <mar.kolya@gmail.com>

commit ea0f69d8211963c4b2cc1998b86779a500adb502 upstream.

Tested on SD5200T TB3 dock which has Fresco Logic FL1100 USB 3.0 Host
Controller.
Before this patch streaming video from USB cam made mouse and keyboard
connected to the same USB bus unusable. Also video was jerky.
With this patch streaming video doesn't have any effect on other
periferals and video is smooth.

Cc: stable@vger.kernel.org
Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211008092547.3996295-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -38,6 +38,7 @@
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1009	0x1009
+#define PCI_DEVICE_ID_FRESCO_LOGIC_FL1100	0x1100
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1400	0x1400
 
 #define PCI_VENDOR_ID_ETRON		0x1b6f
@@ -90,6 +91,7 @@ static void xhci_pci_quirks(struct devic
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
+			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100 ||
 			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
 		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 				pdev->revision == 0x0) {


