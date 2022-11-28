Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E50463AF8E
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiK1RnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiK1RnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:43:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DACD2B182;
        Mon, 28 Nov 2022 09:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0FFB612E9;
        Mon, 28 Nov 2022 17:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881EBC433C1;
        Mon, 28 Nov 2022 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657223;
        bh=lXZiz06nGUFjpl4Sg8z+2Fdo2Vj99GtqplC0GDDwru4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZedoSuM8V4gtX2UuYy3Rw4gkTAKxSR1yvz4TmHV+IUFyjv7QmVfP0iz3D2Naae8vt
         KMfnYBNAxyzuGyoXPpedW1n4fVIv93KjrcWUkSrqDBTBCyN8huJA3jeBzMpryzn/dQ
         cHkubCfl3eLMGwbV+zugL5w8UHO/GPDo5I23u4KW0GxY1hW2PmyqWf5qr2RIPUxMMF
         O6RP3b/dRCa/ajflvQA0ijQgSQglToqAkldM9Y1cdCFEd0+x1UxLyQ6Odo+K2JoSS7
         AsCm8lyXzP6kqUS/O7dOOoKSRQR6aN2HGtCJ16maGKIwWvLE8gYIZwiWRiXeIhktp8
         f+rKsssPCpJ7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Stanley.Yang" <Stanley.Yang@amd.com>,
        Tao Zhou <tao.zhou1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        andrey.grodzovsky@amd.com, surbhi.kakarya@amd.com,
        Likun.Gao@amd.com, strochuk@ispras.ru, YuBiao.Wang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 39/39] drm/amdgpu: fix use-after-free during gpu recovery
Date:   Mon, 28 Nov 2022 12:36:19 -0500
Message-Id: <20221128173642.1441232-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Stanley.Yang" <Stanley.Yang@amd.com>

[ Upstream commit 3cb93f390453cde4d6afda1587aaa00e75e09617 ]

[Why]
    [  754.862560] refcount_t: underflow; use-after-free.
    [  754.862898] Call Trace:
    [  754.862903]  <TASK>
    [  754.862913]  amdgpu_job_free_cb+0xc2/0xe1 [amdgpu]
    [  754.863543]  drm_sched_main.cold+0x34/0x39 [amd_sched]

[How]
    The fw_fence may be not init, check whether dma_fence_init
    is performed before job free

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index c2fd6f3076a6..e9583a58cce0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -150,7 +150,11 @@ static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
 	amdgpu_sync_free(&job->sync);
 	amdgpu_sync_free(&job->sched_sync);
 
-	dma_fence_put(&job->hw_fence);
+	/* only put the hw fence if has embedded fence */
+	if (!job->hw_fence.ops)
+		kfree(job);
+	else
+		dma_fence_put(&job->hw_fence);
 }
 
 void amdgpu_job_free(struct amdgpu_job *job)
-- 
2.35.1

