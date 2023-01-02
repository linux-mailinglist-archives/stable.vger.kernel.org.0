Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D55365B122
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbjABLaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236146AbjABLaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:30:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC7C645C
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6E6E60F57
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC26CC433EF;
        Mon,  2 Jan 2023 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658980;
        bh=8UzLM8lk4JXvM4Q8xVHemJEOKdJIpQYeSnpkKm/eAzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wf2tVXtGZiktiO/R/UFZaErh/Q9vUOISuQMdaiQjUEmo3F70ZYgog8YzO1X/pniEB
         H+wPUXf61t1cKhRf2cKR0zChdGvFGASacJ+Zwe8+0ybK9TGz/duNaaaCU8rmtIjsG3
         3EyUWnKEGDN1O1PCez02Q/rWVGBJPYLWAGGWwbNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 40/74] iommu/mediatek: Fix crash on isr after kexec()
Date:   Mon,  2 Jan 2023 12:22:13 +0100
Message-Id: <20230102110553.814296693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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
index ec73720e239b..15fa380b1f84 100644
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



