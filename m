Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5E4F36E1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiDELIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348805AbiDEJsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BDC8D6A2;
        Tue,  5 Apr 2022 02:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE61615E5;
        Tue,  5 Apr 2022 09:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC8FC385A2;
        Tue,  5 Apr 2022 09:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151346;
        bh=nYh1Ftmu1o81xPko6U0qrJ5484J5I6gNUcZjFQiYf44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adcB+UrDX8c9S2MNxb7XlIqDmOF6XmsNJZtDq0mmT4qo8xuYeLSZSMOrATlGkg+QT
         xnKGwoxtYlsofF/Pqm1wR2qkcIMC25KAym8GXIaaHbnlC8FD/aChMCZlxN4ODijuHQ
         AHJzy/pioXD/HdJeIBg7tbbKycBy+kx5UuQ6155o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Melissa Wen <mwen@igalia.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 383/913] drm/v3d/v3d_drv: Check for error num after setting mask
Date:   Tue,  5 Apr 2022 09:24:05 +0200
Message-Id: <20220405070351.327697994@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 4a39156166b90465da0f9a33b3442d63b5651bec ]

Because of the possible failure of the dma_supported(), the
dma_set_mask_and_coherent() may return error num.
Therefore, it should be better to check it and return the error if
fails.
Also, we can create a variable for the mask to solve the
alignment issue.

Fixes: 334dd38a3878 ("drm/v3d: Set dma_mask as well as coherent_dma_mask")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220110013807.4105270-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index 9403c3b36aca..6407a006d6ec 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -221,6 +221,7 @@ static int v3d_platform_drm_probe(struct platform_device *pdev)
 	int ret;
 	u32 mmu_debug;
 	u32 ident1;
+	u64 mask;
 
 
 	v3d = devm_drm_dev_alloc(dev, &v3d_drm_driver, struct v3d_dev, drm);
@@ -240,8 +241,11 @@ static int v3d_platform_drm_probe(struct platform_device *pdev)
 		return ret;
 
 	mmu_debug = V3D_READ(V3D_MMU_DEBUG_INFO);
-	dma_set_mask_and_coherent(dev,
-		DMA_BIT_MASK(30 + V3D_GET_FIELD(mmu_debug, V3D_MMU_PA_WIDTH)));
+	mask = DMA_BIT_MASK(30 + V3D_GET_FIELD(mmu_debug, V3D_MMU_PA_WIDTH));
+	ret = dma_set_mask_and_coherent(dev, mask);
+	if (ret)
+		return ret;
+
 	v3d->va_width = 30 + V3D_GET_FIELD(mmu_debug, V3D_MMU_VA_WIDTH);
 
 	ident1 = V3D_READ(V3D_HUB_IDENT1);
-- 
2.34.1



