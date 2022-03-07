Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22C94CF6AF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbiCGJnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240873AbiCGJli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17406B094;
        Mon,  7 Mar 2022 01:38:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EEB8B810CF;
        Mon,  7 Mar 2022 09:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62041C340E9;
        Mon,  7 Mar 2022 09:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645906;
        bh=ZTvWv+f7xdGh/iyHa1ekwbqb+LeXwVZZsUofm01tb8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnH9c6Z+Apu7pGLtAlDVMhfCxPowYmk5NtzKHJsFowkro7hqAnJ+AGrEI5eT8wkyd
         K93PQ/qKEM4ep4yiOnfcJgdmlKz8MXWNS/mjoXuCM0hSMDUzo6Cyb5RhdmpazcaL1z
         DuJOObzEBD/TxvQ7MKpotTx5Yw52nWq/DqmxmsLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/262] PCI: mvebu: Fix support for PCI_EXP_DEVCTL on emulated bridge
Date:   Mon,  7 Mar 2022 10:16:56 +0100
Message-Id: <20220307091704.530226403@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit ecae073e393e65ee7be7ebf3fdd5258ab99f1636 ]

Comment in Armada 370 functional specification is misleading.
PCI_EXP_DEVCTL_*RE bits are supported and configures receiving of error
interrupts.

Link: https://lore.kernel.org/r/20211125124605.25915-14-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 3563301e772ae..6100608e6413e 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -498,9 +498,7 @@ mvebu_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_EXP_DEVCTL:
-		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL) &
-				 ~(PCI_EXP_DEVCTL_URRE | PCI_EXP_DEVCTL_FERE |
-				   PCI_EXP_DEVCTL_NFERE | PCI_EXP_DEVCTL_CERE);
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL);
 		break;
 
 	case PCI_EXP_LNKCAP:
@@ -590,13 +588,6 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 
 	switch (reg) {
 	case PCI_EXP_DEVCTL:
-		/*
-		 * Armada370 data says these bits must always
-		 * be zero when in root complex mode.
-		 */
-		new &= ~(PCI_EXP_DEVCTL_URRE | PCI_EXP_DEVCTL_FERE |
-			 PCI_EXP_DEVCTL_NFERE | PCI_EXP_DEVCTL_CERE);
-
 		mvebu_writel(port, new, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL);
 		break;
 
-- 
2.34.1



