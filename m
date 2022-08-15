Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D11594885
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354470AbiHOXsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354652AbiHOXqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CDD399CC;
        Mon, 15 Aug 2022 13:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8F9360B6E;
        Mon, 15 Aug 2022 20:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7069C433C1;
        Mon, 15 Aug 2022 20:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594472;
        bh=6U8qGS21fq+Kq2W4/KJtwovisBl/qNohL58egSw7v+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTo5D4LJb/ASpTfWF90JOcT0VzZ69oulk3K4Lcx+ZMeBNGdOlzI1gbijcRgJoUEsq
         fM1LnKNOBHi39RnAVk473t/kYqZpc4YW8Z/HHU56pTlDOk+xB2DW00JbJ6r6Hr/0oP
         Uv8csfTMMMxIFf/Uz2VcYa0VefmrwX+6KXTu/rs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0441/1157] drm/msm: Fix fence rollover issue
Date:   Mon, 15 Aug 2022 19:56:37 +0200
Message-Id: <20220815180457.256915051@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 2311720a0182756f175fbf4afc1fb76ac487b587 ]

And while we are at it, let's start the fence counter close to the
rollover point so that if issues slip in, they are more obvious.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: fde5de6cb461 ("drm/msm: move fence code to it's own file")
Fixes: 5f3aee4ceb5b ("drm/msm: Handle fence rollover")
Patchwork: https://patchwork.freedesktop.org/patch/489619/
Link: https://lore.kernel.org/r/20220615162435.3011793-1-robdclark@gmail.com
[DB: fixed the conflict while applying the patch]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_fence.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index 38e3323bc232..a47e5837c528 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -28,6 +28,14 @@ msm_fence_context_alloc(struct drm_device *dev, volatile uint32_t *fenceptr,
 	fctx->fenceptr = fenceptr;
 	spin_lock_init(&fctx->spinlock);
 
+	/*
+	 * Start out close to the 32b fence rollover point, so we can
+	 * catch bugs with fence comparisons.
+	 */
+	fctx->last_fence = 0xffffff00;
+	fctx->completed_fence = fctx->last_fence;
+	*fctx->fenceptr = fctx->last_fence;
+
 	return fctx;
 }
 
@@ -52,7 +60,8 @@ void msm_update_fence(struct msm_fence_context *fctx, uint32_t fence)
 	unsigned long flags;
 
 	spin_lock_irqsave(&fctx->spinlock, flags);
-	fctx->completed_fence = max(fence, fctx->completed_fence);
+	if (fence_after(fence, fctx->completed_fence))
+		fctx->completed_fence = fence;
 	spin_unlock_irqrestore(&fctx->spinlock, flags);
 }
 
-- 
2.35.1



