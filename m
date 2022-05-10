Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CAD521B17
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbiEJOIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244676AbiEJOIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:08:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D88623E360;
        Tue, 10 May 2022 06:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE5406192C;
        Tue, 10 May 2022 13:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADCBC385A6;
        Tue, 10 May 2022 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190139;
        bh=z8hq8fLZpFA7icnRzDjRC1UziW/f67KhSR5BDDrhu5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZG8Ubm1yrG4PH0f+NNuJ/LthgII5nQr92Tht5M5HlhEIMIJLWHcd7rBdiMti4hvy
         YqBIe+E3PkiCvJktNBG+DE0WW5UDr3S0q0m5//9IX6DqK8XR7+5vhsr7w/iOry4foB
         s5fe6UE7I1r7R+ydCP+z95XiEzNTfamZJhxsKN+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.17 128/140] PCI: aardvark: Refactor unmasking summary MSI interrupt
Date:   Tue, 10 May 2022 15:08:38 +0200
Message-Id: <20220510130745.253980569@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -571,15 +571,17 @@ static void advk_pcie_setup_hw(struct ad
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


