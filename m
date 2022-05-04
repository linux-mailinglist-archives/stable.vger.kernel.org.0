Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA83951A9FD
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357221AbiEDRUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358302AbiEDRPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0154656774
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D651B827A5
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43D4C385A5;
        Wed,  4 May 2022 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683546;
        bh=UWDm9xI2RTamqcKQzMcsaj1UBvOgw5ActiMZo6Shzg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExY69+gN14ypL5nadD3wToQ2ytyFt7wJEe52t60cF9BfmKjc0zEOyFlLOisJ2mz/g
         sGARtmf8sFeHkYYFWVjlQIUPEr+xyFH+TaGq3sUlfWYP5LqERBzYu0FGh493+nljEj
         VGtYLxz9Oy86IT5gS9ZgZezSYdJoHaVNo/HjbJ/BT+WTQPvY6ZzrX9rEg3rh6fSZyS
         FtgY/V+M8K/hAH78V2ffGKeKxtMtLbV7b+DRcK8IEk3AktdGOR9wg5UD3XzKFeGkAs
         825/tzRnntquuO0ZiZ5J1b/dRVfD92B7OxMlK+MIcYho7x3JdQz2JH/Tv8gPb5ZSTW
         P7y+ZpOA/ZcJg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 06/19] PCI: aardvark: Use dev_fwnode() instead of of_node_to_fwnode(dev->of_node)
Date:   Wed,  4 May 2022 18:58:39 +0200
Message-Id: <20220504165852.30089-7-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165852.30089-1-kabel@kernel.org>
References: <20220504165852.30089-1-kabel@kernel.org>
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

commit 222af78532fa299cd9b1008e49c347b7f5a45c17 upstream.

Use simple
  dev_fwnode(dev)
instead of
  struct device_node *node = dev->of_node;
  of_node_to_fwnode(node)
especially since the node variable is not used elsewhere in the function.

Link: https://lore.kernel.org/r/20220110015018.26359-9-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 4bd51ae0e745..2c2259d1af5e 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1294,7 +1294,6 @@ static struct msi_domain_info advk_msi_domain_info = {
 static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	struct device_node *node = dev->of_node;
 	phys_addr_t msi_msg_phys;
 
 	mutex_init(&pcie->msi_used_lock);
@@ -1313,7 +1312,7 @@ static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 		return -ENOMEM;
 
 	pcie->msi_domain =
-		pci_msi_create_irq_domain(of_node_to_fwnode(node),
+		pci_msi_create_irq_domain(dev_fwnode(dev),
 					  &advk_msi_domain_info,
 					  pcie->msi_inner_domain);
 	if (!pcie->msi_domain) {
-- 
2.35.1

