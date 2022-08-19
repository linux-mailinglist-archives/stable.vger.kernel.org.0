Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5FF59A216
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352849AbiHSQcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352374AbiHSQaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432F611A2FD;
        Fri, 19 Aug 2022 09:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1CB5612DF;
        Fri, 19 Aug 2022 16:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86ADC433C1;
        Fri, 19 Aug 2022 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925075;
        bh=Hsgd4LUboaYBv4o2E/qbjSGnSs0uy6pgG0Udt+MQ+so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfRHQFAQtplP92z2OnkeABwtCGCdDGuphBFBMSQDY6ipESn3cOd/0tRHcv2FGQhKx
         gVykwqe8PcG38vgKS5ZwoQJzXU0weFdfVMEDbKZy3qhKr98ox9XmdjuYeNksILazqo
         BjTac/kSOCbziETqJxlSsWh5KD3fTRbNUsB0UgRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Sagar <vidyas@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/545] PCI: tegra194: Fix link up retry sequence
Date:   Fri, 19 Aug 2022 17:41:56 +0200
Message-Id: <20220819153844.867224680@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index bcbd600116d7..1222f5749bc6 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -963,7 +963,7 @@ static int tegra_pcie_dw_host_init(struct pcie_port *pp)
 		offset = dw_pcie_find_ext_capability(pci, PCI_EXT_CAP_ID_DLF);
 		val = dw_pcie_readl_dbi(pci, offset + PCI_DLF_CAP);
 		val &= ~PCI_DLF_EXCHANGE_ENABLE;
-		dw_pcie_writel_dbi(pci, offset, val);
+		dw_pcie_writel_dbi(pci, offset + PCI_DLF_CAP, val);
 
 		tegra_pcie_prepare_host(pp);
 
-- 
2.35.1



