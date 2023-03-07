Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB54F6AE5FF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjCGQKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCGQKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:10:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE2011E86
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:09:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E6761338
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3834DC433D2;
        Tue,  7 Mar 2023 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678205371;
        bh=DyWwp2pgvujT0I61GcW+zIJ8IJu6nJOFXgTulpON4e4=;
        h=Subject:To:Cc:From:Date:From;
        b=Bcb2e1X/aXu48AnSkfMZE47hKLyfVFl6WnbaPDFvL952/TbSF39VRE2TTBzaHW/6y
         YzxdcJkZcBUN0j53hAJyrRn92aaIPTz7B5Y9bbO4w3p4aDfkn1YQXZPr1j3Mu9+RBv
         Pf5UCrWMP/uBhVOI/FP+V9mZ2eRddzwfHuz9OD+g=
Subject: FAILED: patch "[PATCH] drm/i915: Don't use stolen memory for ring buffers with LLC" failed to apply to 5.15-stable tree
To:     John.C.Harrison@Intel.com, chris@chris-wilson.co.uk,
        daniele.ceraolospurio@intel.com, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        jouni.hogander@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:09:28 +0100
Message-ID: <167820536819200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 690e0ec8e63da9a29b39fedc6ed5da09c7c82651
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167820536819200@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

690e0ec8e63d ("drm/i915: Don't use stolen memory for ring buffers with LLC")
0d8ee5ba8db4 ("drm/i915: Don't back up pinned LMEM context images and rings during suspend")
c56ce9565374 ("drm/i915 Implement LMEM backup and restore for suspend / resume")
0d9388635a22 ("drm/i915/ttm: Implement a function to copy the contents of two TTM-based objects")
48b096126954 ("drm/i915: Move __i915_gem_free_object to ttm_bo_destroy")
d8ac30fd479c ("drm/i915/ttm: Reorganize the ttm move code somewhat")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 690e0ec8e63da9a29b39fedc6ed5da09c7c82651 Mon Sep 17 00:00:00 2001
From: John Harrison <John.C.Harrison@Intel.com>
Date: Wed, 15 Feb 2023 17:11:00 -0800
Subject: [PATCH] drm/i915: Don't use stolen memory for ring buffers with LLC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Direction from hardware is that stolen memory should never be used for
ring buffer allocations on platforms with LLC. There are too many
caching pitfalls due to the way stolen memory accesses are routed. So
it is safest to just not use it.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Fixes: c58b735fc762 ("drm/i915: Allocate rings from stolen")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.9+
Tested-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-2-John.C.Harrison@Intel.com
(cherry picked from commit f54c1f6c697c4297f7ed94283c184acc338a5cf8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 15ec64d881c4..fb1d2595392e 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -116,7 +116,7 @@ static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
 
 	obj = i915_gem_object_create_lmem(i915, size, I915_BO_ALLOC_VOLATILE |
 					  I915_BO_ALLOC_PM_VOLATILE);
-	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt))
+	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
 		obj = i915_gem_object_create_stolen(i915, size);
 	if (IS_ERR(obj))
 		obj = i915_gem_object_create_internal(i915, size);

