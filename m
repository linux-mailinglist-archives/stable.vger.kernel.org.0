Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9651A991
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351870AbiEDRSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356652AbiEDROC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2089E53B43
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1855616AC
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75D1C385A5;
        Wed,  4 May 2022 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683489;
        bh=Fgny9emLh2YIgJgOyAveJJF+8wPz16H+rL66szMpoI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hs7/1CtBgxszue6yExIqOO0XYtIyVSVc0O9H0Z36RXLQM6DT+U/6qNF4F3OFw6ds7
         nB99ovPX4TeFx1whVa9+G8IIKQWBSQ49OZXLr5Hk+twbjnGNfM7IOr2dv8Ufk9dcjR
         Dkr7LBxgoLltU2wYzKdkAsBTokISJ5jjy35LE47O1nTCZC5/qM5VSSe0Sted3rooOP
         OXwkOrGw6nlzEQkQhrhv9XKY4Xl8+kWYaYkqsuowt0YzWNkKedUa45JAWNoIelfqwg
         j8NKeXoGIN6di5uBjXI9DqD0eHQC7kOdBdcP+reqsUW6zNOHYTdW9BnahIqj92IvED
         4AQCjoL5PS8mA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 06/30] PCI: aardvark: Disable bus mastering when unbinding driver
Date:   Wed,  4 May 2022 18:57:31 +0200
Message-Id: <20220504165755.30002-7-kabel@kernel.org>
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

commit a46f2f6dd4093438d9615dfbf5c0fea2a9835dba upstream.

Ensure that after driver unbind PCIe cards are not able to forward
memory and I/O requests in the upstream direction.

Link: https://lore.kernel.org/r/20211130172913.9727-7-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 7432eeafc8fe..ee6ffba2af22 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1679,6 +1679,7 @@ static int advk_pcie_remove(struct platform_device *pdev)
 {
 	struct advk_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
+	u32 val;
 	int i;
 
 	/* Remove PCI bus with all devices */
@@ -1687,6 +1688,11 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	pci_remove_root_bus(bridge->bus);
 	pci_unlock_rescan_remove();
 
+	/* Disable Root Bridge I/O space, memory space and bus mastering */
+	val = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
+	val &= ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
+	advk_writel(pcie, val, PCIE_CORE_CMD_STATUS_REG);
+
 	/* Remove IRQ domains */
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
-- 
2.35.1

