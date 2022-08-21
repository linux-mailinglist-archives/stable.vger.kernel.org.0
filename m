Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B8B59B450
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiHUOHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 10:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiHUOHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 10:07:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999FBF594
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 07:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D6A060DC9
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 14:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1E7C433C1;
        Sun, 21 Aug 2022 14:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661090828;
        bh=VcgeA/fIokCVpU2McZLWgpBLVX8lkt3jOK0yvMWyGXQ=;
        h=Subject:To:Cc:From:Date:From;
        b=BBtnudeuXOyDBj734VvE5rGxwqqkdyjKN9Zb81we0BrlXx6RVEak6TbAPh0wzLa+u
         MXlZrtaFBWW/7PkS4c8VxZtiYDTlKe4ly3NlfaTzsLh99hUKCjsl3WRTSitEuncyo4
         SeY0pvwBjW4Zj3ABlqaOq37sUMOAy7IWE586d0pA=
Subject: FAILED: patch "[PATCH] drm/i915: pass a pointer for tlb seqno at" failed to apply to 5.10-stable tree
To:     mchehab@kernel.org, andi.shyti@linux.intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 16:06:51 +0200
Message-ID: <1661090811250145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d50bff40e3e366886ec37299fc317edf84be0c9 Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Thu, 4 Aug 2022 09:37:22 +0200
Subject: [PATCH] drm/i915: pass a pointer for tlb seqno at
 vma_invalidate_tlb()

WRITE_ONCE() should happen at the original var, not on a local
copy of it.

Cc: stable@vger.kernel.org
Fixes: 59eda6ce824e ("drm/i915/gt: Batch TLB invalidations")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[added cc-stable while merging it]
Link: https://patchwork.freedesktop.org/patch/msgid/f9550e6bacea10131ff40dd8981b69eb9251cdcd.1659598090.git.mchehab@kernel.org
(cherry picked from commit 3d037d99e61a1e7a3ae3d214146d88db349dd19f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ppgtt.c b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
index 2da6c82a8bd2..6ee8d1127016 100644
--- a/drivers/gpu/drm/i915/gt/intel_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
@@ -211,7 +211,7 @@ void ppgtt_unbind_vma(struct i915_address_space *vm,
 
 	vm->clear_range(vm, vma_res->start, vma_res->vma_size);
 	if (vma_res->tlb)
-		vma_invalidate_tlb(vm, *vma_res->tlb);
+		vma_invalidate_tlb(vm, vma_res->tlb);
 }
 
 static unsigned long pd_count(u64 size, int shift)
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 84a9ccbc5fc5..260371716490 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1308,7 +1308,7 @@ I915_SELFTEST_EXPORT int i915_vma_get_pages(struct i915_vma *vma)
 	return err;
 }
 
-void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb)
+void vma_invalidate_tlb(struct i915_address_space *vm, u32 *tlb)
 {
 	/*
 	 * Before we release the pages that were bound by this vma, we
@@ -1318,7 +1318,7 @@ void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb)
 	 * the most recent TLB invalidation seqno, and if we have not yet
 	 * flushed the TLBs upon release, perform a full invalidation.
 	 */
-	WRITE_ONCE(tlb, intel_gt_next_invalidate_tlb_full(vm->gt));
+	WRITE_ONCE(*tlb, intel_gt_next_invalidate_tlb_full(vm->gt));
 }
 
 static void __vma_put_pages(struct i915_vma *vma, unsigned int count)
@@ -1971,7 +1971,7 @@ struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async)
 			dma_fence_put(unbind_fence);
 			unbind_fence = NULL;
 		}
-		vma_invalidate_tlb(vma->vm, vma->obj->mm.tlb);
+		vma_invalidate_tlb(vma->vm, &vma->obj->mm.tlb);
 	}
 
 	/*
diff --git a/drivers/gpu/drm/i915/i915_vma.h b/drivers/gpu/drm/i915/i915_vma.h
index 5048eed536da..33a58f605d75 100644
--- a/drivers/gpu/drm/i915/i915_vma.h
+++ b/drivers/gpu/drm/i915/i915_vma.h
@@ -213,7 +213,7 @@ bool i915_vma_misplaced(const struct i915_vma *vma,
 			u64 size, u64 alignment, u64 flags);
 void __i915_vma_set_map_and_fenceable(struct i915_vma *vma);
 void i915_vma_revoke_mmap(struct i915_vma *vma);
-void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb);
+void vma_invalidate_tlb(struct i915_address_space *vm, u32 *tlb);
 struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async);
 int __i915_vma_unbind(struct i915_vma *vma);
 int __must_check i915_vma_unbind(struct i915_vma *vma);

