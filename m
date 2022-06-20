Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7636551894
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiFTMN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242439AbiFTMNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:13:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B749312AB6
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78F57B81109
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E5DC3411B;
        Mon, 20 Jun 2022 12:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655727228;
        bh=zsMZO1VfjhnekvCN0xKRHGkkxTseKqpDfnHrc27xP1A=;
        h=Subject:To:Cc:From:Date:From;
        b=lFBk1yH65LzIpY8liiJRGlSDRusFUzZwmxnY5Orco05Pj28LcSI/UlETF6Cknzdtt
         G9pdp3uhd9UncKrwglqvu0O+YsVLRpCAYxosYIb9Qo6OXJPyT7haZT2Il7zx3Aoj56
         DIbHr1zJ5Uc5+/qUWvdRaMoFmaH0tE9XsIyRQGSo=
Subject: FAILED: patch "[PATCH] drm/i915: Individualize fences before adding to dma_resv obj" failed to apply to 5.18-stable tree
To:     nirmoy.das@intel.com, andrzej.hajda@intel.com,
        jani.nikula@intel.com, matthew.auld@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 14:13:45 +0200
Message-ID: <16557272252337@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 842d9346b2fdda4d2fb8ccb5b87faef1ac01ab51 Mon Sep 17 00:00:00 2001
From: Nirmoy Das <nirmoy.das@intel.com>
Date: Wed, 25 May 2022 11:59:55 +0200
Subject: [PATCH] drm/i915: Individualize fences before adding to dma_resv obj

_i915_vma_move_to_active() can receive > 1 fences for
multiple batch buffers submission. Because dma_resv_add_fence()
can only accept one fence at a time, change _i915_vma_move_to_active()
to be aware of multiple fences so that it can add individual
fences to the dma resv object.

v6: fix multi-line comment.
v5: remove double fence reservation for batch VMAs.
v4: Reserve fences for composite_fence on multi-batch contexts and
    also reserve fence slots to composite_fence for each VMAs.
v3: dma_resv_reserve_fences is not cumulative so pass num_fences.
v2: make sure to reserve enough fence slots before adding.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5614
Fixes: 544460c33821 ("drm/i915: Multi-BB execbuf")
Cc: <stable@vger.kernel.org> # v5.16+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220525095955.15371-1-nirmoy.das@intel.com
(cherry picked from commit 420a07b841d03f6a436d8c06571c69aa5c783897)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index c326bd2b444f..30fe847c6664 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -999,7 +999,8 @@ static int eb_validate_vmas(struct i915_execbuffer *eb)
 			}
 		}
 
-		err = dma_resv_reserve_fences(vma->obj->base.resv, 1);
+		/* Reserve enough slots to accommodate composite fences */
+		err = dma_resv_reserve_fences(vma->obj->base.resv, eb->num_batches);
 		if (err)
 			return err;
 
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 4f6db539571a..0bffb70b3c5f 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/sched/mm.h>
+#include <linux/dma-fence-array.h>
 #include <drm/drm_gem.h>
 
 #include "display/intel_frontbuffer.h"
@@ -1823,6 +1824,21 @@ int _i915_vma_move_to_active(struct i915_vma *vma,
 	if (unlikely(err))
 		return err;
 
+	/*
+	 * Reserve fences slot early to prevent an allocation after preparing
+	 * the workload and associating fences with dma_resv.
+	 */
+	if (fence && !(flags & __EXEC_OBJECT_NO_RESERVE)) {
+		struct dma_fence *curr;
+		int idx;
+
+		dma_fence_array_for_each(curr, idx, fence)
+			;
+		err = dma_resv_reserve_fences(vma->obj->base.resv, idx);
+		if (unlikely(err))
+			return err;
+	}
+
 	if (flags & EXEC_OBJECT_WRITE) {
 		struct intel_frontbuffer *front;
 
@@ -1832,31 +1848,23 @@ int _i915_vma_move_to_active(struct i915_vma *vma,
 				i915_active_add_request(&front->write, rq);
 			intel_frontbuffer_put(front);
 		}
+	}
 
-		if (!(flags & __EXEC_OBJECT_NO_RESERVE)) {
-			err = dma_resv_reserve_fences(vma->obj->base.resv, 1);
-			if (unlikely(err))
-				return err;
-		}
+	if (fence) {
+		struct dma_fence *curr;
+		enum dma_resv_usage usage;
+		int idx;
 
-		if (fence) {
-			dma_resv_add_fence(vma->obj->base.resv, fence,
-					   DMA_RESV_USAGE_WRITE);
+		obj->read_domains = 0;
+		if (flags & EXEC_OBJECT_WRITE) {
+			usage = DMA_RESV_USAGE_WRITE;
 			obj->write_domain = I915_GEM_DOMAIN_RENDER;
-			obj->read_domains = 0;
-		}
-	} else {
-		if (!(flags & __EXEC_OBJECT_NO_RESERVE)) {
-			err = dma_resv_reserve_fences(vma->obj->base.resv, 1);
-			if (unlikely(err))
-				return err;
+		} else {
+			usage = DMA_RESV_USAGE_READ;
 		}
 
-		if (fence) {
-			dma_resv_add_fence(vma->obj->base.resv, fence,
-					   DMA_RESV_USAGE_READ);
-			obj->write_domain = 0;
-		}
+		dma_fence_array_for_each(curr, idx, fence)
+			dma_resv_add_fence(vma->obj->base.resv, curr, usage);
 	}
 
 	if (flags & EXEC_OBJECT_NEEDS_FENCE && vma->fence)

