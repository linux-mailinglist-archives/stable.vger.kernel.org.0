Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3CE46F85
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 12:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfFOKWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 06:22:05 -0400
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:56319 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfFOKWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 06:22:05 -0400
Subject: Re: Linux 5.1.9 build failure with
 CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC:     Sven Joachim <svenjoac@gmx.de>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
References: <87k1dsjkdo.fsf@turtle.gmx.de> <20190611153656.GA5084@kroah.com>
 <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
 <20190611174006.GB31662@kroah.com> <20190613074210.GA16875@kroah.com>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <7c9602d9-0619-2a01-5793-dbcf259d10df@mageia.org>
Date:   Sat, 15 Jun 2019 13:21:59 +0300
MIME-Version: 1.0
In-Reply-To: <20190613074210.GA16875@kroah.com>
Content-Type: multipart/mixed;
        boundary="------------B6AA626F6239144D016D5C9F"
Content-Language: en-US
X-WatchGuard-Spam-ID: str=0001.0A0C0209.5D04C6CA.008E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.195
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--------------B6AA626F6239144D016D5C9F
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

Den 13-06-2019 kl. 10:42, skrev Greg Kroah-Hartman:

> I've just reverted it now.
> 
> If someone can send me a patch series of all of what needs to be
> applied, in a format that I can actually apply them in, I will be glad
> to do so.  But for now, I'd like to get people's systems building again.
> 


That would be basically re-adding the b30a43ac7132 commit and adding the 
following patch (also attached in case the inlined version gets mangled):

 From 0d91b155a7f9c1f4a2b360bc2b79dc728aee8b48 Mon Sep 17 00:00:00 2001
From: Thomas Backlund <tmb@mageia.org>
Date: Sat, 15 Jun 2019 12:22:44 +0300
Subject: [PATCH] nouveau: Fix build with 
CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled

Not-entirely-upstream-sha1-but-equivalent: bed2dd8421
("drm/ttm: Quick-test mmap offset in ttm_bo_mmap()")

Setting CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n (added by commit: b30a43ac7132)
causes the build to fail with:

ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!

This does not happend upstream as the offending code got removed in:
bed2dd8421 ("drm/ttm: Quick-test mmap offset in ttm_bo_mmap()")

Fix that by adding check for CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT around
the drm_legacy_mmap() call.

Also, as Sven Joachim pointed out, we need to make the check in
CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n case return -EINVAL as its done
for basically all other gpu drivers, especially in upstream kernels
drivers/gpu/drm/ttm/ttm_bo_vm.c as of the upstream commit bed2dd8421.

NOTE. This is a minimal stable-only fix for trees where b30a43ac7132 is
backported as the build error affects nouveau only.

Fixes: b30a43ac7132 ("drm/nouveau: add kconfig option to turn off nouveau
        legacy contexts. (v3)")
Signed-off-by: Thomas Backlund <tmb@mageia.org>
Cc: stable@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sven Joachim <svenjoac@gmx.de>
---
  drivers/gpu/drm/nouveau/nouveau_ttm.c | 4 ++++
  1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c 
b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index 1543c2f8d3d3..05d513d54555 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -169,7 +169,11 @@ nouveau_ttm_mmap(struct file *filp, struct 
vm_area_struct *vma)
  	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);

  	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
+#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
  		return drm_legacy_mmap(filp, vma);
+#else
+		return -EINVAL;
+#endif

  	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
  }
-- 
2.21.0

--------------B6AA626F6239144D016D5C9F
Content-Type: text/x-patch;
	name="nouveau-Fix-build-with-CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT-disabled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="nouveau-Fix-build-with-CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT-dis";
	filename*1="abled.patch"

From 0d91b155a7f9c1f4a2b360bc2b79dc728aee8b48 Mon Sep 17 00:00:00 2001
From: Thomas Backlund <tmb@mageia.org>
Date: Sat, 15 Jun 2019 12:22:44 +0300
Subject: [PATCH] nouveau: Fix build with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled

Not-entirely-upstream-sha1-but-equivalent: bed2dd8421
("drm/ttm: Quick-test mmap offset in ttm_bo_mmap()")

Setting CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n (added by commit: b30a43ac7132)
causes the build to fail with:

ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!

This does not happend upstream as the offending code got removed in:
bed2dd8421 ("drm/ttm: Quick-test mmap offset in ttm_bo_mmap()")

Fix that by adding check for CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT around
the drm_legacy_mmap() call.

Also, as Sven Joachim pointed out, we need to make the check in
CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n case return -EINVAL as its done
for basically all other gpu drivers, especially in upstream kernels
drivers/gpu/drm/ttm/ttm_bo_vm.c as of the upstream commit bed2dd8421.

NOTE. This is a minimal stable-only fix for trees where b30a43ac7132 is
backported as the build error affects nouveau only.

Fixes: b30a43ac7132 ("drm/nouveau: add kconfig option to turn off nouveau
       legacy contexts. (v3)")
Signed-off-by: Thomas Backlund <tmb@mageia.org>
Cc: stable@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sven Joachim <svenjoac@gmx.de>
---
 drivers/gpu/drm/nouveau/nouveau_ttm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index 1543c2f8d3d3..05d513d54555 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -169,7 +169,11 @@ nouveau_ttm_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);
 
 	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
+#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
 		return drm_legacy_mmap(filp, vma);
+#else
+		return -EINVAL;
+#endif
 
 	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
 }
-- 
2.21.0

--------------B6AA626F6239144D016D5C9F--
