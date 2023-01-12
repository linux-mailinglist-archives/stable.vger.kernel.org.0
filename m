Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EDD667590
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbjALOXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbjALOWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:22:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEAD59513
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 230BAB81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FA5C433EF;
        Thu, 12 Jan 2023 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532809;
        bh=ZGSA8kW/mrCz/E4gyVLR07tgIRBIc5w1yoF4I7guByY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIKueeyDEcXR8BpX+oNyPk0Z0RLvtZge6egXOdiIjLg9FoNTy3mbNmKKunK9MKung
         IX4tsoYIK3AtrcLpgU1CJNtl5YIqirIhJ7IVzmOf6eizglor8mVXMSiBuM61uiSqOm
         W75fo2g88yCYWhF6yvAR+4C3CjDXxRfXk/bDvvzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vidya Sagar <vidyas@nvidia.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Jingoo Han <jingoohan1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/783] PCI: dwc: Fix n_fts[] array overrun
Date:   Thu, 12 Jan 2023 14:50:00 +0100
Message-Id: <20230112135537.564136195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 2b74ff88c5c5..28945351da14 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -589,7 +589,7 @@ void dw_pcie_setup(struct dw_pcie *pci)
 	if (pci->n_fts[1]) {
 		val = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
 		val &= ~PORT_LOGIC_N_FTS_MASK;
-		val |= pci->n_fts[pci->link_gen - 1];
+		val |= pci->n_fts[1];
 		dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, val);
 	}
 
-- 
2.35.1



