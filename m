Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766D35A06B6
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiHYBoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiHYBnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:43:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0719C537;
        Wed, 24 Aug 2022 18:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63CD26192F;
        Thu, 25 Aug 2022 01:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121E1C433D6;
        Thu, 25 Aug 2022 01:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391561;
        bh=vAN1c5AjNN2rDm92kIqJFVSrUWQ5pec54nV3uN1V/Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRTwa97iAy8RZj1QbWI2RI2Ah5wPk1iHR4t4y/MneDLie3HPWA03qfDnRShY3EEot
         TacxMq3PI1dhmllKAfZPMxzgNWX4nCKuxjJgkNRji8MhG3baPkW156flrb/iPlQ+AA
         qiaDcpD7hUCHEVMe1y+dbB4N3F6ZT7D1Khg2LSDz0ZcSJjmQZ1ul/PD3TmC43bGPEZ
         0d22BpOhKs/+Tke9TkJLTWTjV4amtjxjRDvKdzzU4Q8WPL77jtwYl/lqCrV/Y97OCq
         X+GmKXie0+GcmfPcmcZBtwFeTPjudgrgWxmQgePiIYgC99SVBSXOG4tItdgSwwide+
         y6UK1xvelfXnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dusica Milinkovic <Dusica.Milinkovic@amd.com>,
        Shaoyun Liu <shaoyun.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, andrey.grodzovsky@amd.com,
        lijo.lazar@amd.com, mario.limonciello@amd.com, Likun.Gao@amd.com,
        evan.quan@amd.com, Jack.Xiao@amd.com, YiPeng.Chai@amd.com,
        tao.zhou1@amd.com, Prike.Liang@amd.com, lang.yu@amd.com,
        victor.skvortsov@amd.com, Yuliang.Shi@amd.com,
        harry.wentland@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 08/11] drm/amdgpu: Increase tlb flush timeout for sriov
Date:   Wed, 24 Aug 2022 21:38:29 -0400
Message-Id: <20220825013836.23205-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013836.23205-1-sashal@kernel.org>
References: <20220825013836.23205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Dusica Milinkovic <Dusica.Milinkovic@amd.com>

[ Upstream commit 373008bfc9cdb0f050258947fa5a095f0657e1bc ]

[Why]
During multi-vf executing benchmark (Luxmark) observed kiq error timeout.
It happenes because all of VFs do the tlb invalidation at the same time.
Although each VF has the invalidate register set, from hardware side
the invalidate requests are queue to execute.

[How]
In case of 12 VF increase timeout on 12*100ms

Signed-off-by: Dusica Milinkovic <Dusica.Milinkovic@amd.com>
Acked-by: Shaoyun Liu <shaoyun.liu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h    | 2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c | 3 ++-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index d949d6c52f24..ff5555353eb4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -283,7 +283,7 @@ enum amdgpu_kiq_irq {
 	AMDGPU_CP_KIQ_IRQ_DRIVER0 = 0,
 	AMDGPU_CP_KIQ_IRQ_LAST
 };
-
+#define SRIOV_USEC_TIMEOUT  1200000 /* wait 12 * 100ms for SRIOV */
 #define MAX_KIQ_REG_WAIT       5000 /* in usecs, 5ms */
 #define MAX_KIQ_REG_BAILOUT_INTERVAL   5 /* in msecs, 5ms */
 #define MAX_KIQ_REG_TRY 80 /* 20 -> 80 */
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 150fa5258fb6..2aa9242c58ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -371,6 +371,7 @@ static int gmc_v10_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 	uint32_t seq;
 	uint16_t queried_pasid;
 	bool ret;
+	u32 usec_timeout = amdgpu_sriov_vf(adev) ? SRIOV_USEC_TIMEOUT : adev->usec_timeout;
 	struct amdgpu_ring *ring = &adev->gfx.kiq.ring;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq;
 
@@ -389,7 +390,7 @@ static int gmc_v10_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 
 		amdgpu_ring_commit(ring);
 		spin_unlock(&adev->gfx.kiq.ring_lock);
-		r = amdgpu_fence_wait_polling(ring, seq, adev->usec_timeout);
+		r = amdgpu_fence_wait_polling(ring, seq, usec_timeout);
 		if (r < 1) {
 			dev_err(adev->dev, "wait for kiq fence error: %ld.\n", r);
 			return -ETIME;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 3a864041968f..1673bf3bae55 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -839,6 +839,7 @@ static int gmc_v9_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 	uint32_t seq;
 	uint16_t queried_pasid;
 	bool ret;
+	u32 usec_timeout = amdgpu_sriov_vf(adev) ? SRIOV_USEC_TIMEOUT : adev->usec_timeout;
 	struct amdgpu_ring *ring = &adev->gfx.kiq.ring;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq;
 
@@ -878,7 +879,7 @@ static int gmc_v9_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 
 		amdgpu_ring_commit(ring);
 		spin_unlock(&adev->gfx.kiq.ring_lock);
-		r = amdgpu_fence_wait_polling(ring, seq, adev->usec_timeout);
+		r = amdgpu_fence_wait_polling(ring, seq, usec_timeout);
 		if (r < 1) {
 			dev_err(adev->dev, "wait for kiq fence error: %ld.\n", r);
 			up_read(&adev->reset_sem);
-- 
2.35.1

