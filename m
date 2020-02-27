Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A417A171F12
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733119AbgB0OC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730081AbgB0OC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7564B20578;
        Thu, 27 Feb 2020 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812145;
        bh=b0I/F1hHri+BUOIuCvlBEDr2TqA3GxI8B+o2roqph7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2eCsOEQkHxNfJpTKKEEFCAmhtzgp1mt2yof894xm1vUxunHBSqghvtdgQ3v/8Fz6
         12tnjV80v270ecWx3+LoMxCNrxFNjnmoU6qyqtxR9nud5/AcFZ5gBlG2RjAjmUUk2y
         Ky+thBCs5d9kpsWUe3a2jDxteT2yusI8Te9yMzrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 201/237] xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms
Date:   Thu, 27 Feb 2020 14:36:55 +0100
Message-Id: <20200227132311.063777382@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit a3ae87dce3a5abe0b57c811bab02b2564b574106 upstream.

Intel Comet Lake based platform require the XHCI_PME_STUCK_QUIRK
quirk as well. Without this xHC can not enter D3 in runtime suspend.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200210134553.9144-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -53,6 +53,7 @@
 #define PCI_DEVICE_ID_INTEL_BROXTON_B_XHCI		0x1aa8
 #define PCI_DEVICE_ID_INTEL_APL_XHCI			0x5aa8
 #define PCI_DEVICE_ID_INTEL_DNV_XHCI			0x19d0
+#define PCI_DEVICE_ID_INTEL_CML_XHCI			0xa3af
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -191,7 +192,8 @@ static void xhci_pci_quirks(struct devic
 		 pdev->device == PCI_DEVICE_ID_INTEL_BROXTON_M_XHCI ||
 		 pdev->device == PCI_DEVICE_ID_INTEL_BROXTON_B_XHCI ||
 		 pdev->device == PCI_DEVICE_ID_INTEL_APL_XHCI ||
-		 pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI)) {
+		 pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI ||
+		 pdev->device == PCI_DEVICE_ID_INTEL_CML_XHCI)) {
 		xhci->quirks |= XHCI_PME_STUCK_QUIRK;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&


