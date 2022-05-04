Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664851AA2F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355912AbiEDRWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357443AbiEDRPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A147554BF4
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36BC5CE28B9
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC16C385A5;
        Wed,  4 May 2022 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683508;
        bh=Qio1QUKxsqujMYZd+uA/JnVaA1Z1Q9a70Xei0uwv2+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtMop+iiVxtabQkl4ZPSKDQtjDqc3gb/Qanr3TvYuiaKLV8QQ5+0dnsIs7pQiRoQU
         LqeEI8MZIW7+NB4t0BwnWwqlXTcr57JU3+7nRfjlwEIs05kX64KhW800Paz33HO7FO
         8oGyYwgdfoCbezElFL66n95LmSexmD/EO63XrxvL/tIkGG1j9TeUSdk/HIBvWQaIOC
         ODwFoKMC0pBoS/ObB9vu3XHYtk+n1ocjnJFqDm+sz5K0JZSn7yMQPh+0WS29qQxuoM
         2yf54SY3WZvekWyAFqKC17Ien7HpjrPqB+YV7C8IKDdtTXOZaZUYdwyUQIP9u/9NN4
         RpUVW4nOkD2VA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 18/30] PCI: aardvark: Refactor unmasking summary MSI interrupt
Date:   Wed,  4 May 2022 18:57:43 +0200
Message-Id: <20220504165755.30002-19-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
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

commit 4689c0916320f112a8a33f2689d3addc3262f02c upstream.

Refactor the masking of ISR0/1 Sources and unmasking of summary MSI interrupt
so that it corresponds to the comments:
- first mask all ISR0/1
- then unmask all MSIs
- then unmask summary MSI interrupt

Link: https://lore.kernel.org/r/20220110015018.26359-10-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index e704aada3365..b96ef0fdf9e6 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -571,15 +571,17 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	advk_writel(pcie, PCIE_IRQ_ALL_MASK, HOST_CTRL_INT_STATUS_REG);
 
 	/* Disable All ISR0/1 Sources */
-	reg = PCIE_ISR0_ALL_MASK;
-	reg &= ~PCIE_ISR0_MSI_INT_PENDING;
-	advk_writel(pcie, reg, PCIE_ISR0_MASK_REG);
-
+	advk_writel(pcie, PCIE_ISR0_ALL_MASK, PCIE_ISR0_MASK_REG);
 	advk_writel(pcie, PCIE_ISR1_ALL_MASK, PCIE_ISR1_MASK_REG);
 
 	/* Unmask all MSIs */
 	advk_writel(pcie, ~(u32)PCIE_MSI_ALL_MASK, PCIE_MSI_MASK_REG);
 
+	/* Unmask summary MSI interrupt */
+	reg = advk_readl(pcie, PCIE_ISR0_MASK_REG);
+	reg &= ~PCIE_ISR0_MSI_INT_PENDING;
+	advk_writel(pcie, reg, PCIE_ISR0_MASK_REG);
+
 	/* Enable summary interrupt for GIC SPI source */
 	reg = PCIE_IRQ_ALL_MASK & (~PCIE_IRQ_ENABLE_INTS_MASK);
 	advk_writel(pcie, reg, HOST_CTRL_INT_MASK_REG);
-- 
2.35.1

