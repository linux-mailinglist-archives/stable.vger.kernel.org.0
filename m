Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6960657AE1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiL1PPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiL1PPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE43228
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07CF46155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B63C433D2;
        Wed, 28 Dec 2022 15:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240550;
        bh=u3NVQJKNF+rnowNpShBaEAVRDQot1+kMKFAa4ZHhWoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC1Zq/pxCOi5oYoUtdtSBtMcFvAMQI83MzxXT1KDBtVgfJ27UHR2fcwaVANQl3XK+
         QwzVxKV5Z0V20GAvQf2Qhvi54AzHozaD6OstXwa8mVuNm59S/gZ6Ja2gO6viGLVYlk
         Mj2zU+D3dXT06WmMR7QqAUaJfKTr6PF8lSEFxjtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vidya Sagar <vidyas@nvidia.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Jingoo Han <jingoohan1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/731] PCI: dwc: Fix n_fts[] array overrun
Date:   Wed, 28 Dec 2022 15:37:53 +0100
Message-Id: <20221228144307.170130048@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index e408ebf5bd73..00972a7bc976 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -730,7 +730,7 @@ void dw_pcie_setup(struct dw_pcie *pci)
 	if (pci->n_fts[1]) {
 		val = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
 		val &= ~PORT_LOGIC_N_FTS_MASK;
-		val |= pci->n_fts[pci->link_gen - 1];
+		val |= pci->n_fts[1];
 		dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, val);
 	}
 
-- 
2.35.1



