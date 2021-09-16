Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB66440DAD8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbhIPNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239977AbhIPNNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:13:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44126611EE;
        Thu, 16 Sep 2021 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797944;
        bh=3qhBJfxkgb61PpQVRWLC0Ie8eP/r/Cg1hHE6/nxEfLk=;
        h=Subject:To:Cc:From:Date:From;
        b=rkD5BYblQrMLQOkSNEmkghz1cA5Vw2A7bdSwXUzTRh74XEDnCJESzvDoPB783L5Kr
         woJIEZZMNIhIs8FSwUs5YXUc7SOgJ/3t2gCuJLwXt+UapjZwF07w91Nakh+6llQS3v
         GdgA9oQ2sNF/YYUYBtgpGTYeS6CDZLdAucrm6v6E=
Subject: FAILED: patch "[PATCH] drm/i915/gtt: drop the page table optimisation" failed to apply to 5.4-stable tree
To:     matthew.auld@intel.com, chris.p.wilson@intel.com,
        daniel.vetter@ffwll.ch, daniel@ffwll.ch, jon.bloomfield@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:12:16 +0200
Message-ID: <163179793625191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8f88ca76b3942d82e2c1cea8735ec368d89ecc15 Mon Sep 17 00:00:00 2001
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

diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
index 3d02c726c746..6e0e52eeb87a 100644
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

