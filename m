Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B247F26C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405838AbfHBJsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405831AbfHBJsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:48:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 730D92086A;
        Fri,  2 Aug 2019 09:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739294;
        bh=7IWG8TuhT4R5+XGGcFt1xYMtCoyUQsfDNejMvWZnSAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACrWCmb5jjPLYBRWZJF0QgH3k26B7KCR3gynniCs9QLbExhoK2UnziXF/ehtgxNIh
         xWym9v9RkK/2ccWbwYW861X8RbNsUGW7gylRzw8CtjI5buMP+ctX2r/7/K4dxs4kxT
         OSPWmTYvjAq9gOnpHqbww6EQXHO9/b0mBENhurqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 178/223] PCI: xilinx-nwl: Fix Multi MSI data programming
Date:   Fri,  2 Aug 2019 11:36:43 +0200
Message-Id: <20190802092249.274158991@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 181fa434d0514e40ebf6e9721f2b72700287b6e2 ]

According to the PCI Local Bus specification Revision 3.0,
section 6.8.1.3 (Message Control for MSI), endpoints that
are Multiple Message Capable as defined by bits [3:1] in
the Message Control for MSI can request a number of vectors
that is power of two aligned.

As specified in section 6.8.1.6 "Message data for MSI", the Multiple
Message Enable field (bits [6:4] of the Message Control register)
defines the number of low order message data bits the function is
permitted to modify to generate its system software allocated
vectors.

The MSI controller in the Xilinx NWL PCIe controller supports a number
of MSI vectors specified through a bitmap and the hwirq number for an
MSI, that is the value written in the MSI data TLP is determined by
the bitmap allocation.

For instance, in a situation where two endpoints sitting on
the PCI bus request the following MSI configuration, with
the current PCI Xilinx bitmap allocation code (that does not
align MSI vector allocation on a power of two boundary):

Endpoint #1: Requesting 1 MSI vector - allocated bitmap bits 0
Endpoint #2: Requesting 2 MSI vectors - allocated bitmap bits [1,2]

The bitmap value(s) corresponds to the hwirq number that is programmed
into the Message Data for MSI field in the endpoint MSI capability
and is detected by the root complex to fire the corresponding
MSI irqs. The value written in Message Data for MSI field corresponds
to the first bit allocated in the bitmap for Multi MSI vectors.

The current Xilinx NWL MSI allocation code allows a bitmap allocation
that is not a power of two boundaries, so endpoint #2, is allowed to
toggle Message Data bit[0] to differentiate between its two vectors
(meaning that the MSI data will be respectively 0x0 and 0x1 for the two
vectors allocated to endpoint #2).

This clearly aliases with the Endpoint #1 vector allocation, resulting
in a broken Multi MSI implementation.

Update the code to allocate MSI bitmap ranges with a power of two
alignment, fixing the bug.

Fixes: ab597d35ef11 ("PCI: xilinx-nwl: Add support for Xilinx NWL PCIe Host Controller")
Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
[lorenzo.pieralisi@arm.com: updated commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pcie-xilinx-nwl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/host/pcie-xilinx-nwl.c b/drivers/pci/host/pcie-xilinx-nwl.c
index 94fdd295aae2..3bba87af0b6b 100644
--- a/drivers/pci/host/pcie-xilinx-nwl.c
+++ b/drivers/pci/host/pcie-xilinx-nwl.c
@@ -456,15 +456,13 @@ static int nwl_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	int i;
 
 	mutex_lock(&msi->lock);
-	bit = bitmap_find_next_zero_area(msi->bitmap, INT_PCI_MSI_NR, 0,
-					 nr_irqs, 0);
-	if (bit >= INT_PCI_MSI_NR) {
+	bit = bitmap_find_free_region(msi->bitmap, INT_PCI_MSI_NR,
+				      get_count_order(nr_irqs));
+	if (bit < 0) {
 		mutex_unlock(&msi->lock);
 		return -ENOSPC;
 	}
 
-	bitmap_set(msi->bitmap, bit, nr_irqs);
-
 	for (i = 0; i < nr_irqs; i++) {
 		irq_domain_set_info(domain, virq + i, bit + i, &nwl_irq_chip,
 				domain->host_data, handle_simple_irq,
@@ -482,7 +480,8 @@ static void nwl_irq_domain_free(struct irq_domain *domain, unsigned int virq,
 	struct nwl_msi *msi = &pcie->msi;
 
 	mutex_lock(&msi->lock);
-	bitmap_clear(msi->bitmap, data->hwirq, nr_irqs);
+	bitmap_release_region(msi->bitmap, data->hwirq,
+			      get_count_order(nr_irqs));
 	mutex_unlock(&msi->lock);
 }
 
-- 
2.20.1



