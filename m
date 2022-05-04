Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBBE51A1CA
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 16:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbiEDOLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 10:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbiEDOLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 10:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B2141338
        for <stable@vger.kernel.org>; Wed,  4 May 2022 07:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6376161A39
        for <stable@vger.kernel.org>; Wed,  4 May 2022 14:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744EFC385B0;
        Wed,  4 May 2022 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651673245;
        bh=K0OoW0NBnx6CUQ6pHVbOcSVgzO/+VHZlNN6Five4h2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnzvYQJ4C0D+aY3y5+MhjSvlpIv07hrgGMcoWzrT8sSi9mC3sqnDaD48eQsGCpQHx
         d4ic5VxI/JXy3ST4YJg2bX9P8OhZFSMBDiTWspMNiDUJ1dOfHVXUS4JaUOJ4GYG6os
         /yhK8PVZF08CVYmJVXVsCAhtZyjC5Fjuk3zVjFF4qnE3LRfYAtSGLO32gWXtXAnuyk
         RreHDNbRuubYbzd8CZ2acj0dyz7ihmyezYKPlTcCBR1z8UUXp2CYATGhQRvFhzLuso
         PYaL3anbBXc6gQ/gfgrOwBC4AIgpf8EFUHqqnc8JBsU4EmBwEUa1xfHuWTdIY8WlNF
         7ssCanLHIO0Ig==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.19 2/2] PCI: aardvark: Fix reading MSI interrupt number
Date:   Wed,  4 May 2022 16:07:19 +0200
Message-Id: <20220504140719.11066-2-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504140719.11066-1-kabel@kernel.org>
References: <20220504140719.11066-1-kabel@kernel.org>
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
As explained in https://lore.kernel.org/stable/20220503205434.25275-2-kabel@kernel.org/
for 4.14, this needs to be applied ASAP to stable, since another commit was put into
stable that breaks this driver.

Thx :)
---
 drivers/pci/controller/pci-aardvark.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ae5abd233df4..a5bc529e9e82 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1035,7 +1035,7 @@ static void advk_pcie_remove_irq_domain(struct advk_pcie *pcie)
 static void advk_pcie_handle_msi(struct advk_pcie *pcie)
 {
 	u32 msi_val, msi_mask, msi_status, msi_idx;
-	u16 msi_data;
+	int virq;
 
 	msi_mask = advk_readl(pcie, PCIE_MSI_MASK_REG);
 	msi_val = advk_readl(pcie, PCIE_MSI_STATUS_REG);
@@ -1045,13 +1045,9 @@ static void advk_pcie_handle_msi(struct advk_pcie *pcie)
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

