Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8AA4BBA92
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiBRO0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:26:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiBRO0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:26:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCAF6400
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73EB4B8238C
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D18C340EC;
        Fri, 18 Feb 2022 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645194384;
        bh=9/EHTwat5w/yXXWDYFqW8Eb3sQ/EcU78VpuAl3YdTr8=;
        h=Subject:To:Cc:From:Date:From;
        b=J/e0BM2wjDb0sqo/6U6oxi4Lc1JIGWSO42hEkrqWJr6GUY8KX1nZgQWlCN+VaynCm
         qVHAs+hRC9n7hOeqYb/ZDeFDzBScV44GCWEBzZ98Vrdmg39M8ViHbLn6PjpIm4qkPU
         Ceoio0OqNWrlCdX27SOeOioQZqHXqDyu2nEsB/Vs=
Subject: FAILED: patch "[PATCH] drm/cma-helper: Set VM_DONTEXPAND for mmap" failed to apply to 5.10-stable tree
To:     robin.murphy@arm.com, alyssa.rosenzweig@collabora.com,
        daniel@ffwll.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:26:21 +0100
Message-ID: <164519438120273@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 59f39bfa6553d598cb22f694d45e89547f420d85 Mon Sep 17 00:00:00 2001
From: Robin Murphy <robin.murphy@arm.com>
Date: Wed, 13 Oct 2021 10:36:54 -0400
Subject: [PATCH] drm/cma-helper: Set VM_DONTEXPAND for mmap

drm_gem_cma_mmap() cannot assume every implementation of dma_mmap_wc()
will end up calling remap_pfn_range() (which happens to set the relevant
vma flag, among others), so in order to make sure expectations around
VM_DONTEXPAND are met, let it explicitly set the flag like most other
GEM mmap implementations do.

This avoids repeated warnings on a small minority of systems where the
display is behind an IOMMU, and has a simple driver which does not
override drm_gem_cma_default_funcs. Arm hdlcd is an in-tree affected
driver. Out-of-tree, the Apple DCP driver is affected; this fix is
required for DCP to be mainlined.

[Alyssa: Update commit message.]

Fixes: c40069cb7bd6 ("drm: add mmap() to drm_gem_object_funcs")
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013143654.39031-1-alyssa@rosenzweig.io

diff --git a/drivers/gpu/drm/drm_gem_cma_helper.c b/drivers/gpu/drm/drm_gem_cma_helper.c
index cefd0cbf9deb..dc275c466c9c 100644
--- a/drivers/gpu/drm/drm_gem_cma_helper.c
+++ b/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -512,6 +512,7 @@ int drm_gem_cma_mmap(struct drm_gem_cma_object *cma_obj, struct vm_area_struct *
 	 */
 	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 	vma->vm_flags &= ~VM_PFNMAP;
+	vma->vm_flags |= VM_DONTEXPAND;
 
 	if (cma_obj->map_noncoherent) {
 		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);

