Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69525439FAA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhJYTXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233394AbhJYTUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6CFE601FF;
        Mon, 25 Oct 2021 19:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189469;
        bh=9tza5uhDSKEAM5dmlD7mCIGhHn25KTRtUYhlRmmeYfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztmqaKKU/R2R9oJ3J5/SzhFwGsBT5N4htYwQuyLjQYOcX62ZKXrfvrAss5rm7Trc3
         YrRoihvx3RO6AHArPoPEg14F+MPTNifZMe0ELz95k5fLH4FYvBymxUX6ruFc2ADcpS
         emZon88dBj/bAmBBOywJolEnEPAOqh1MYXQbeHAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Martynov <mar.kolya@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.9 03/50] xhci: Enable trust tx length quirk for Fresco FL11 USB controller
Date:   Mon, 25 Oct 2021 21:13:50 +0200
Message-Id: <20211025190933.416798369@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
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
@@ -91,6 +92,7 @@ static void xhci_pci_quirks(struct devic
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
+			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100 ||
 			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
 		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 				pdev->revision == 0x0) {


