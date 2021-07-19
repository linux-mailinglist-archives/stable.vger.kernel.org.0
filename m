Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD83CD0A2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhGSInm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235498AbhGSInm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:43:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D8D6108B;
        Mon, 19 Jul 2021 09:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626686662;
        bh=KGcftkWhfKUgDZIgm6iK8nhLVPE/R6VaTNuXF9xLvHY=;
        h=Subject:To:Cc:From:Date:From;
        b=I6D/DgK5GI9Eso8WfppgluGPA//NA9cwPCjZILueTImdT4Xhl1jQ/CmNVKehkRW88
         dt809s5fs42oMynjWN+C0OHNvxQM1z6Bq2a9aBFx28uEuHp0JJuvZtq3WxASt4MJSf
         689Dt/2o+2AIpVg8s/hgo+GN3YDhlc/4KnWe/IHg=
Subject: FAILED: patch "[PATCH] drm/i915/gtt: drop the page table optimisation" failed to apply to 4.19-stable tree
To:     matthew.auld@intel.com, chris.p.wilson@intel.com,
        daniel.vetter@ffwll.ch, daniel@ffwll.ch, jon.bloomfield@intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 11:24:11 +0200
Message-ID: <1626686651166217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0abb33bfca0fb74df76aac03e90ce685016ef7be Mon Sep 17 00:00:00 2001
From: Matthew Auld <matthew.auld@intel.com>
Date: Tue, 13 Jul 2021 14:04:31 +0100
Subject: [PATCH] drm/i915/gtt: drop the page table optimisation

We skip filling out the pt with scratch entries if the va range covers
the entire pt, since we later have to fill it with the PTEs for the
object pages anyway. However this might leave open a small window where
the PTEs don't point to anything valid for the HW to consume.

When for example using 2M GTT pages this fill_px() showed up as being
quite significant in perf measurements, and ends up being completely
wasted since we ignore the pt and just use the pde directly.

Anyway, currently we have our PTE construction split between alloc and
insert, which is probably slightly iffy nowadays, since the alloc
doesn't actually allocate anything anymore, instead it just sets up the
page directories and points the PTEs at the scratch page. Later when we
do the insert step we re-program the PTEs again. Better might be to
squash the alloc and insert into a single step, then bringing back this
optimisation(along with some others) should be possible.

Fixes: 14826673247e ("drm/i915: Only initialize partially filled pagetables")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: <stable@vger.kernel.org> # v4.15+
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210713130431.2392740-1-matthew.auld@intel.com
(cherry picked from commit 8f88ca76b3942d82e2c1cea8735ec368d89ecc15)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
index 21c8b7350b7a..da4f5eb43ac2 100644
--- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
@@ -303,10 +303,7 @@ static void __gen8_ppgtt_alloc(struct i915_address_space * const vm,
 			__i915_gem_object_pin_pages(pt->base);
 			i915_gem_object_make_unshrinkable(pt->base);
 
-			if (lvl ||
-			    gen8_pt_count(*start, end) < I915_PDES ||
-			    intel_vgpu_active(vm->i915))
-				fill_px(pt, vm->scratch[lvl]->encode);
+			fill_px(pt, vm->scratch[lvl]->encode);
 
 			spin_lock(&pd->lock);
 			if (likely(!pd->entry[idx])) {

