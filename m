Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A034F28C7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbiDEIV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbiDEIMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F169C6D963;
        Tue,  5 Apr 2022 01:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16552617B4;
        Tue,  5 Apr 2022 08:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5D7C385A1;
        Tue,  5 Apr 2022 08:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145775;
        bh=9HN7L/AvU5dDBp7W4b2h8uXF/+nuCB18CXbxQwBIn8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtgHNSaio4AcJjaQVB4Kf5jT2clXsklJ/pF95mf0oZd1RRQamguEzD7o6+z7Xt7Oy
         EL7ESAbOgBSapsKXAk8SyRyPHxhrlOa3xEV+NQq9A6N0seTY/WukTLCJ8ZGwVaxN6d
         YTX9csDQTdIayG+js4NLbtLGgPu/9+6Jr69TvG7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0525/1126] PCI: aardvark: Fix reading MSI interrupt number
Date:   Tue,  5 Apr 2022 09:21:12 +0200
Message-Id: <20220405070423.040184551@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 805dfc18dd3d4dd97a987d4406593b5a225b1253 ]

In advk_pcie_handle_msi() it is expected that when bit i in the W1C
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 4f5b44827d21..10e936363461 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1388,7 +1388,6 @@ static void advk_pcie_remove_irq_domain(struct advk_pcie *pcie)
 static void advk_pcie_handle_msi(struct advk_pcie *pcie)
 {
 	u32 msi_val, msi_mask, msi_status, msi_idx;
-	u16 msi_data;
 
 	msi_mask = advk_readl(pcie, PCIE_MSI_MASK_REG);
 	msi_val = advk_readl(pcie, PCIE_MSI_STATUS_REG);
@@ -1398,13 +1397,9 @@ static void advk_pcie_handle_msi(struct advk_pcie *pcie)
 		if (!(BIT(msi_idx) & msi_status))
 			continue;
 
-		/*
-		 * msi_idx contains bits [4:0] of the msi_data and msi_data
-		 * contains 16bit MSI interrupt number
-		 */
 		advk_writel(pcie, BIT(msi_idx), PCIE_MSI_STATUS_REG);
-		msi_data = advk_readl(pcie, PCIE_MSI_PAYLOAD_REG) & PCIE_MSI_DATA_MASK;
-		generic_handle_irq(msi_data);
+		if (generic_handle_domain_irq(pcie->msi_inner_domain, msi_idx) == -EINVAL)
+			dev_err_ratelimited(&pcie->pdev->dev, "unexpected MSI 0x%02x\n", msi_idx);
 	}
 
 	advk_writel(pcie, PCIE_ISR0_MSI_INT_PENDING,
-- 
2.34.1



