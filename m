Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B893D541AC9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380880AbiFGVif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380786AbiFGViC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16B3EF04D;
        Tue,  7 Jun 2022 12:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DC64B82182;
        Tue,  7 Jun 2022 19:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA569C385A2;
        Tue,  7 Jun 2022 19:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628709;
        bh=TQMibTrv0Kxl2GjkbcYfGHrz/WdFVFcZsNJSNBNs5vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiV+ReCHgye+dmCV7wVT3kVgCny5+ALkRpbcMh/Ujreoh/u49jFI3c/VQ1M9OsgdN
         YVH8bsqYwLwttxr8ah/Ft+kUGaqqvtxCIS9x3WmFqScN8xI1arRjGWsueeQqwIMViE
         M7i1D7BxLRH52+Ij259C8H3F+HP3fjVq+62gpSqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 428/879] media: exynos4-is: Fix PM disable depth imbalance in fimc_is_probe
Date:   Tue,  7 Jun 2022 18:59:06 +0200
Message-Id: <20220607165015.289392513@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 5c0db68ce0faeb000c3540d095eb272d671a6e03 ]

If probe fails then we need to call pm_runtime_disable() to balance
out the previous pm_runtime_enable() call.

Fixes: 9a761e436843 ("[media] exynos4-is: Add Exynos4x12 FIMC-IS driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/fimc-is.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-is.c b/drivers/media/platform/samsung/exynos4-is/fimc-is.c
index e55e411038f4..81b290dace3a 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-is.c
@@ -830,7 +830,7 @@ static int fimc_is_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
-		goto err_irq;
+		goto err_pm_disable;
 
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 
@@ -864,6 +864,8 @@ static int fimc_is_probe(struct platform_device *pdev)
 	pm_runtime_put_noidle(dev);
 	if (!pm_runtime_enabled(dev))
 		fimc_is_runtime_suspend(dev);
+err_pm_disable:
+	pm_runtime_disable(dev);
 err_irq:
 	free_irq(is->irq, is);
 err_clk:
-- 
2.35.1



