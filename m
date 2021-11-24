Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E742C45C63A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350233AbhKXOGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356430AbhKXOEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D6476140D;
        Wed, 24 Nov 2021 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759453;
        bh=quIe4/uXnU5hwY/ldEROEovl5U5E+Zhjpr5Bb6h1PF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JyoKDkAZCCTBuYg5Qfs0ZwJC3o164h0zXvX1Oyr87z6FQ6PqSVyqKut3tGP/9ToS
         FOcipPG96ktCTE3NkKac/vuQwz5QygsQyVpeZOxm8LACPWP6p7E/wpwNAbcZPFmqPk
         OUQr977+spQvUh3a1VZyDbG3+Cev0OzKD4S1xEFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand K Mistry <amistry@google.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.15 247/279] drm/prime: Fix use after free in mmap with drm_gem_ttm_mmap
Date:   Wed, 24 Nov 2021 12:58:54 +0100
Message-Id: <20211124115727.260910762@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

commit 8244a3bc27b3efd057da154b8d7e414670d5044f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_prime.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -719,11 +719,13 @@ int drm_gem_prime_mmap(struct drm_gem_ob
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
 


