Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E2656F08
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiL0UiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiL0UhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:37:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E051DF9B;
        Tue, 27 Dec 2022 12:34:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CC2261237;
        Tue, 27 Dec 2022 20:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BED6C433D2;
        Tue, 27 Dec 2022 20:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173252;
        bh=lXpXGDVABBxF0Wo9jihuxkhviG7fucblA67dNbJIpLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJwuXYtbT6jPX/2d5hzcZc+nxRdGS4UmqO+Pv5j0CDvyQFc6BWaOH3y8B3EFTFhEx
         vZWaJIm1JPG5h+g7portQxLmhPzGxBrm0dXKiZSGsiPKy4DmeDZJ8s4lkv6JwzC8O8
         Eh+jwWRgMf8bwGVMPV5Ay6Got9bzNkkX9UzWw7hKJ9RDUgQ6Bw5+xNf4P2f64+G8uv
         uqsg52883STiQxBk1pkuLhF2s92FSjQkNU9x4LyGvtFRjG4c6jh4vfKBMQNFUIhmDk
         n45QpQbMXQD6Hkb9E+9FAw/YPT2ReWh72of7JX2GztXG+S25z6CmWLFALGKJLH/5fA
         AbJ8lAq60zDNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, yong.wu@mediatek.com,
        joro@8bytes.org, will@kernel.org, matthias.bgg@gmail.com,
        iommu@lists.linux.dev, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 20/27] iommu/mediatek: Fix crash on isr after kexec()
Date:   Tue, 27 Dec 2022 15:33:35 -0500
Message-Id: <20221227203342.1213918-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203342.1213918-1-sashal@kernel.org>
References: <20221227203342.1213918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 00ef8885a945c37551547d8ac8361cacd20c4e42 ]

If the system is rebooted via isr(), the IRQ handler might
be triggered before the domain is initialized. Resulting on
an invalid memory access error.

Fix:
[    0.500930] Unable to handle kernel read from unreadable memory at virtual address 0000000000000070
[    0.501166] Call trace:
[    0.501174]  report_iommu_fault+0x28/0xfc
[    0.501180]  mtk_iommu_isr+0x10c/0x1c0

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20221125-mtk-iommu-v2-0-e168dff7d43e@chromium.org
[ joro: Fixed spelling in commit message ]
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 7e363b1f24df..b5ccdc134e84 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -452,7 +452,7 @@ static irqreturn_t mtk_iommu_isr(int irq, void *dev_id)
 		fault_larb = data->plat_data->larbid_remap[fault_larb][sub_comm];
 	}
 
-	if (report_iommu_fault(&dom->domain, bank->parent_dev, fault_iova,
+	if (!dom || report_iommu_fault(&dom->domain, bank->parent_dev, fault_iova,
 			       write ? IOMMU_FAULT_WRITE : IOMMU_FAULT_READ)) {
 		dev_err_ratelimited(
 			bank->parent_dev,
-- 
2.35.1

