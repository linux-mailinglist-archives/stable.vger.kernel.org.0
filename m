Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F471521B2A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244239AbiEJOIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344252AbiEJOHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA37820EE1F;
        Tue, 10 May 2022 06:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B4E61937;
        Tue, 10 May 2022 13:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CCFC385C2;
        Tue, 10 May 2022 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190120;
        bh=L27cyLeD7oy10xsCgYYUOc2bcZrZ4ICjLcB3pOVviB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKqxTNy0XXEO9Vh9qg3chqCNsQKjvtyqhYs/sTJLaLBKAvxYDSWYZefwND+rbDq3/
         +dAP7ur8SpXkdguf6K55OlkElA6qKqSHxdcJeZ5igYhQmo6KdyvBKC7t/96PL9jaTa
         pvKpWz0FTTNLPs1wqPFKEKLgnyl8KMFyHym1LE/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.17 127/140] PCI: aardvark: Use dev_fwnode() instead of of_node_to_fwnode(dev->of_node)
Date:   Tue, 10 May 2022 15:08:37 +0200
Message-Id: <20220510130745.226483305@linuxfoundation.org>
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

From: "Marek Behún" <kabel@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1294,7 +1294,6 @@ static struct msi_domain_info advk_msi_d
 static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	struct device_node *node = dev->of_node;
 	phys_addr_t msi_msg_phys;
 
 	mutex_init(&pcie->msi_used_lock);
@@ -1313,7 +1312,7 @@ static int advk_pcie_init_msi_irq_domain
 		return -ENOMEM;
 
 	pcie->msi_domain =
-		pci_msi_create_irq_domain(of_node_to_fwnode(node),
+		pci_msi_create_irq_domain(dev_fwnode(dev),
 					  &advk_msi_domain_info,
 					  pcie->msi_inner_domain);
 	if (!pcie->msi_domain) {


