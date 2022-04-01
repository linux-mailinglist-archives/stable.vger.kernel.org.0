Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EF14EF270
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352816AbiDAPIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350274AbiDAO7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C528653A65;
        Fri,  1 Apr 2022 07:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C109B824AF;
        Fri,  1 Apr 2022 14:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26FAC34111;
        Fri,  1 Apr 2022 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824405;
        bh=5n6gkPn4odniDxxdbPfsYkqV0k8lz58Vff0Ug6fRgoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8TCqa000dcZJPKP6mQ0eBoZPR0+MCPgrDnRm+LF1RTiUCCfyV4kASs20gBG0VFkS
         307Cwa2IPjX+EA/PZROwkRe5UDABBGVD7FAJPoJlJogeO9KZZDxDUNWBHd2AnGNg8q
         sS2jvbUyzh4A+QY2fSV1K2YIpd1wWoRqOR3psQMv63+7L2OmXLdWlCjDqRCLZvNTqM
         vi6HMLT88SlZtwYH2Mg5dJurVl/bH9L71HnPxOBY3YGCXv48Y4SnxaWo/lDlQeLOCt
         x/M4A/PxGDqPC/2ml/lkvs6kFbyRBAhlpkehbDvnYLJg6lmL51BEWMQKGKLzbPdm1n
         O7goG6oj1jM1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, thomas.petazzoni@bootlin.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 10/29] PCI: aardvark: Fix support for MSI interrupts
Date:   Fri,  1 Apr 2022 10:45:53 -0400
Message-Id: <20220401144612.1955177-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index e6d60fa2217d..db778a25bae3 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -833,7 +833,7 @@ static void advk_msi_irq_compose_msi_msg(struct irq_data *data,
 
 	msg->address_lo = lower_32_bits(msi_msg);
 	msg->address_hi = upper_32_bits(msi_msg);
-	msg->data = data->irq;
+	msg->data = data->hwirq;
 }
 
 static int advk_msi_set_affinity(struct irq_data *irq_data,
@@ -850,15 +850,11 @@ static int advk_msi_irq_domain_alloc(struct irq_domain *domain,
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
@@ -876,7 +872,7 @@ static void advk_msi_irq_domain_free(struct irq_domain *domain,
 	struct advk_pcie *pcie = domain->host_data;
 
 	mutex_lock(&pcie->msi_used_lock);
-	bitmap_clear(pcie->msi_used, d->hwirq, nr_irqs);
+	bitmap_release_region(pcie->msi_used, d->hwirq, order_base_2(nr_irqs));
 	mutex_unlock(&pcie->msi_used_lock);
 }
 
-- 
2.34.1

