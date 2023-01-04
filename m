Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944F865D655
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbjADOoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbjADOoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:44:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC1137512
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF386176B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BE6C4339C;
        Wed,  4 Jan 2023 14:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843458;
        bh=JnLuxGjs0rRYi20aThc6oG7F4dgBuM3Y9vqpiCAwSG4=;
        h=Subject:To:Cc:From:Date:From;
        b=YuHnqqA/0UliSOlPynC+2DLZT8ttvKU9EyWGR55+AKoEVT6HdY0V4H4Jvf0WYLT0c
         p3qbqpyvK3axBnfZDL/twswpL1LQZSjsLJVeKJ848i9B97ShucaiJh/t7YCZljeVWi
         rM6YYTfBWim79/yGK/WHTwt1FH8GMTZizBkh35/U=
Subject: FAILED: patch "[PATCH] drm/i915/dmabuf: fix sg_table handling in map_dma_buf" failed to apply to 6.1-stable tree
To:     matthew.auld@intel.com, lionel.g.landwerlin@intel.com,
        michael.j.ruhl@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@linux.intel.com, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:44:15 +0100
Message-ID: <1672843455189166@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

28d52f99bbca ("drm/i915/dmabuf: fix sg_table handling in map_dma_buf")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 28d52f99bbca7227008cf580c9194c9b3516968e Mon Sep 17 00:00:00 2001
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

