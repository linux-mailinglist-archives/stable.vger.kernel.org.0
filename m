Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E594FD430
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352929AbiDLHqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356566AbiDLHi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:38:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE67851E7E;
        Tue, 12 Apr 2022 00:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF07A6171D;
        Tue, 12 Apr 2022 07:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EE8C385A6;
        Tue, 12 Apr 2022 07:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747391;
        bh=zAEdai6cbaxAvjJX+0dGNKGh6l0UBG2suy9fMVtv2wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nw7vQFuoqFQb3b09+C/zI2W1IPxntRAM7+QT4VcTBJdFmEscFmWoZWRmH33zAEfDP
         HfZiL6qdbNQdyeD6E2/3QQ89wtnQy7Ggvm/k5PVz+E89qyAfnnOkP/VXvjsvGylzgO
         ij9/kuxjqYxihzUtun1yC+duDTrUfUNC4xz3RPJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 060/343] PCI: aardvark: Fix support for MSI interrupts
Date:   Tue, 12 Apr 2022 08:27:58 +0200
Message-Id: <20220412062952.835560550@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b0b0b8b897f8e12b2368e868bd7cdc5742d5c5a9 ]

Aardvark hardware supports Multi-MSI and MSI_FLAG_MULTI_PCI_MSI is already
set for the MSI chip. But when allocating MSI interrupt numbers for
Multi-MSI, the numbers need to be properly aligned, otherwise endpoint
devices send MSI interrupt with incorrect numbers.

Fix this issue by using function bitmap_find_free_region() instead of
bitmap_find_next_zero_area().

To ensure that aligned MSI interrupt numbers are used by endpoint devices,
we cannot use Linux virtual irq numbers (as they are random and not
properly aligned). Instead we need to use the aligned hwirq numbers.

This change fixes receiving MSI interrupts on Armada 3720 boards and
allows using NVMe disks which use Multi-MSI feature with 3 interrupts.

Without this NVMe disks freeze booting as linux nvme-core.c is waiting
60s for an interrupt.

Link: https://lore.kernel.org/r/20220110015018.26359-4-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 82e2c618d532..15348be1a8aa 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1186,7 +1186,7 @@ static void advk_msi_irq_compose_msi_msg(struct irq_data *data,
 
 	msg->address_lo = lower_32_bits(msi_msg);
 	msg->address_hi = upper_32_bits(msi_msg);
-	msg->data = data->irq;
+	msg->data = data->hwirq;
 }
 
 static int advk_msi_set_affinity(struct irq_data *irq_data,
@@ -1203,15 +1203,11 @@ static int advk_msi_irq_domain_alloc(struct irq_domain *domain,
 	int hwirq, i;
 
 	mutex_lock(&pcie->msi_used_lock);
-	hwirq = bitmap_find_next_zero_area(pcie->msi_used, MSI_IRQ_NUM,
-					   0, nr_irqs, 0);
-	if (hwirq >= MSI_IRQ_NUM) {
-		mutex_unlock(&pcie->msi_used_lock);
-		return -ENOSPC;
-	}
-
-	bitmap_set(pcie->msi_used, hwirq, nr_irqs);
+	hwirq = bitmap_find_free_region(pcie->msi_used, MSI_IRQ_NUM,
+					order_base_2(nr_irqs));
 	mutex_unlock(&pcie->msi_used_lock);
+	if (hwirq < 0)
+		return -ENOSPC;
 
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_set_info(domain, virq + i, hwirq + i,
@@ -1229,7 +1225,7 @@ static void advk_msi_irq_domain_free(struct irq_domain *domain,
 	struct advk_pcie *pcie = domain->host_data;
 
 	mutex_lock(&pcie->msi_used_lock);
-	bitmap_clear(pcie->msi_used, d->hwirq, nr_irqs);
+	bitmap_release_region(pcie->msi_used, d->hwirq, order_base_2(nr_irqs));
 	mutex_unlock(&pcie->msi_used_lock);
 }
 
-- 
2.35.1



