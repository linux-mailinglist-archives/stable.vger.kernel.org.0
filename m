Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEF24831E2
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiACOWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:22:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45740 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiACOWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:22:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AFA6CE1106;
        Mon,  3 Jan 2022 14:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8758C36AED;
        Mon,  3 Jan 2022 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219748;
        bh=eugLGpTGn+/eEZJ+vY9eml6QvjGs1nrbMrVIQXJbJlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N09NzqslvxpLf8av6FfF05ue9BomDcYXa6fpFG/dONkSGL8uUv+8CIEb7TRd2XWRo
         bWUuDxyYHnwsiHeoSWYbUGRxsUTccrqYooxN7X2BcGCfRb2cRtEYDO/w9Xr7QJXjqc
         5deZ7rHlpFc+6Wum3jfutv/OICeTW8Z2frSDoIr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Martynov <mar.kolya@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.9 08/13] xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.
Date:   Mon,  3 Jan 2022 15:21:24 +0100
Message-Id: <20220103142052.229974035@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
References: <20220103142051.979780231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit e4844092581ceec22489b66c42edc88bc6079783 upstream.

The Fresco Logic FL1100 controller needs the TRUST_TX_LENGTH quirk like
other Fresco controllers, but should not have the BROKEN_MSI quirks set.

BROKEN_MSI quirk causes issues in detecting usb drives connected to docks
with this FL1100 controller.
The BROKEN_MSI flag was apparently accidentally set together with the
TRUST_TX_LENGTH quirk

Original patch went to stable so this should go there as well.

Fixes: ea0f69d82119 ("xhci: Enable trust tx length quirk for Fresco FL11 USB controller")
Cc: stable@vger.kernel.org
cc: Nikolay Martynov <mar.kolya@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211221112825.54690-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -92,7 +92,6 @@ static void xhci_pci_quirks(struct devic
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
-			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100 ||
 			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
 		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 				pdev->revision == 0x0) {
@@ -127,6 +126,10 @@ static void xhci_pci_quirks(struct devic
 			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1009)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
+			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100)
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
 		xhci->quirks |= XHCI_NEC_HOST;
 


