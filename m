Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8E664337A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiLETgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiLETgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1141AF32
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48C8CCE139A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E3BC433D6;
        Mon,  5 Dec 2022 19:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268792;
        bh=TzSWfudO6EtzyyvcWQPpWmYjX005ZJkvgkCPJNQmU3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Y6WYcNTC3tmRGr6KlF2EpoDujBKNmMyrzfH8UDCxXfLfGXbgT+Dv9O+TsWq6rig8
         WP7zFZbWGbhiIWnRpvUIkqVu/pTd/9FWP6Y9z1M1WLy5TLV2pQTANm8ozDm+lJOn91
         UrbchLxNiqAzBuX6lfBu0SawdF8gq1H4njGCdXB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Wilson <chris.p.wilson@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/120] drm/i915/gt: Use i915_vm_put on ppgtt_create error paths
Date:   Mon,  5 Dec 2022 20:09:03 +0100
Message-Id: <20221205190806.642988906@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

[ Upstream commit 20e377e7b2e7c327039f10db80ba5bcc1f6c882d ]

Now that the scratch page and page directories have a reference back to
the i915_address_space, we cannot do an immediate free of the ppgtt upon
error as those buffer objects will perform a later i915_vm_put in their
deferred frees.

The downside is that by replacing the onion unwind along the error
paths, the ppgtt cleanup must handle a partially constructed vm. This
includes ensuring that the vm->cleanup is set prior to the error path.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6900
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Fixes: 4d8151ae5329 ("drm/i915: Don't free shared locks while shared")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.14+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220926153333.102195-1-matthew.auld@intel.com
(cherry picked from commit c286558f58535cf97b717b946d6c96d774a09d17)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen6_ppgtt.c | 16 ++++----
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c | 56 ++++++++++++++--------------
 drivers/gpu/drm/i915/gt/intel_gtt.c  |  3 ++
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
index 557ef25be057..b257666a26fc 100644
--- a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
@@ -244,6 +244,7 @@ static int gen6_ppgtt_init_scratch(struct gen6_ppgtt *ppgtt)
 	i915_gem_object_put(vm->scratch[1]);
 err_scratch0:
 	i915_gem_object_put(vm->scratch[0]);
+	vm->scratch[0] = NULL;
 	return ret;
 }
 
@@ -265,9 +266,10 @@ static void gen6_ppgtt_cleanup(struct i915_address_space *vm)
 	gen6_ppgtt_free_pd(ppgtt);
 	free_scratch(vm);
 
-	mutex_destroy(&ppgtt->flush);
+	if (ppgtt->base.pd)
+		free_pd(&ppgtt->base.vm, ppgtt->base.pd);
 
-	free_pd(&ppgtt->base.vm, ppgtt->base.pd);
+	mutex_destroy(&ppgtt->flush);
 }
 
 static int pd_vma_set_pages(struct i915_vma *vma)
@@ -470,19 +472,17 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_gt *gt)
 
 	err = gen6_ppgtt_init_scratch(ppgtt);
 	if (err)
-		goto err_free;
+		goto err_put;
 
 	ppgtt->base.pd = gen6_alloc_top_pd(ppgtt);
 	if (IS_ERR(ppgtt->base.pd)) {
 		err = PTR_ERR(ppgtt->base.pd);
-		goto err_scratch;
+		goto err_put;
 	}
 
 	return &ppgtt->base;
 
-err_scratch:
-	free_scratch(&ppgtt->base.vm);
-err_free:
-	kfree(ppgtt);
+err_put:
+	i915_vm_put(&ppgtt->base.vm);
 	return ERR_PTR(err);
 }
diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
index 6e0e52eeb87a..0cf604c5a6c2 100644
--- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
@@ -196,7 +196,10 @@ static void gen8_ppgtt_cleanup(struct i915_address_space *vm)
 	if (intel_vgpu_active(vm->i915))
 		gen8_ppgtt_notify_vgt(ppgtt, false);
 
-	__gen8_ppgtt_cleanup(vm, ppgtt->pd, gen8_pd_top_count(vm), vm->top);
+	if (ppgtt->pd)
+		__gen8_ppgtt_cleanup(vm, ppgtt->pd,
+				     gen8_pd_top_count(vm), vm->top);
+
 	free_scratch(vm);
 }
 
