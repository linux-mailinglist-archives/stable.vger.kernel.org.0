Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFAF51A9A3
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356342AbiEDRSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357299AbiEDRO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19D9546B1
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F68A618E5
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCCCC385AF;
        Wed,  4 May 2022 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683506;
        bh=g862QrS3wo0M/ymobfj93eBn4vKHS9GLem5bUZbWcwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWanudqyZOZQSzoPuigccGOcS7D2XFu9jao7NIVbjb8VHwvwgcIHeWArUPusr4dUh
         Qv3zpIZlDFHKPwlY6scdLHXt92eZFwNto8Vr97ukSvdFNSv6lWjbKyJ/O+HboYCSJ8
         9VC+EFssy9eVarHk53A3pQzczS7reMjh166Qpe8f2P34ZWv2w2O8iXBh+5PAuDUgqP
         2ttUX7q/9kQYhwUeGrMkk1RcIZK/+uYVks6PJQh1VQhb/B3FfyJfp+pz5iz67Sd4cM
         E55OGz6Fb57I3VK+SGOAHhM2ysWLzTLs37hg6ERF/STPSCSX9eaYKeZpZqpSUCzRWW
         c6OheBluWd1CQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 17/30] PCI: aardvark: Use dev_fwnode() instead of of_node_to_fwnode(dev->of_node)
Date:   Wed,  4 May 2022 18:57:42 +0200
Message-Id: <20220504165755.30002-18-kabel@kernel.org>
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
index 51cb49a9d3f5..e704aada3365 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1296,7 +1296,6 @@ static struct msi_domain_info advk_msi_domain_info = {
 static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	struct device_node *node = dev->of_node;
 	phys_addr_t msi_msg_phys;
 
 	mutex_init(&pcie->msi_used_lock);
@@ -1315,7 +1314,7 @@ static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 		return -ENOMEM;
 
 	pcie->msi_domain =
-		pci_msi_create_irq_domain(of_node_to_fwnode(node),
+		pci_msi_create_irq_domain(dev_fwnode(dev),
 					  &advk_msi_domain_info,
 					  pcie->msi_inner_domain);
 	if (!pcie->msi_domain) {
-- 
2.35.1

