Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E820E22F224
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgG0OLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbgG0OLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28B6920838;
        Mon, 27 Jul 2020 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859113;
        bh=3d40csHXYgAn1gKXI/bGgNGTJZgUioqvbt1dNEOH83A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vo7zG8UnvvX9X93xxLqzVL04UGZEjDHm5oU7Lavqc1LTONoOioYJi3QVI67FCTRmJ
         sbxq41gAyBMQU8SJht2dnO+otLC3PAPTFfylLMygMtaaYJb0CN4X1a1pFdFTQ3vQXv
         ZDMYcIHKIoFfrksNm/4OahYqzL8j6NSPjsckBpf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Forest Crossman <cyrozap@gmail.com>
Subject: [PATCH 4.19 63/86] usb: xhci: Fix ASM2142/ASM3142 DMA addressing
Date:   Mon, 27 Jul 2020 16:04:37 +0200
Message-Id: <20200727134917.589434945@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Forest Crossman <cyrozap@gmail.com>

commit dbb0897e805f2ab1b8bc358f6c3d878a376b8897 upstream.

The ASM2142/ASM3142 (same PCI IDs) does not support full 64-bit DMA
addresses, which can cause silent memory corruption or IOMMU errors on
platforms that use the upper bits. Add the XHCI_NO_64BIT_SUPPORT quirk
to fix this issue.

Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200717112734.328432-1-cyrozap@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -231,6 +231,9 @@ static void xhci_pci_quirks(struct devic
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 			pdev->device == 0x1142)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+			pdev->device == 0x2142)
+		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)


