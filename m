Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA7600156
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 18:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJPQat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 12:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJPQas (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 12:30:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0946D2B253
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA4560C16
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 16:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC0AC433C1;
        Sun, 16 Oct 2022 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665937847;
        bh=ewkaf131TMvah6wCSqV7lWrk7x9gL7gSC5ttPcbss9c=;
        h=Subject:To:Cc:From:Date:From;
        b=JDHdfWI6WzgIZGCKWMxWkb4j43AcgMf2AiGyv6mG25teB3lN1j+qD87kWSVaiAe/h
         OJ6mvlmL3rdhwFgn8pWhCcj7SPypLO/r1KGSoePFpwbM/QKR8oSNvwUPZ7Tfouada2
         OEX2v/DTi8l5ScQKCKVC+4BVQ4/qnRcP3EidKwYM=
Subject: FAILED: patch "[PATCH] drm/i915: Fix display problems after resume" failed to apply to 5.19-stable tree
To:     thomas.hellstrom@linux.intel.com, andrzej.hajda@intel.com,
        davidesousa@gmail.com, kevinboulain@gmail.com,
        matthew.auld@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 18:31:33 +0200
Message-ID: <1665937893204205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6c482c62a635 ("drm/i915: Fix display problems after resume")
2ef6efa79fec ("drm/i915: Improve on suspend / resume time with VT-d enabled")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c482c62a635aa4f534d2439fbf8afa37452b986 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Date: Wed, 5 Oct 2022 14:11:59 +0200
Subject: [PATCH] drm/i915: Fix display problems after resume
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 39a2bd34c933 ("drm/i915: Use the vma resource as argument for gtt
binding / unbinding") introduced a regression that due to the vma resource
tracking of the binding state, dpt ptes were not correctly repopulated.
Fix this by clearing the vma resource state before repopulating.
The state will subsequently be restored by the bind_vma operation.

Fixes: 39a2bd34c933 ("drm/i915: Use the vma resource as argument for gtt binding / unbinding")
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220912121957.31310-1-thomas.hellstrom@linux.intel.com
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.18+
Reported-and-tested-by: Kevin Boulain <kevinboulain@gmail.com>
Tested-by: David de Sousa <davidesousa@gmail.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221005121159.340245-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit bc2472538c0d1cce334ffc9e97df0614cd2b1469)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
index 30cf5c3369d9..2049a00417af 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
@@ -1275,10 +1275,16 @@ bool i915_ggtt_resume_vm(struct i915_address_space *vm)
 			atomic_read(&vma->flags) & I915_VMA_BIND_MASK;
 
 		GEM_BUG_ON(!was_bound);
-		if (!retained_ptes)
+		if (!retained_ptes) {
+			/*
+			 * Clear the bound flags of the vma resource to allow
+			 * ptes to be repopulated.
+			 */
+			vma->resource->bound_flags = 0;
 			vma->ops->bind_vma(vm, NULL, vma->resource,
 					   obj ? obj->cache_level : 0,
 					   was_bound);
+		}
 		if (obj) { /* only used during resume => exclusive access */
 			write_domain_objs |= fetch_and_zero(&obj->write_domain);
 			obj->read_domains |= I915_GEM_DOMAIN_GTT;

