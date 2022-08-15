Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4566B5941A9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243260AbiHOVKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348097AbiHOVIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C0E52E58;
        Mon, 15 Aug 2022 12:18:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2784CE12C5;
        Mon, 15 Aug 2022 19:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54F3C433D6;
        Mon, 15 Aug 2022 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591102;
        bh=5kYBB6X/8iRDlgaDFIsv3QBoZ6DilMJxaXnfoQdzZXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pF63v/cTNnt0I+aZmVmDUqOQcOkFLjIzFF0XDirpC++A3vQloCrHmBEhmk83q97rO
         FKmbrKcIgtplR8ghwEkI5m7ankaC4qOJ2zgGPaPIbzoKr22Sg3+S4+XhtYbkI+MTvJ
         tQG/SYhqbfYUtDN+GJXn6YFlwCsbdE8C/mJ22dUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0473/1095] drm/amdgpu: restore original stable pstate on ctx fini
Date:   Mon, 15 Aug 2022 19:57:52 +0200
Message-Id: <20220815180449.144415984@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 958afce98c2c86732483458c03540d3c6ef45254 ]

Save the original stable pstate on ctx init and restore
it on ctx fini so that we restore a manually selected
stable pstate on ctx exit.

v2: fix init order (Alex)
v3: don't add new variable to ctx struct (Evan)

Fixes: c65b364c52ba ("drm/amdgpu/ctx: only reset stable pstate if the user changed it (v2)")
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 60 ++++++++++++++-----------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index a61e4c83a545..95ed528e6ec5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -220,32 +220,6 @@ static int amdgpu_ctx_init_entity(struct amdgpu_ctx *ctx, u32 hw_ip,
 	return r;
 }
 
-static int amdgpu_ctx_init(struct amdgpu_ctx_mgr *mgr, int32_t priority,
-			   struct drm_file *filp, struct amdgpu_ctx *ctx)
-{
-	int r;
-
-	r = amdgpu_ctx_priority_permit(filp, priority);
-	if (r)
-		return r;
-
-	memset(ctx, 0, sizeof(*ctx));
-
-	kref_init(&ctx->refcount);
-	ctx->mgr = mgr;
-	spin_lock_init(&ctx->ring_lock);
-	mutex_init(&ctx->lock);
-
-	ctx->reset_counter = atomic_read(&mgr->adev->gpu_reset_counter);
-	ctx->reset_counter_query = ctx->reset_counter;
-	ctx->vram_lost_counter = atomic_read(&mgr->adev->vram_lost_counter);
-	ctx->init_priority = priority;
-	ctx->override_priority = AMDGPU_CTX_PRIORITY_UNSET;
-	ctx->stable_pstate = AMDGPU_CTX_STABLE_PSTATE_NONE;
-
-	return 0;
-}
-
 static void amdgpu_ctx_fini_entity(struct amdgpu_ctx_entity *entity)
 {
 
@@ -288,6 +262,38 @@ static int amdgpu_ctx_get_stable_pstate(struct amdgpu_ctx *ctx,
 	return 0;
 }
 
+static int amdgpu_ctx_init(struct amdgpu_ctx_mgr *mgr, int32_t priority,
+			   struct drm_file *filp, struct amdgpu_ctx *ctx)
+{
+	u32 current_stable_pstate;
+	int r;
+
+	r = amdgpu_ctx_priority_permit(filp, priority);
+	if (r)
+		return r;
+
+	memset(ctx, 0, sizeof(*ctx));
+
+	kref_init(&ctx->refcount);
+	ctx->mgr = mgr;
+	spin_lock_init(&ctx->ring_lock);
+	mutex_init(&ctx->lock);
+
+	ctx->reset_counter = atomic_read(&mgr->adev->gpu_reset_counter);
+	ctx->reset_counter_query = ctx->reset_counter;
+	ctx->vram_lost_counter = atomic_read(&mgr->adev->vram_lost_counter);
+	ctx->init_priority = priority;
+	ctx->override_priority = AMDGPU_CTX_PRIORITY_UNSET;
+
+	r = amdgpu_ctx_get_stable_pstate(ctx, &current_stable_pstate);
+	if (r)
+		return r;
+
+	ctx->stable_pstate = current_stable_pstate;
+
+	return 0;
+}
+
 static int amdgpu_ctx_set_stable_pstate(struct amdgpu_ctx *ctx,
 					u32 stable_pstate)
 {
@@ -357,7 +363,7 @@ static void amdgpu_ctx_fini(struct kref *ref)
 	}
 
 	if (drm_dev_enter(&adev->ddev, &idx)) {
-		amdgpu_ctx_set_stable_pstate(ctx, AMDGPU_CTX_STABLE_PSTATE_NONE);
+		amdgpu_ctx_set_stable_pstate(ctx, ctx->stable_pstate);
 		drm_dev_exit(idx);
 	}
 
-- 
2.35.1



