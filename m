Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224DE59A05F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351168AbiHSQLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351471AbiHSQJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88F910F6AF;
        Fri, 19 Aug 2022 08:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEB56B82818;
        Fri, 19 Aug 2022 15:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0A7C43142;
        Fri, 19 Aug 2022 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924604;
        bh=m0mOdY2diizeEqXmJ998qa9TipPZn8jXMGpxexgGdfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dz4F50rz+wZ48Tv+2L6aa63vJj0V7Jr+m2jFxQJCuYqTtFyEbHldxQhfiQT2cChkS
         1a2yJkNJtUaNtyN6HLP/HwAeizwv6Y9NVHxRaK2na2Jb7UBlPsUEwAd3XGlxzMCQmV
         sOzPAOo6RSrwJJlW1J4DoGrS3wP7A/b/KQfNHY1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jian Zhang <zhangjian210@huawei.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/545] drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.
Date:   Fri, 19 Aug 2022 17:39:54 +0200
Message-Id: <20220819153839.393109559@linuxfoundation.org>
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

From: Jian Zhang <zhangjian210@huawei.com>

[ Upstream commit 48b927770f8ad3f8cf4a024a552abf272af9f592 ]

In exynos7_decon_resume, When it fails, we must use clk_disable_unprepare()
to free resource that have been used.

Fixes: 6f83d20838c09 ("drm/exynos: use DRM_DEV_ERROR to print out error
message")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jian Zhang <zhangjian210@huawei.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos7_drm_decon.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos7_drm_decon.c b/drivers/gpu/drm/exynos/exynos7_drm_decon.c
index f2d87a7445c7..1c04c232dce1 100644
--- a/drivers/gpu/drm/exynos/exynos7_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos7_drm_decon.c
@@ -800,31 +800,40 @@ static int exynos7_decon_resume(struct device *dev)
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to prepare_enable the pclk [%d]\n",
 			      ret);
-		return ret;
+		goto err_pclk_enable;
 	}
 
 	ret = clk_prepare_enable(ctx->aclk);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to prepare_enable the aclk [%d]\n",
 			      ret);
-		return ret;
+		goto err_aclk_enable;
 	}
 
 	ret = clk_prepare_enable(ctx->eclk);
 	if  (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to prepare_enable the eclk [%d]\n",
 			      ret);
-		return ret;
+		goto err_eclk_enable;
 	}
 
 	ret = clk_prepare_enable(ctx->vclk);
 	if  (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to prepare_enable the vclk [%d]\n",
 			      ret);
-		return ret;
+		goto err_vclk_enable;
 	}
 
 	return 0;
+
+err_vclk_enable:
+	clk_disable_unprepare(ctx->eclk);
+err_eclk_enable:
+	clk_disable_unprepare(ctx->aclk);
+err_aclk_enable:
+	clk_disable_unprepare(ctx->pclk);
+err_pclk_enable:
+	return ret;
 }
 #endif
 
-- 
2.35.1



