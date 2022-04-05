Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7D84F36FD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbiDELJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348807AbiDEJsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C729024F;
        Tue,  5 Apr 2022 02:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9360B81C8B;
        Tue,  5 Apr 2022 09:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E2BC385A2;
        Tue,  5 Apr 2022 09:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151349;
        bh=+vB/c5TYSJXJNmD9pjNpxLmLtUsmHAcZ/hjWBUHuL58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyBmURC0NBKIYO678poXmdxgFmYCysBq9pzY/sS19WxfI9gbrcxNuVjdmn0oMEfMw
         BKZ/AZNuac4CB8i0ZjtsLHhg+S5eSSq0Ke/EZ3duyzEa1syK3MtOy57bwFwq07AMaV
         FExo+LVGG9FAoEOp9rdQADwyQJCcJ4zZGKdjGHWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/913] drm/panfrost: Check for error num after setting mask
Date:   Tue,  5 Apr 2022 09:24:06 +0200
Message-Id: <20220405070351.357429769@linuxfoundation.org>
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

[ Upstream commit 44ab30b056149bd59dd7989a593dd25ead6007fd ]

Because of the possible failure of the dma_supported(), the
dma_set_mask_and_coherent() may return error num.
Therefore, it should be better to check it and return the error if
fails.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
[Steve: fix Fixes: line]
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220106030326.2620942-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index bbe628b306ee..f8355de6e335 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -360,8 +360,11 @@ int panfrost_gpu_init(struct panfrost_device *pfdev)
 
 	panfrost_gpu_init_features(pfdev);
 
-	dma_set_mask_and_coherent(pfdev->dev,
+	err = dma_set_mask_and_coherent(pfdev->dev,
 		DMA_BIT_MASK(FIELD_GET(0xff00, pfdev->features.mmu_features)));
+	if (err)
+		return err;
+
 	dma_set_max_seg_size(pfdev->dev, UINT_MAX);
 
 	irq = platform_get_irq_byname(to_platform_device(pfdev->dev), "gpu");
-- 
2.34.1



