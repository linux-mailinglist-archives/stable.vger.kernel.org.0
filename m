Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6F4527FBA
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241752AbiEPIc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiEPIcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754B7E09C
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1222E611F0
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6BDC34100;
        Mon, 16 May 2022 08:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652689943;
        bh=FGizjxN1daD1ZO7QNdpF3Ns4fTN9QZNaLtumRJ2K60c=;
        h=Subject:To:Cc:From:Date:From;
        b=DNMeZKXuTO0xobD+I8RnIs5eaXP91r+zaJb1O4Mi4xfCCl6fxkDrkUP3cNHkFQODu
         rHNifGBUw+vZ+e4D034RO8vAXcIk+Y2/06TS++2lYmqxFr6IdUcYY0dWDLLHJt4nEx
         fgv1yg/l9bv4dMkRnBwHX3pVbUM1bGtxGygOAhlQ=
Subject: FAILED: patch "[PATCH] drm/i915: Fix race in __i915_vma_remove_closed" failed to apply to 5.15-stable tree
To:     kherbst@redhat.com, chris@chris-wilson.co.uk,
        joonas.lahtinen@linux.intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:32:10 +0200
Message-ID: <1652689930109100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3220c3b2115102bb35f8f07d90d2989a3f5eb452 Mon Sep 17 00:00:00 2001
From: Karol Herbst <kherbst@redhat.com>
Date: Wed, 20 Apr 2022 11:57:20 +0200
Subject: [PATCH] drm/i915: Fix race in __i915_vma_remove_closed

i915_vma_reopen checked if the vma is closed before without taking the
lock. So multiple threads could attempt removing the vma.

Instead the lock needs to be taken before actually checking.

v2: move struct declaration

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.3+
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5732
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Fixes: 155ab8836caa ("drm/i915: Move object close under its own lock")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220420095720.3331609-1-kherbst@redhat.com
(cherry picked from commit 1df1c79cbb7ac9bf148930be3418973c76ba8dde)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 94fcdb7bd21d..eeaa8d0d0407 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1605,17 +1605,17 @@ void i915_vma_close(struct i915_vma *vma)
 
 static void __i915_vma_remove_closed(struct i915_vma *vma)
 {
-	struct intel_gt *gt = vma->vm->gt;
-
-	spin_lock_irq(&gt->closed_lock);
 	list_del_init(&vma->closed_link);
-	spin_unlock_irq(&gt->closed_lock);
 }
 
 void i915_vma_reopen(struct i915_vma *vma)
 {
+	struct intel_gt *gt = vma->vm->gt;
+
+	spin_lock_irq(&gt->closed_lock);
 	if (i915_vma_is_closed(vma))
 		__i915_vma_remove_closed(vma);
+	spin_unlock_irq(&gt->closed_lock);
 }
 
 void i915_vma_release(struct kref *ref)
@@ -1641,6 +1641,7 @@ static void force_unbind(struct i915_vma *vma)
 static void release_references(struct i915_vma *vma)
 {
 	struct drm_i915_gem_object *obj = vma->obj;
+	struct intel_gt *gt = vma->vm->gt;
 
 	GEM_BUG_ON(i915_vma_is_active(vma));
 
@@ -1650,7 +1651,9 @@ static void release_references(struct i915_vma *vma)
 		rb_erase(&vma->obj_node, &obj->vma.tree);
 	spin_unlock(&obj->vma.lock);
 
+	spin_lock_irq(&gt->closed_lock);
 	__i915_vma_remove_closed(vma);
+	spin_unlock_irq(&gt->closed_lock);
 
 	__i915_vma_put(vma);
 }

