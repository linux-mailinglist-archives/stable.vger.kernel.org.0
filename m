Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5602B5949DA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354421AbiHOXy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354891AbiHOXvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382E790812;
        Mon, 15 Aug 2022 13:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7DFF60F17;
        Mon, 15 Aug 2022 20:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0840C433D6;
        Mon, 15 Aug 2022 20:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594569;
        bh=h/PfWu7Xr8kqLVrdH1TS0WY7MGdiEQCDXRo1umr4zv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok6B1Br1+4tTuX1VVYHfny7GYI1Xvfch/vcYDgbaXOg7Z1mQDPL7gF1vZMzfHQetz
         /06MuDXSLnRvhW+xvI0NRJAF5sRc3uuD6Qy+PMrv7ZbU4hi9L2GOwoLyjHF+HG5Dh6
         aff/HC/4q2NbPZF/W+gM1XzN8wAL0KYSZJaHBPmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jian Zhang <zhangjian210@huawei.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0490/1157] drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.
Date:   Mon, 15 Aug 2022 19:57:26 +0200
Message-Id: <20220815180459.233121096@linuxfoundation.org>
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
index c04264f70ad1..3c31405600f0 100644
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



