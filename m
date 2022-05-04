Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A4951AA39
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353839AbiEDRWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357249AbiEDRO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116BF5469C
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE6C5616AC
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1679AC385A4;
        Wed,  4 May 2022 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683505;
        bh=9aJYKKWbTst3EcmdJdoVXN3+itjkBAzu3VWO8iOPpbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbGIrbGMdf0ipfoTW1OkgMmBh5dHmMKfwQX+XcSJbjIjfgu2oSuugWWlwLCeOBjrr
         VFrFF8xOPcdd/Lo4o3xRYb0Ajed1INyPsIe612I87GI46vxe7OH9YWkAyT1lkcuzvx
         37jqbJfz3bS2zwPfK53d0yqb6hsEmwe9LVp14L6eLQwZMATUjkTPwuihu3j2JTBFqr
         j0ySAAi0jBpP5pUrrRcHpDf+lS1OGnAbK+GB/OmOu5aff8+13cDqzZM1aFXcHuqKKu
         Uv1zL3UJpmZCShnQYnsH93SnSBEIErQTWH9byeoutAAi2cIURI6r64o1ZMRU0/oLb1
         cVZ42AfiWoPnw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 16/30] PCI: aardvark: Make msi_domain_info structure a static driver structure
Date:   Wed,  4 May 2022 18:57:41 +0200
Message-Id: <20220504165755.30002-17-kabel@kernel.org>
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

commit 26bcd54e4a5cd51ec12d06fdc30e22863ed4c422 upstream.

Make Aardvark's msi_domain_info structure into a private driver structure.
Domain info is same for every potential instatination of a controller.

Link: https://lore.kernel.org/r/20220110015018.26359-8-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 7011a4a36165..51cb49a9d3f5 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -274,7 +274,6 @@ struct advk_pcie {
 	raw_spinlock_t irq_lock;
 	struct irq_domain *msi_domain;
 	struct irq_domain *msi_inner_domain;
-	struct msi_domain_info msi_domain_info;
 	DECLARE_BITMAP(msi_used, MSI_IRQ_NUM);
 	struct mutex msi_used_lock;
 	u16 msi_msg;
@@ -1288,20 +1287,20 @@ static struct irq_chip advk_msi_irq_chip = {
 	.name = "advk-MSI",
 };
 
+static struct msi_domain_info advk_msi_domain_info = {
+	.flags	= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+		  MSI_FLAG_MULTI_PCI_MSI,
+	.chip	= &advk_msi_irq_chip,
+};
+
 static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
 	struct device_node *node = dev->of_node;
-	struct msi_domain_info *msi_di;
 	phys_addr_t msi_msg_phys;
 
 	mutex_init(&pcie->msi_used_lock);
 
-	msi_di = &pcie->msi_domain_info;
-	msi_di->flags = MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		MSI_FLAG_MULTI_PCI_MSI;
-	msi_di->chip = &advk_msi_irq_chip;
-
 	msi_msg_phys = virt_to_phys(&pcie->msi_msg);
 
 	advk_writel(pcie, lower_32_bits(msi_msg_phys),
@@ -1317,7 +1316,8 @@ static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 
 	pcie->msi_domain =
 		pci_msi_create_irq_domain(of_node_to_fwnode(node),
-					  msi_di, pcie->msi_inner_domain);
+					  &advk_msi_domain_info,
+					  pcie->msi_inner_domain);
 	if (!pcie->msi_domain) {
 		irq_domain_remove(pcie->msi_inner_domain);
 		return -ENOMEM;
-- 
2.35.1

