Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E3765D64D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbjADOnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbjADOnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:43:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E381A06D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCD89B81677
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08068C433F2;
        Wed,  4 Jan 2023 14:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843419;
        bh=7pp1OxEIch7oB0OTGSTjQcHg/nN81r2I+gsBt/F92o4=;
        h=Subject:To:Cc:From:Date:From;
        b=KG7vIYfKQhFAHyzxWebBiXf/Ah8uCd111T+rAYLqtQNujj4ah2ejOzlQ9de2rND3I
         QMQKMZyKnDDspe8djcGWgJOLFNDlspnCnIIKKD8earhxcabK6Q14D+MuM2zvROqHjE
         Aw0KIAE9fUTS/YHHkaUgNXDSRgWSXof/lCaBcEoA=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Use i915_vm_put on ppgtt_create error paths" failed to apply to 6.0-stable tree
To:     chris.p.wilson@intel.com, matthew.auld@intel.com,
        stable@vger.kernel.org, thomas.hellstrom@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:43:31 +0100
Message-ID: <16728434117096@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c286558f5853 ("drm/i915/gt: Use i915_vm_put on ppgtt_create error paths")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c286558f58535cf97b717b946d6c96d774a09d17 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris.p.wilson@intel.com>
Date: Mon, 26 Sep 2022 16:33:33 +0100
Subject: [PATCH] drm/i915/gt: Use i915_vm_put on ppgtt_create error paths
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
index 1bb766c79dcb..5aaacc53fa4c 100644
--- a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
@@ -247,6 +247,7 @@ static int gen6_ppgtt_init_scratch(struct gen6_ppgtt *ppgtt)
 	i915_gem_object_put(vm->scratch[1]);
 err_scratch0:
 	i915_gem_object_put(vm->scratch[0]);
+	vm->scratch[0] = NULL;
 	return ret;
 }
 
@@ -268,9 +269,10 @@ static void gen6_ppgtt_cleanup(struct i915_address_space *vm)
 	gen6_ppgtt_free_pd(ppgtt);
 	free_scratch(vm);
 
-	mutex_destroy(&ppgtt->flush);
+	if (ppgtt->base.pd)
+		free_pd(&ppgtt->base.vm, ppgtt->base.pd);
 
-	free_pd(&ppgtt->base.vm, ppgtt->base.pd);
+	mutex_destroy(&ppgtt->flush);
 }
 
 static void pd_vma_bind(struct i915_address_space *vm,
@@ -449,19 +451,17 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_gt *gt)
 
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
index c7bd5d71b03e..2128b7a72a25 100644
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
 
@@ -803,8 +806,10 @@ static int gen8_init_scratch(struct i915_address_space *vm)
 		struct drm_i915_gem_object *obj;
 
 		obj = vm->alloc_pt_dma(vm, I915_GTT_PAGE_SIZE_4K);
-		if (IS_ERR(obj))
+		if (IS_ERR(obj)) {
+			ret = PTR_ERR(obj);
 			goto free_scratch;
+		}
 
 		ret = map_pt_dma(vm, obj);
 		if (ret) {
@@ -823,7 +828,8 @@ static int gen8_init_scratch(struct i915_address_space *vm)
 free_scratch:
 	while (i--)
 		i915_gem_object_put(vm->scratch[i]);
-	return -ENOMEM;
+	vm->scratch[0] = NULL;
+	return ret;
 }
 
 static int gen8_preallocate_top_level_pdp(struct i915_ppgtt *ppgtt)
@@ -901,6 +907,7 @@ gen8_alloc_top_pd(struct i915_address_space *vm)
 struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt,
 				     unsigned long lmem_pt_obj_flags)
 {
+	struct i915_page_directory *pd;
 	struct i915_ppgtt *ppgtt;
 	int err;
 
@@ -946,21 +953,7 @@ struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt,
 		ppgtt->vm.alloc_scratch_dma = alloc_pt_dma;
 	}
 
-	err = gen8_init_scratch(&ppgtt->vm);
-	if (err)
-		goto err_free;
-
-	ppgtt->pd = gen8_alloc_top_pd(&ppgtt->vm);
-	if (IS_ERR(ppgtt->pd)) {
-		err = PTR_ERR(ppgtt->pd);
-		goto err_free_scratch;
-	}
-
-	if (!i915_vm_is_4lvl(&ppgtt->vm)) {
-		err = gen8_preallocate_top_level_pdp(ppgtt);
-		if (err)
-			goto err_free_pd;
-	}
+	ppgtt->vm.pte_encode = gen8_pte_encode;
 
 	ppgtt->vm.bind_async_flags = I915_VMA_LOCAL_BIND;
 	ppgtt->vm.insert_entries = gen8_ppgtt_insert;
@@ -971,22 +964,31 @@ struct i915_ppgtt *gen8_ppgtt_create(struct intel_gt *gt,
 	ppgtt->vm.allocate_va_range = gen8_ppgtt_alloc;
 	ppgtt->vm.clear_range = gen8_ppgtt_clear;
 	ppgtt->vm.foreach = gen8_ppgtt_foreach;
+	ppgtt->vm.cleanup = gen8_ppgtt_cleanup;
 
-	ppgtt->vm.pte_encode = gen8_pte_encode;
+	err = gen8_init_scratch(&ppgtt->vm);
+	if (err)
+		goto err_put;
+
+	pd = gen8_alloc_top_pd(&ppgtt->vm);
+	if (IS_ERR(pd)) {
+		err = PTR_ERR(pd);
+		goto err_put;
+	}
+	ppgtt->pd = pd;
+
+	if (!i915_vm_is_4lvl(&ppgtt->vm)) {
+		err = gen8_preallocate_top_level_pdp(ppgtt);
+		if (err)
+			goto err_put;
+	}
 
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
index b67831833c9a..2eaeba14319e 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
@@ -405,6 +405,9 @@ void free_scratch(struct i915_address_space *vm)
 {
 	int i;
 
+	if (!vm->scratch[0])
+		return;
+
 	for (i = 0; i <= vm->top; i++)
 		i915_gem_object_put(vm->scratch[i]);
 }

