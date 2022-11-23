Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B536354F9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiKWJMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiKWJMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:12:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9B6E08
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:12:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4795761B14
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA28C433C1;
        Wed, 23 Nov 2022 09:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194750;
        bh=+emQ56EQx0N9JK4pbhuTttMoASuXe/c2+0BreFmvKRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRc5F/E93ho7Pq6Xtao6nCFzdecWm6G3XgDbsxsKLuTXEjsp6nOmWZnnDZqAC5z51
         avqdOv9LhHZaNpOvMs9oEx92FuECG2zXzyhEOJmVacrECcwTtYu3yOdzsrVT6RAzKg
         TVcL2zuaX5TwhkjIeFvh5kxzsWQN2hVmI59QM/0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Auld <matthew.auld@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.4 050/156] drm/i915/dmabuf: fix sg_table handling in map_dma_buf
Date:   Wed, 23 Nov 2022 09:50:07 +0100
Message-Id: <20221123084559.730000174@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matthew Auld <matthew.auld@intel.com>

commit f90daa975911961b65070ec72bd7dd8d448f9ef7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -36,13 +36,13 @@ static struct sg_table *i915_gem_map_dma
 		goto err_unpin_pages;
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


