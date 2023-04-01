Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EF16D2CD2
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjDABog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbjDABnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:43:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6D021ABF;
        Fri, 31 Mar 2023 18:43:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C37EEB832FF;
        Sat,  1 Apr 2023 01:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C79C433EF;
        Sat,  1 Apr 2023 01:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313351;
        bh=ln6XzTMYNR/OxX7UOrfi6W+HYBL2AaaT9QbQO/DSoqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHG2q2cH0Jt7j7cHGN2wTnEpwsx3fE3TLCB8k+nGlN2cCdXPRn2ctJ5BShiEOrBqE
         lgN9WQBb0ML5l/etvLFOGyuj0/TTc5YKX5uji7BTGQ8Ayjn7O4xdvuYvSKZ1kYu1Sr
         g7nTwYV9YCDC6HVUme4Q2+AkOKluHPY4QCbNW63lakD2pIGICenhQ+NBF4A3l0Upye
         LBVyVq/Plp1yt9gMhdqJHZf2s0NdbrqrRLvK0Y2hbbFpj+8S92QW67EWyGAiAqsReM
         8m8PCN4HcVtC/UT0eA2iD0FHaF4fNmodY0dg1ZZ5wUo6l3t7rZoqofh4Y3bTCAv4l6
         2z6cONawbKDwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YuBiao Wang <YuBiao.Wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        andrey.grodzovsky@amd.com, Jiadong.Zhu@amd.com,
        gpiccoli@igalia.com, Likun.Gao@amd.com, Jack.Xiao@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 23/25] drm/amdgpu: Force signal hw_fences that are embedded in non-sched jobs
Date:   Fri, 31 Mar 2023 21:41:21 -0400
Message-Id: <20230401014126.3356410-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YuBiao Wang <YuBiao.Wang@amd.com>

[ Upstream commit 033c56474acf567a450f8bafca50e0b610f2b716 ]

[Why]
For engines not supporting soft reset, i.e. VCN, there will be a failed
ib test before mode 1 reset during asic reset. The fences in this case
are never signaled and next time when we try to free the sa_bo, kernel
will hang.

[How]
During pre_asic_reset, driver will clear job fences and afterwards the
fences' refcount will be reduced to 1. For drm_sched_jobs it will be
released in job_free_cb, and for non-sched jobs like ib_test, it's meant
to be released in sa_bo_free but only when the fences are signaled. So
we have to force signal the non_sched bad job's fence during
pre_asic_reset or the clear is not complete.

Signed-off-by: YuBiao Wang <YuBiao.Wang@amd.com>
Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index faff4a3f96e6e..f52d0ba91a770 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -678,6 +678,15 @@ void amdgpu_fence_driver_clear_job_fences(struct amdgpu_ring *ring)
 		ptr = &ring->fence_drv.fences[i];
 		old = rcu_dereference_protected(*ptr, 1);
 		if (old && old->ops == &amdgpu_job_fence_ops) {
+			struct amdgpu_job *job;
+
+			/* For non-scheduler bad job, i.e. failed ib test, we need to signal
+			 * it right here or we won't be able to track them in fence_drv
+			 * and they will remain unsignaled during sa_bo free.
+			 */
+			job = container_of(old, struct amdgpu_job, hw_fence);
+			if (!job->base.s_fence && !dma_fence_is_signaled(old))
+				dma_fence_signal(old);
 			RCU_INIT_POINTER(*ptr, NULL);
 			dma_fence_put(old);
 		}
-- 
2.39.2

