Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67B965D662
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjADOpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbjADOpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:45:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC79A38AEB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 879DD6141B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7741BC43392;
        Wed,  4 Jan 2023 14:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843502;
        bh=BStFHQyVTxdcMOllBHVIonZ67DACHsU8rjLL7I5ynoc=;
        h=Subject:To:Cc:From:Date:From;
        b=bw52jeeMVLE1AQ89eiANhseUyYJ20sQU4JGLtdbEzcvwShTU0DWfE4rGlqzlVrGhF
         ogltQOOt+Fm8WrfcUdRDOCTX54LcVlSfS2mpbkYlj4iOK/ZlD8Ab8tEqxSagUnrZZ8
         nl/IQcQiVIDBQeBFNh6NByQaoTQEICySzOVZFmmk=
Subject: FAILED: patch "[PATCH] drm/i915: Fix display problems after resume" failed to apply to 6.1-stable tree
To:     thomas.hellstrom@linux.intel.com, andrzej.hajda@intel.com,
        davidesousa@gmail.com, kevinboulain@gmail.com,
        matthew.auld@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:44:59 +0100
Message-ID: <167284349912072@kroah.com>
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

bc2472538c0d ("drm/i915: Fix display problems after resume")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bc2472538c0d1cce334ffc9e97df0614cd2b1469 Mon Sep 17 00:00:00 2001
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

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
index b31fe0fb013f..5c67e49aacf6 100644
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

