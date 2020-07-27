Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7422EFB3
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbgG0OSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731229AbgG0OS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF9720825;
        Mon, 27 Jul 2020 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859506;
        bh=N1qsdZkVZAZPDuNUk4mKrFEbtKcn95AWfSjOjhwaCH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W86SqpXyDx4yR1YzxlQ8cf9u0t4vT0Ye2MkVvHvBWoQ66ZNLOGOMZ+BXPPQw5g5oQ
         HowuuZt1MvpEXpz4+pJy28I89nLvKxR6A81tBGAunlbtZEiTYXh2NJ67o46HPOuBrp
         bKz81YWfU2YK5eAV5DTSr4qGjBhN9JGgOPA8/iwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Forest Crossman <cyrozap@gmail.com>
Subject: [PATCH 5.4 106/138] usb: xhci: Fix ASM2142/ASM3142 DMA addressing
Date:   Mon, 27 Jul 2020 16:05:01 +0200
Message-Id: <20200727134930.769999735@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
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
@@ -250,6 +250,9 @@ static void xhci_pci_quirks(struct devic
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 			pdev->device == 0x1142)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+			pdev->device == 0x2142)
+		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)


