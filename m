Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96466BB24D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbjCOMfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjCOMez (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193109CBE8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1793CB81E07
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFEDC433D2;
        Wed, 15 Mar 2023 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883606;
        bh=QN8I2JvJ4gtzOVUQJ0cpI/91XsA4DHuXMq3Kv6D7jrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iy700OnVLyJ3hCtai+49vPB1n5Y60hTCKBZZUDJeyIWz97b0QgDJ6g+oeP02kC36/
         3CIRY0GLkfSvw++AEZ3uIB5et+YKkvVRj8ST1HdlnEHfuuLpXwmtNUtWa8CuFJcvoE
         XZXX5t9wsj/1ftZU+LshTq4HTFl3gYk1qBiQnxcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/143] drm/msm/a5xx: fix context faults during ring switch
Date:   Wed, 15 Mar 2023 13:12:29 +0100
Message-Id: <20230315115742.443009726@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 32e7083429d46f29080626fe387ff90c086b1fbe ]

The rptr_addr is set in the preempt_init_ring(), which is called from
a5xx_gpu_init(). It uses shadowptr() to set the address, however the
shadow_iova is not yet initialized at that time. Move the rptr_addr
setting to the a5xx_preempt_hw_init() which is called after setting the
shadow_iova, getting the correct value for the address.

Fixes: 8907afb476ac ("drm/msm: Allow a5xx to mark the RPTR shadow as privileged")
Suggested-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/522640/
Link: https://lore.kernel.org/r/20230214020956.164473-5-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index 6e326d851ba53..e0eef47dae632 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -208,6 +208,7 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
+		a5xx_gpu->preempt[i]->rptr_addr = shadowptr(a5xx_gpu, gpu->rb[i]);
 	}
 
 	/* Write a 0 to signal that we aren't switching pagetables */
@@ -259,7 +260,6 @@ static int preempt_init_ring(struct a5xx_gpu *a5xx_gpu,
 	ptr->data = 0;
 	ptr->cntl = MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE;
 
-	ptr->rptr_addr = shadowptr(a5xx_gpu, ring);
 	ptr->counter = counters_iova;
 
 	return 0;
-- 
2.39.2



