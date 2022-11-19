Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AD66309BC
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbiKSCRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiKSCQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:16:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BF610054;
        Fri, 18 Nov 2022 18:13:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3364B82670;
        Sat, 19 Nov 2022 02:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39769C433C1;
        Sat, 19 Nov 2022 02:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824007;
        bh=czlSI6kM+LOpXa1wVcw3iT0aw8FLrZoUgaCP3L537J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMNjrGozkItOmLBOEFc0hW8jl1jepw/favOyeN0C6pmS5lNeMpzj713yMwva5smaq
         xaNaLKaOm7hH5ZFimQtE7ciXsufFLr4rSYxS7WoLXnY1RuuCiqaj8O7vPcLwVD3OPr
         vcu4HCx1t3wgD2JlcNoMw1GuFOS6dq5HuSKcNPVx2rXkl+5w53CD6MDF9rRdoLLQ8C
         nDqkmqN3DgwJc732gEBlaCXVjc3okzvDF26uLOL9P2jgx1RUKYonI5ZzF6bSGIJXjf
         u4O1/OaOZBZVTaJoCxQcrQiPBncXn8TLp3hArs836E7jZxh2cQktO37styYOOBixmE
         PYodQTMW072wQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, Felix.Kuehling@amd.com,
        qiang.yu@amd.com, mukul.joshi@amd.com, airlied@redhat.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 39/44] drm/amdgpu: Drop eviction lock when allocating PT BO
Date:   Fri, 18 Nov 2022 21:11:19 -0500
Message-Id: <20221119021124.1773699-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit e034a0d9aaee5c9129d5dfdfdfcab988a953412d ]

Re-take the eviction lock immediately again after the allocation is
completed, to fix circular locking warning with drm_buddy allocator.

Move amdgpu_vm_eviction_lock/unlock/trylock to amdgpu_vm.h as they are
called from multiple files.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c    | 26 -----------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h    | 26 +++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c |  2 ++
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 04130f8813ef..369c0d03e3c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -143,32 +143,6 @@ int amdgpu_vm_set_pasid(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	return 0;
 }
 
-/*
- * vm eviction_lock can be taken in MMU notifiers. Make sure no reclaim-FS
- * happens while holding this lock anywhere to prevent deadlocks when
- * an MMU notifier runs in reclaim-FS context.
- */
-static inline void amdgpu_vm_eviction_lock(struct amdgpu_vm *vm)
-{
-	mutex_lock(&vm->eviction_lock);
-	vm->saved_flags = memalloc_noreclaim_save();
-}
-
-static inline int amdgpu_vm_eviction_trylock(struct amdgpu_vm *vm)
-{
-	if (mutex_trylock(&vm->eviction_lock)) {
-		vm->saved_flags = memalloc_noreclaim_save();
-		return 1;
-	}
-	return 0;
-}
-
-static inline void amdgpu_vm_eviction_unlock(struct amdgpu_vm *vm)
-{
-	memalloc_noreclaim_restore(vm->saved_flags);
-	mutex_unlock(&vm->eviction_lock);
-}
-
 /**
  * amdgpu_vm_bo_evicted - vm_bo is evicted
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
index 9ecb7f663e19..1f3599363481 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -488,4 +488,30 @@ static inline uint64_t amdgpu_vm_tlb_seq(struct amdgpu_vm *vm)
 	return atomic64_read(&vm->tlb_seq);
 }
 
+/*
+ * vm eviction_lock can be taken in MMU notifiers. Make sure no reclaim-FS
+ * happens while holding this lock anywhere to prevent deadlocks when
+ * an MMU notifier runs in reclaim-FS context.
+ */
+static inline void amdgpu_vm_eviction_lock(struct amdgpu_vm *vm)
+{
+	mutex_lock(&vm->eviction_lock);
+	vm->saved_flags = memalloc_noreclaim_save();
+}
+
+static inline bool amdgpu_vm_eviction_trylock(struct amdgpu_vm *vm)
+{
+	if (mutex_trylock(&vm->eviction_lock)) {
+		vm->saved_flags = memalloc_noreclaim_save();
+		return true;
+	}
+	return false;
+}
+
+static inline void amdgpu_vm_eviction_unlock(struct amdgpu_vm *vm)
+{
+	memalloc_noreclaim_restore(vm->saved_flags);
+	mutex_unlock(&vm->eviction_lock);
+}
+
 #endif
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
index 88de9f0d4728..983899574464 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -597,7 +597,9 @@ static int amdgpu_vm_pt_alloc(struct amdgpu_device *adev,
 	if (entry->bo)
 		return 0;
 
+	amdgpu_vm_eviction_unlock(vm);
 	r = amdgpu_vm_pt_create(adev, vm, cursor->level, immediate, &pt);
+	amdgpu_vm_eviction_lock(vm);
 	if (r)
 		return r;
 
-- 
2.35.1

