Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47B7493E3
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfFQVYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728841AbfFQVYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB8E220673;
        Mon, 17 Jun 2019 21:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806678;
        bh=oywjT/WGxmlXWiGqewKHuaN1H1kBYOm+AcDn/SJIaZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRXh6VRCwD2QyCnf9EVICg14gc7I0+fUit8MT8uIt3aZ8btGneFfBXy0T7qQ+rvq+
         j4EPmq4Wm9PwyT628jd5UyyVAs60het3zowWG6sDO5NGWSK/gU4SqT1pYDofc647iP
         LsNInAoomS2x/Ni83g6R+NdC1WwNeP7V7EzBTG/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Backlund <tmb@mageia.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sven Joachim <svenjoac@gmx.de>
Subject: [PATCH 4.19 02/75] nouveau: Fix build with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled
Date:   Mon, 17 Jun 2019 23:09:13 +0200
Message-Id: <20190617210752.904005380@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
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
@@ -169,7 +169,11 @@ nouveau_ttm_mmap(struct file *filp, stru
 	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);
 
 	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
+#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
 		return drm_legacy_mmap(filp, vma);
+#else
+		return -EINVAL;
+#endif
 
 	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
 }


