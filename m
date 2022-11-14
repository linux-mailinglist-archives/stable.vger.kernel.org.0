Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF04627A6A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiKNK0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiKNK0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:26:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0010B7EF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CCD2B80DA0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D9EC433D6;
        Mon, 14 Nov 2022 10:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668421559;
        bh=CYLBtZgKYzRpPykbUQO1w//p5I3b9Eouu6FWfPUsXDo=;
        h=Subject:To:Cc:From:Date:From;
        b=jl78lyxbU/zXRvqcxHsZpAolzrIZLiFijGOh0W5iLijt71zR4Ba/PNv67XZ4jDv+T
         ZsyrreEBhWjdfOouLX8rq6+Nh+eQFVxFfRE/qtTQOZjm5996BPQ2KBCtRZNjIM6Rz5
         4qCSx6LA2fyn9B7uuPx9HlPPP+P6pjMNR2zlKnx8=
Subject: FAILED: patch "[PATCH] drm/i915/dmabuf: fix sg_table handling in map_dma_buf" failed to apply to 4.9-stable tree
To:     matthew.auld@intel.com, lionel.g.landwerlin@intel.com,
        michael.j.ruhl@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com, tvrtko.ursulin@linux.intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:25:56 +0100
Message-ID: <166842155623272@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f90daa975911 ("drm/i915/dmabuf: fix sg_table handling in map_dma_buf")
10be98a77c55 ("drm/i915: Move more GEM objects under gem/")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f90daa975911961b65070ec72bd7dd8d448f9ef7 Mon Sep 17 00:00:00 2001
From: Matthew Auld <matthew.auld@intel.com>
Date: Fri, 28 Oct 2022 16:50:26 +0100
Subject: [PATCH] drm/i915/dmabuf: fix sg_table handling in map_dma_buf
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We need to iterate over the original entries here for the sg_table,
pulling out the struct page for each one, to be remapped. However
currently this incorrectly iterates over the final dma mapped entries,
which is likely just one gigantic sg entry if the iommu is enabled,
leading to us only mapping the first struct page (and any physically
contiguous pages following it), even if there is potentially lots more
data to follow.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7306
Fixes: 1286ff739773 ("i915: add dmabuf/prime buffer sharing support.")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Michael J. Ruhl <michael.j.ruhl@intel.com>
Cc: <stable@vger.kernel.org> # v3.5+
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221028155029.494736-1-matthew.auld@intel.com
(cherry picked from commit 28d52f99bbca7227008cf580c9194c9b3516968e)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index f5062d0c6333..824971a1ceec 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -40,13 +40,13 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attachme
 		goto err;
 	}
 
-	ret = sg_alloc_table(st, obj->mm.pages->nents, GFP_KERNEL);
+	ret = sg_alloc_table(st, obj->mm.pages->orig_nents, GFP_KERNEL);
 	if (ret)
 		goto err_free;
 
 	src = obj->mm.pages->sgl;
 	dst = st->sgl;
-	for (i = 0; i < obj->mm.pages->nents; i++) {
+	for (i = 0; i < obj->mm.pages->orig_nents; i++) {
 		sg_set_page(dst, sg_page(src), src->length, 0);
 		dst = sg_next(dst);
 		src = sg_next(src);

