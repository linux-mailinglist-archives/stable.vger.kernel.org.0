Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D568F4932A
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbfFQV2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbfFQV2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:28:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6BB02063F;
        Mon, 17 Jun 2019 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806897;
        bh=mIdtE7lYoXm4hRuni9ptK4HKNWFA0W3HFiBzzWwBeT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUZpKR38QKa2unSm6rdDFi2sO8eQ48xz4L1EZv3cQZjpfPpCADm8xroFbr5Alb4K9
         06WERqGhLGrWgvOuJxVT9D4Ek4OpszBUP/+XbyRbQ3WCZ/oZ3mJFF0Pa2IEvFZeaRF
         OiYiGsWrWyhv2RCOpF4MJ0VSQejvMB8nQGdoYD2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Backlund <tmb@mageia.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sven Joachim <svenjoac@gmx.de>
Subject: [PATCH 4.14 02/53] nouveau: Fix build with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled
Date:   Mon, 17 Jun 2019 23:09:45 +0200
Message-Id: <20190617210745.638964822@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Backlund <tmb@mageia.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_ttm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -273,7 +273,11 @@ nouveau_ttm_mmap(struct file *filp, stru
 	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);
 
 	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
+#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
 		return drm_legacy_mmap(filp, vma);
+#else
+		return -EINVAL;
+#endif
 
 	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
 }


