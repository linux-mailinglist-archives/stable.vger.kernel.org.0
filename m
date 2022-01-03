Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AB3483238
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiACOZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56000 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiACOZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BD8960FA2;
        Mon,  3 Jan 2022 14:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07424C36AEB;
        Mon,  3 Jan 2022 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219928;
        bh=CTKojC1ShDEUvmIXrIsMZrl7CZ7FiWIRZZiYC9o5kjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ot4p5ETHT+mKnFmbezA/KI5FZDyPBDsJ/mOCGjYdTtTHOsm3h60KvbnONnonkBlvO
         9WEg1aEK/LCKrsx3zJ4bpc8+WWzRaN0T3P7fI/tgyNEareqnI/gv+IOcKzGC3vJmfm
         XeYUGz+MS6uC6/2b0u288wrc0F45cLUnPq1uFLvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Martynov <mar.kolya@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 20/27] xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.
Date:   Mon,  3 Jan 2022 15:24:00 +0100
Message-Id: <20220103142052.822143703@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
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
@@ -90,7 +90,6 @@ static void xhci_pci_quirks(struct devic
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
-			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100 ||
 			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
 		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 				pdev->revision == 0x0) {
@@ -125,6 +124,10 @@ static void xhci_pci_quirks(struct devic
 			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1009)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
+			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100)
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
 		xhci->quirks |= XHCI_NEC_HOST;
 


