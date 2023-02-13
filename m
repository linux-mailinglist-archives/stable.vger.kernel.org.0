Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D252694848
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBMOkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjBMOky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:40:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C671ADFE
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:40:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 640E66108F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781D3C433EF;
        Mon, 13 Feb 2023 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299252;
        bh=/VQrCb4DXiliFHYVgZ16oqxb7mntTka9nIIhXmJxLow=;
        h=Subject:To:Cc:From:Date:From;
        b=WBVAasjW2KGFyykd9qnndEvsJST7bZXy7gv/XdhIyr+QfanMzBOK/JomJ/PYIJNc/
         gNFF08YYfl2Wt6GxIjbYLdGFFHn+h6iPTxblHHrC7hZ3B7LsyYORGozJmcG/RGNqs8
         vO+b1mPT4JjG2AdEWd6EHZoaF2dp3KGFbsx2nkSE=
Subject: FAILED: patch "[PATCH] drm/i915: Move fd_install after last use of fence" failed to apply to 5.15-stable tree
To:     robdclark@chromium.org, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 15:40:50 +0100
Message-ID: <16762992503219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

251e8c5b1b1f ("drm/i915: Move fd_install after last use of fence")
544460c33821 ("drm/i915: Multi-BB execbuf")
5851387a422c ("drm/i915/guc: Implement no mid batch preemption for multi-lrc")
e5e32171a2cf ("drm/i915/guc: Connect UAPI to GuC multi-lrc interface")
d38a9294491d ("drm/i915/guc: Update debugfs for GuC multi-lrc")
bc955204919e ("drm/i915/guc: Insert submit fences between requests in parent-child relationship")
6b540bf6f143 ("drm/i915/guc: Implement multi-lrc submission")
99b47aaddfa9 ("drm/i915/guc: Implement parallel context pin / unpin functions")
c2aa552ff09d ("drm/i915/guc: Add multi-lrc context registration")
3897df4c0187 ("drm/i915/guc: Introduce context parent-child relationship")
4f3059dc2dbb ("drm/i915: Add logical engine mapping")
1a52faed3131 ("drm/i915/guc: Take GT PM ref when deregistering context")
0ea92ace8b95 ("drm/i915/guc: Move GuC guc_id allocation under submission state sub-struct")
0d8ee5ba8db4 ("drm/i915: Don't back up pinned LMEM context images and rings during suspend")
c56ce9565374 ("drm/i915 Implement LMEM backup and restore for suspend / resume")
0d9388635a22 ("drm/i915/ttm: Implement a function to copy the contents of two TTM-based objects")
48b096126954 ("drm/i915: Move __i915_gem_free_object to ttm_bo_destroy")
4f41ddc7c7ee ("drm/i915/guc: Add GuC kernel doc")
af5bc9f21e3a ("drm/i915/guc: Drop guc_active move everything into guc_state")
3cb3e3434b9f ("drm/i915/guc: Move fields protected by guc->contexts_lock into sub structure")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 251e8c5b1b1fadcc387a8e618c7437d330bdac3e Mon Sep 17 00:00:00 2001
From: Rob Clark <robdclark@chromium.org>
Date: Fri, 3 Feb 2023 08:49:20 -0800
Subject: [PATCH] drm/i915: Move fd_install after last use of fence

Because eb_composite_fence_create() drops the fence_array reference
after creation of the sync_file, only the sync_file holds a ref to the
fence.  But fd_install() makes that reference visable to userspace, so
it must be the last thing we do with the fence.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 00dae4d3d35d ("drm/i915: Implement SINGLE_TIMELINE with a syncobj (v4)")
Cc: <stable@vger.kernel.org> # v5.15+
[tursulin: Added stable tag.]
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230203164937.4035503-1-robdclark@gmail.com
(cherry picked from commit 960dafa30455450d318756a9896a02727f2639e0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index f266b68cf012..0f2e056c02dd 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -3483,6 +3483,13 @@ i915_gem_do_execbuffer(struct drm_device *dev,
 				   eb.composite_fence :
 				   &eb.requests[0]->fence);
 
+	if (unlikely(eb.gem_context->syncobj)) {
+		drm_syncobj_replace_fence(eb.gem_context->syncobj,
+					  eb.composite_fence ?
+					  eb.composite_fence :
+					  &eb.requests[0]->fence);
+	}
+
 	if (out_fence) {
 		if (err == 0) {
 			fd_install(out_fence_fd, out_fence->file);
@@ -3494,13 +3501,6 @@ i915_gem_do_execbuffer(struct drm_device *dev,
 		}
 	}
 
-	if (unlikely(eb.gem_context->syncobj)) {
-		drm_syncobj_replace_fence(eb.gem_context->syncobj,
-					  eb.composite_fence ?
-					  eb.composite_fence :
-					  &eb.requests[0]->fence);
-	}
-
 	if (!out_fence && eb.composite_fence)
 		dma_fence_put(eb.composite_fence);
 

