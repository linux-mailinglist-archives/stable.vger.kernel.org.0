Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ECA594C9F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351704AbiHPA3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351734AbiHPA2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:28:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23D91815F2;
        Mon, 15 Aug 2022 13:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0CC2611FC;
        Mon, 15 Aug 2022 20:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F01C433C1;
        Mon, 15 Aug 2022 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595704;
        bh=fOdGFFtHb2u3F0BRb8234h0PP4eJ3kgUdjnmltyekLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+jbOwO52KBCJx2stPuMg+QznI0RCqu9GTfwMXdO+RDjvr+ulQ3HY1oicZRpftFB6
         QR5aswPpV8uNa9yl1D8932Csu7AdIP7jrSUf9RdP3+gryMLgMFC5RTL48SfSoBrMgW
         INi7bDBuYMWOAJPCiH3uz5bLHKAmhqRX8OmKVMJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Sagar <vidyas@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0848/1157] PCI: tegra194: Fix link up retry sequence
Date:   Mon, 15 Aug 2022 20:03:24 +0200
Message-Id: <20220815180513.419158047@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 0bab700086f9..67e8372a3243 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -976,7 +976,7 @@ static int tegra194_pcie_start_link(struct dw_pcie *pci)
 		offset = dw_pcie_find_ext_capability(pci, PCI_EXT_CAP_ID_DLF);
 		val = dw_pcie_readl_dbi(pci, offset + PCI_DLF_CAP);
 		val &= ~PCI_DLF_EXCHANGE_ENABLE;
-		dw_pcie_writel_dbi(pci, offset, val);
+		dw_pcie_writel_dbi(pci, offset + PCI_DLF_CAP, val);
 
 		tegra194_pcie_host_init(pp);
 		dw_pcie_setup_rc(pp);
-- 
2.35.1



