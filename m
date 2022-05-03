Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB79518F86
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 22:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiECU6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 16:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiECU6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 16:58:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05B833E02
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56D5AB820F2
        for <stable@vger.kernel.org>; Tue,  3 May 2022 20:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96780C385B3;
        Tue,  3 May 2022 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651611281;
        bh=qY0Fb2kbBqSy4ugraq+276XlsaIi4Bazu9buulhaZ3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDiXmg/idvK1b3Cubo6eMkkVPDDPBwLsAiucgV0y7Xu16/TvxaG2zGRxUU2e3fYpX
         0BmQS4OlDmQB7C7T7uxuiGGKoLZW5wxj868kUf7lXMFDVOjIyMv8MNTcVOvoIgVCai
         hjKhI1nEQO9Au3e3RZdC81ZozzpPKp27PWNcOTzZb/OFyjDzNKxhRFt0Roqv+eN0h+
         ZxUS51jEGhaZ1PCD95rlX1j1otz9oOmttLr6sFk35mG/FsRmOrGrMBe+5iiYKgykRk
         DIe3fLYUlSLudJZpNWrMTBagcJXcMLF5TmiHNrBdiVDaSg35AEgniXwCLQE0Fj5vYM
         rcpx60GzJG7og==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        Josef Schlehofer <josef.schlehofer@nic.cz>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 2/2] PCI: aardvark: Fix reading MSI interrupt number
Date:   Tue,  3 May 2022 22:54:34 +0200
Message-Id: <20220503205434.25275-2-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503205434.25275-1-kabel@kernel.org>
References: <20220503205434.25275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 805dfc18dd3d4dd97a987d4406593b5a225b1253 ]

In advk_pcie_handle_msi() the authors expect that when bit i in the W1C
register PCIE_MSI_STATUS_REG is cleared, the PCIE_MSI_PAYLOAD_REG is
updated to contain the MSI number corresponding to index i.

Experiments show that this is not so, and instead PCIE_MSI_PAYLOAD_REG
always contains the number of the last received MSI, overall.

Do not read PCIE_MSI_PAYLOAD_REG register for determining MSI interrupt
number. Since Aardvark already forbids more than 32 interrupts and uses
own allocated hwirq numbers, the msi_idx already corresponds to the
received MSI number.

Link: https://lore.kernel.org/r/20220110015018.26359-3-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
Hello Sasha, Greg,

this patch is needed ASAP, cause currently the backported 4.14 commit
d7f87c7849d4 ("PCI: aardvark: Fix support for MSI interrupts") makes the
PCIe controller unusable.

Sorry for not spotting this earlier.

Marek
---
 drivers/pci/host/pci-aardvark.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index b7ff0774b165..1c8c24b2188c 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -1036,7 +1036,7 @@ static void advk_pcie_remove_irq_domain(struct advk_pcie *pcie)
 static void advk_pcie_handle_msi(struct advk_pcie *pcie)
 {
 	u32 msi_val, msi_mask, msi_status, msi_idx;
-	u16 msi_data;
+	int virq;
 
 	msi_mask = advk_readl(pcie, PCIE_MSI_MASK_REG);
 	msi_val = advk_readl(pcie, PCIE_MSI_STATUS_REG);
@@ -1046,13 +1046,9 @@ static void advk_pcie_handle_msi(struct advk_pcie *pcie)
 		if (!(BIT(msi_idx) & msi_status))
 			continue;
 
-		/*
-		 * msi_idx contains bits [4:0] of the msi_data and msi_data
-		 * contains 16bit MSI interrupt number
-		 */
 		advk_writel(pcie, BIT(msi_idx), PCIE_MSI_STATUS_REG);
-		msi_data = advk_readl(pcie, PCIE_MSI_PAYLOAD_REG) & PCIE_MSI_DATA_MASK;
-		generic_handle_irq(msi_data);
+		virq = irq_find_mapping(pcie->msi_inner_domain, msi_idx);
+		generic_handle_irq(virq);
 	}
 
 	advk_writel(pcie, PCIE_ISR0_MSI_INT_PENDING,
-- 
2.35.1

