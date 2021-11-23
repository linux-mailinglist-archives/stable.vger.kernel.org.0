Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE745A1EF
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhKWLyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:54:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235530AbhKWLyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:54:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5843C60FED;
        Tue, 23 Nov 2021 11:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637668265;
        bh=2c2fYaPYBCvvqq67k+FdRCCqw1iXQX1D4CKTotC3d20=;
        h=Subject:To:Cc:From:Date:From;
        b=cN9sgcVM989Wrx73Q85eeCdee7tya9BOyauA66HqGpzL45m0ZLSZ0XeamCNQ137qa
         sv+GGcmWEPtvFNo7zZXDzSOk2Bcj2amA6BeyBnfcJpDKk3mAB2yLdazEwPZi4L6c6x
         ++HDB2IXZ8FSfaKjdQnXECFHFPZl9cfrx2iQCwmg=
Subject: FAILED: patch "[PATCH] drm/prime: Fix use after free in mmap with drm_gem_ttm_mmap" failed to apply to 5.10-stable tree
To:     amistry@google.com, airlied@linux.ie, daniel.vetter@ffwll.ch,
        daniel@ffwll.ch, kraxel@redhat.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        stable@vger.kernel.org, tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:51:03 +0100
Message-ID: <163766826320226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 8244a3bc27b3efd057da154b8d7e414670d5044f Mon Sep 17 00:00:00 2001
From: Anand K Mistry <amistry@google.com>
Date: Thu, 30 Sep 2021 09:00:07 +1000
Subject: [PATCH] drm/prime: Fix use after free in mmap with drm_gem_ttm_mmap

drm_gem_ttm_mmap() drops a reference to the gem object on success. If
the gem object's refcount == 1 on entry to drm_gem_prime_mmap(), that
drop will free the gem object, and the subsequent drm_gem_object_get()
will be a UAF. Fix by grabbing a reference before calling the mmap
helper.

This issue was forseen when the reference dropping was adding in
commit 9786b65bc61ac ("drm/ttm: fix mmap refcounting"):
  "For that to work properly the drm_gem_object_get() call in
  drm_gem_ttm_mmap() must be moved so it happens before calling
  obj->funcs->mmap(), otherwise the gem refcount would go down
  to zero."

Signed-off-by: Anand K Mistry <amistry@google.com>
Fixes: 9786b65bc61a ("drm/ttm: fix mmap refcounting")
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210930085932.1.I8043d61cc238e0168e2f4ca5f4783223434aa587@changeid

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index deb23dbec8b5..d6c7f4f9a7a2 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -719,11 +719,13 @@ int drm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 	if (obj->funcs && obj->funcs->mmap) {
 		vma->vm_ops = obj->funcs->vm_ops;
 
+		drm_gem_object_get(obj);
 		ret = obj->funcs->mmap(obj, vma);
-		if (ret)
+		if (ret) {
+			drm_gem_object_put(obj);
 			return ret;
+		}
 		vma->vm_private_data = obj;
-		drm_gem_object_get(obj);
 		return 0;
 	}
 

