Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7913065B0A0
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjABL1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbjABL0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6F25F55
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4905660F54
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606E2C433EF;
        Mon,  2 Jan 2023 11:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658695;
        bh=JhN2Iea+VXgvHgkZDNOwIxXibeDSZgRFckfMme4NHkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7GL9t83zGG8N59ypWSpyEiDuzpLn/9TawtrpUDb12kTxE8lwVjbRdnEUAd/8SrqZ
         +6gd+OqZYO+KYYVKevO4II1nOPt2mnGl/pc9HBC5AtCCAbdNZZYR87dAxyiJjITDnw
         HC3GUVLFq19R45t4oIdBPvodpn3C8dKQhCNgfNno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/71] iommu/mediatek: Fix crash on isr after kexec()
Date:   Mon,  2 Jan 2023 12:21:59 +0100
Message-Id: <20230102110552.885832838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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
index dad2f238ffbf..56d007582b6f 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -454,7 +454,7 @@ static irqreturn_t mtk_iommu_isr(int irq, void *dev_id)
 		fault_larb = data->plat_data->larbid_remap[fault_larb][sub_comm];
 	}
 
-	if (report_iommu_fault(&dom->domain, bank->parent_dev, fault_iova,
+	if (!dom || report_iommu_fault(&dom->domain, bank->parent_dev, fault_iova,
 			       write ? IOMMU_FAULT_WRITE : IOMMU_FAULT_READ)) {
 		dev_err_ratelimited(
 			bank->parent_dev,
-- 
2.35.1



