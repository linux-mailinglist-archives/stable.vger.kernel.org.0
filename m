Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDE959D376
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbiHWIJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241762AbiHWIIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCFD6CD1B;
        Tue, 23 Aug 2022 01:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C078C6125B;
        Tue, 23 Aug 2022 08:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C702CC433D6;
        Tue, 23 Aug 2022 08:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241945;
        bh=vPttWHwZ7d8rvMxwJVsMNnxWY2g5BGdw+mCCof3zh+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ00gEk+7Vk77pi+lVxxpRd7QwUkBX6I/tpmIa6z+O0MS8NB8Yeexv8idBleGPlci
         tozLP7T24QECVVsot+S8FM3N0bdBkda3+AdXIEdcFxJCJDGBUzdZkLoLnI+Sl/F9ax
         YtIBMnSn+WQnVMUwX84rqLhFibYx6ovagTykLH2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 027/365] drm/i915: pass a pointer for tlb seqno at vma_invalidate_tlb()
Date:   Tue, 23 Aug 2022 09:58:48 +0200
Message-Id: <20220823080119.367414148@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit 9d50bff40e3e366886ec37299fc317edf84be0c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_ppgtt.c |    2 +-
 drivers/gpu/drm/i915/i915_vma.c       |    6 +++---
 drivers/gpu/drm/i915/i915_vma.h       |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
@@ -211,7 +211,7 @@ void ppgtt_unbind_vma(struct i915_addres
 
 	vm->clear_range(vm, vma_res->start, vma_res->vma_size);
 	if (vma_res->tlb)
-		vma_invalidate_tlb(vm, *vma_res->tlb);
+		vma_invalidate_tlb(vm, vma_res->tlb);
 }
 
 static unsigned long pd_count(u64 size, int shift)
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1299,7 +1299,7 @@ err_unpin:
 	return err;
 }
 
-void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb)
+void vma_invalidate_tlb(struct i915_address_space *vm, u32 *tlb)
 {
 	/*
 	 * Before we release the pages that were bound by this vma, we
@@ -1309,7 +1309,7 @@ void vma_invalidate_tlb(struct i915_addr
 	 * the most recent TLB invalidation seqno, and if we have not yet
 	 * flushed the TLBs upon release, perform a full invalidation.
 	 */
-	WRITE_ONCE(tlb, intel_gt_next_invalidate_tlb_full(vm->gt));
+	WRITE_ONCE(*tlb, intel_gt_next_invalidate_tlb_full(vm->gt));
 }
 
 static void __vma_put_pages(struct i915_vma *vma, unsigned int count)
@@ -1957,7 +1957,7 @@ struct dma_fence *__i915_vma_evict(struc
 			dma_fence_put(unbind_fence);
 			unbind_fence = NULL;
 		}
-		vma_invalidate_tlb(vma->vm, vma->obj->mm.tlb);
+		vma_invalidate_tlb(vma->vm, &vma->obj->mm.tlb);
 	}
 
 	/*
--- a/drivers/gpu/drm/i915/i915_vma.h
+++ b/drivers/gpu/drm/i915/i915_vma.h
@@ -213,7 +213,7 @@ bool i915_vma_misplaced(const struct i91
 			u64 size, u64 alignment, u64 flags);
 void __i915_vma_set_map_and_fenceable(struct i915_vma *vma);
 void i915_vma_revoke_mmap(struct i915_vma *vma);
-void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb);
+void vma_invalidate_tlb(struct i915_address_space *vm, u32 *tlb);
 struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async);
 int __i915_vma_unbind(struct i915_vma *vma);
 int __must_check i915_vma_unbind(struct i915_vma *vma);


