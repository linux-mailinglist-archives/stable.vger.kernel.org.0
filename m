Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D00171ED0
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733189AbgB0OEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387566AbgB0OEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F5920578;
        Thu, 27 Feb 2020 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812275;
        bh=tkX7IT/camgFM6jbO3GLdfGBeihm6AXHJgh2WLvr+38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRMTdgaeUSMiZfad1K4XNnhTJlgaArlXLLx+U7q8beRUbqkjMJ/V4gWNgtuEje7BF
         rgQpsvrlK3nC0c9E82jcQRAjTlhoWQIXWYcBE52jq/gW1Xcv6897/CRLwZkGoMXNOC
         2xUzN6hYew+FDixi9DaI/ygoq7z5OQfEiTs83zWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 51/97] xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms
Date:   Thu, 27 Feb 2020 14:36:59 +0100
Message-Id: <20200227132222.924216246@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
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
@@ -41,6 +41,7 @@
 #define PCI_DEVICE_ID_INTEL_BROXTON_B_XHCI		0x1aa8
 #define PCI_DEVICE_ID_INTEL_APL_XHCI			0x5aa8
 #define PCI_DEVICE_ID_INTEL_DNV_XHCI			0x19d0
+#define PCI_DEVICE_ID_INTEL_CML_XHCI			0xa3af
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -179,7 +180,8 @@ static void xhci_pci_quirks(struct devic
 		 pdev->device == PCI_DEVICE_ID_INTEL_BROXTON_M_XHCI ||
 		 pdev->device == PCI_DEVICE_ID_INTEL_BROXTON_B_XHCI ||
 		 pdev->device == PCI_DEVICE_ID_INTEL_APL_XHCI ||
-		 pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI)) {
+		 pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI ||
+		 pdev->device == PCI_DEVICE_ID_INTEL_CML_XHCI)) {
 		xhci->quirks |= XHCI_PME_STUCK_QUIRK;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&