@@ -656,8 +659,10 @@ static int gen8_init_scratch(struct i915_address_space *vm)
 		struct drm_i915_gem_object *obj;
 
 		obj = vm->alloc_pt_dma(vm, I915_GTT_PAGE_SIZE_4K);
-		if (IS_ERR(obj))
+		if (IS_ERR(obj)) {
+			ret = PTR_ERR(obj);
 			goto free_scratch;
+		}
 
 		ret = map_pt_dma(vm, obj);
 		if (ret) {
@@ -676,7 +681,8 @@ static int gen8_init_scratch(struct i915_address_space *vm)
 free_scratch:
 	while (i--)
 		i915_gem_object_put(vm->scratch[i]);
-	return -ENOMEM;
+	vm->scratch[0] = NULL;
+	return ret;
 }
 
 static int gen8_preallocate_top_level_pdp(struct i915_ppgtt *ppgtt)
@@ -753,6 +759,7 @@ gen8_alloc_top_pd(struct i915_address_space *vm)
  */
 struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt)
 {
+	struct i915_page_directory *pd;
 	struct i915_ppgtt *ppgtt;
 	int err;
 
@@ -779,44 +786,39 @@ struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt)
 	else
 		ppgtt->vm.alloc_pt_dma = alloc_pt_dma;
 
+	ppgtt->vm.pte_encode = gen8_pte_encode;
+
+	ppgtt->vm.bind_async_flags = I915_VMA_LOCAL_BIND;
+	ppgtt->vm.insert_entries = gen8_ppgtt_insert;
+	ppgtt->vm.insert_page = gen8_ppgtt_insert_entry;
+	ppgtt->vm.allocate_va_range = gen8_ppgtt_alloc;
+	ppgtt->vm.clear_range = gen8_ppgtt_clear;
+	ppgtt->vm.foreach = gen8_ppgtt_foreach;
+	ppgtt->vm.cleanup = gen8_ppgtt_cleanup;
+
 	err = gen8_init_scratch(&ppgtt->vm);
 	if (err)
-		goto err_free;
+		goto err_put;
 
-	ppgtt->pd = gen8_alloc_top_pd(&ppgtt->vm);
-	if (IS_ERR(ppgtt->pd)) {
-		err = PTR_ERR(ppgtt->pd);
-		goto err_free_scratch;
+	pd = gen8_alloc_top_pd(&ppgtt->vm);
+	if (IS_ERR(pd)) {
+		err = PTR_ERR(pd);
+		goto err_put;
 	}
+	ppgtt->pd = pd;
 
 	if (!i915_vm_is_4lvl(&ppgtt->vm)) {
 		err = gen8_preallocate_top_level_pdp(ppgtt);
 		if (err)
-			goto err_free_pd;
+			goto err_put;
 	}
 
-	ppgtt->vm.bind_async_flags = I915_VMA_LOCAL_BIND;
-	ppgtt->vm.insert_entries = gen8_ppgtt_insert;
-	ppgtt->vm.insert_page = gen8_ppgtt_insert_entry;
-	ppgtt->vm.allocate_va_range = gen8_ppgtt_alloc;
-	ppgtt->vm.clear_range = gen8_ppgtt_clear;
-	ppgtt->vm.foreach = gen8_ppgtt_foreach;
-
-	ppgtt->vm.pte_encode = gen8_pte_encode;
-
 	if (intel_vgpu_active(gt->i915))
 		gen8_ppgtt_notify_vgt(ppgtt, true);
 
-	ppgtt->vm.cleanup = gen8_ppgtt_cleanup;
-
 	return ppgtt;
 
-err_free_pd:
-	__gen8_ppgtt_cleanup(&ppgtt->vm, ppgtt->pd,
-			     gen8_pd_top_count(&ppgtt->vm), ppgtt->vm.top);
-err_free_scratch:
-	free_scratch(&ppgtt->vm);
-err_free:
-	kfree(ppgtt);
+err_put:
+	i915_vm_put(&ppgtt->vm);
 	return ERR_PTR(err);
 }
diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.c b/drivers/gpu/drm/i915/gt/intel_gtt.c
index e137dd32b5b8..2d3a979736cc 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
@@ -341,6 +341,9 @@ void free_scratch(struct i915_address_space *vm)
 {
 	int i;
 
+	if (!vm->scratch[0])
+		return;
+
 	for (i = 0; i <= vm->top; i++)
 		i915_gem_object_put(vm->scratch[i]);
 }
-- 
2.35.1



