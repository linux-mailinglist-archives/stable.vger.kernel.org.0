Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1549459DC2A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiHWL2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358184AbiHWL1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:27:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A541C3F58;
        Tue, 23 Aug 2022 02:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6006C61220;
        Tue, 23 Aug 2022 09:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5CFC433D6;
        Tue, 23 Aug 2022 09:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246709;
        bh=ayePQ4jSZQclIGH4CsY3QCuzA/aCfLhd204WTXX4Rq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjt8ur2vRoajTBcTmVINt+zdgkWdR8eMWlfBmgkYhiMOUdgp9xL8zjvO/a6vbIzRb
         uRQzT8HhwdpIdxK8S4K9MT5+pkywGu1Rioy/dKEUn1s2lC6jQrwt+wyAyLUs1ONCQP
         vekVKTfnokIJmOuEj49h7IbMcaPLXag8nn7djZ0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Sagar <vidyas@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/389] PCI: tegra194: Fix link up retry sequence
Date:   Tue, 23 Aug 2022 10:24:31 +0200
Message-Id: <20220823080123.689370273@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit e05fd6ae77c3e2cc0dba283005d24b6d56d2b1fa ]

Add the missing DLF capability offset while clearing DL_FEATURE_EXCHANGE_EN
bit during link up retry.

Link: https://lore.kernel.org/r/20220721142052.25971-15-vidyas@nvidia.com
Fixes: 56e15a238d92 ("PCI: tegra: Add Tegra194 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index c7ac61a6080b..120d64c1a27f 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -854,7 +854,7 @@ static int tegra_pcie_dw_host_init(struct pcie_port *pp)
 		offset = dw_pcie_find_ext_capability(pci, PCI_EXT_CAP_ID_DLF);
 		val = dw_pcie_readl_dbi(pci, offset + PCI_DLF_CAP);
 		val &= ~PCI_DLF_EXCHANGE_ENABLE;
-		dw_pcie_writel_dbi(pci, offset, val);
+		dw_pcie_writel_dbi(pci, offset + PCI_DLF_CAP, val);
 
 		tegra_pcie_prepare_host(pp);
 
-- 
2.35.1



