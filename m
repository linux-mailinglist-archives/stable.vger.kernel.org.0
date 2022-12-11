Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20698649379
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 10:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiLKJyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 04:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiLKJyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 04:54:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A1A11806
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 01:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C37D60D3F
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB3DC433D2;
        Sun, 11 Dec 2022 09:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670752458;
        bh=O0+ZahlksOCvF/a8OSkJBiC3eNB+XArB4+lBa4ZDIDY=;
        h=Subject:To:Cc:From:Date:From;
        b=wMCfrLQ14KsCKgIVMJI3UheMv1GyvZZYecFOhHi5vAWVzRdKXaGKvxe61Vd3oxMWH
         IAuJdjwcbxi2M6+X5YM25Se3FVvSSx4KD7pF3HgEJSiAfLXCrsBHv8HwARbXB2rBXe
         mG+0z2VfT9lITcI5TfzwyuqjJn/lLvyeqcAVQ+Q4=
Subject: FAILED: patch "[PATCH] drm/shmem-helper: Avoid vm_open error paths" failed to apply to 5.4-stable tree
To:     robdclark@chromium.org, daniel.vetter@ffwll.ch, javierm@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Dec 2022 10:54:16 +0100
Message-ID: <167075245610314@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

09bf649a7457 ("drm/shmem-helper: Avoid vm_open error paths")
526408357318 ("drm/shmem-helpers: Ensure get_pages is not called on imported dma-buf")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 09bf649a74573cb596e211418a4f8008f265c5a9 Mon Sep 17 00:00:00 2001
From: Rob Clark <robdclark@chromium.org>
Date: Wed, 30 Nov 2022 10:57:48 -0800
Subject: [PATCH] drm/shmem-helper: Avoid vm_open error paths

vm_open() is not allowed to fail.  Fortunately we are guaranteed that
the pages are already pinned, thanks to the initial mmap which is now
being cloned into a forked process, and only need to increment the
refcnt.  So just increment it directly.  Previously if a signal was
delivered at the wrong time to the forking process, the
mutex_lock_interruptible() could fail resulting in the pages_use_count
not being incremented.

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221130185748.357410-3-robdclark@gmail.com

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3b7b71391a4c..b602cd72a120 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	int ret;
 
 	WARN_ON(shmem->base.import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
-	WARN_ON_ONCE(ret != 0);
+	mutex_lock(&shmem->pages_lock);
+
+	/*
+	 * We should have already pinned the pages when the buffer was first
+	 * mmap'd, vm_open() just grabs an additional reference for the new
+	 * mm the vma is getting copied into (ie. on fork()).
+	 */
+	if (!WARN_ON_ONCE(!shmem->pages_use_count))
+		shmem->pages_use_count++;
+
+	mutex_unlock(&shmem->pages_lock);
 
 	drm_gem_vm_open(vma);
 }

