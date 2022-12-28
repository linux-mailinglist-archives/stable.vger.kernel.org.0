Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60165802C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiL1QOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiL1QOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:14:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C947A1A230
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6847C6158B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1ABC433D2;
        Wed, 28 Dec 2022 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243935;
        bh=xFZx9leuCJgbMXiiX9g1ARpxtzdYalSiEPvhxz40504=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xb5PlhvuRScQb2bnll2WPsQnYW+rWYhLzqGDWBn6wm3fmb+IlRkJMp3bD8pj8HTAI
         jPryi5dEO2ejHWaXEkpgf0SysPWPkeBUvAF5naeivIAxcMwR+ngvV8bwQggGN17WEX
         UT16zGlRVFm6sf6GgOM0PKUHs71yY5RZSzi8AA6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vidya Sagar <vidyas@nvidia.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Jingoo Han <jingoohan1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0582/1146] PCI: dwc: Fix n_fts[] array overrun
Date:   Wed, 28 Dec 2022 15:35:21 +0100
Message-Id: <20221228144345.982672329@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 66110361281b2f7da0c8bd51eaf1f152f4236035 ]

commit aeaa0bfe89654 ("PCI: dwc: Move N_FTS setup to common setup")
incorrectly uses pci->link_gen in deriving the index to the
n_fts[] array also introducing the issue of accessing beyond the
boundaries of array for greater than Gen-2 speeds. This change fixes
that issue.

Link: https://lore.kernel.org/r/20220926111923.22487-1-vidyas@nvidia.com
Fixes: aeaa0bfe8965 ("PCI: dwc: Move N_FTS setup to common setup")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Jingoo Han <jingoohan1@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index c6725c519a47..9e4d96e5a3f5 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -641,7 +641,7 @@ void dw_pcie_setup(struct dw_pcie *pci)
 	if (pci->n_fts[1]) {
 		val = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
 		val &= ~PORT_LOGIC_N_FTS_MASK;
-		val |= pci->n_fts[pci->link_gen - 1];
+		val |= pci->n_fts[1];
 		dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, val);
 	}
 
-- 
2.35.1



