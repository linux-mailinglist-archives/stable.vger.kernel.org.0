Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C981A45C622
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353984AbhKXOFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353752AbhKXOCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7633F63319;
        Wed, 24 Nov 2021 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759414;
        bh=iVwT131v2V/K3sQNfO6yc4L7ZfCBxABnnfdOBa+1MpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udjAZ+Ekg3gXiOWBgprL03q+ysixPekRi8QDfdZvhoRuPaCz9D+yR0RABBXbFSCLV
         VBmQ4skjUxbqYzlMpXKInqvKMeyUvM5PxcFftFC0azaU9CCDR3sGBuYRudHz2iCs58
         M253RCAXr58itA58lFAbAKuMUfHFWXS8Qr3+QEjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Paul Cercueil <paul@crapouillou.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.15 226/279] drm/cma-helper: Release non-coherent memory with dma_free_noncoherent()
Date:   Wed, 24 Nov 2021 12:58:33 +0100
Message-Id: <20211124115726.556860793@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 995f54ea962e03ec08b8bc6a4fe11a32b420edd3 upstream.

The GEM CMA helpers allocate non-coherent (i.e., cached) backing storage
with dma_alloc_noncoherent(), but release it with dma_free_wc(). Fix this
with a call to dma_free_noncoherent(). Writecombining storage is still
released with dma_free_wc().

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: cf8ccbc72d61 ("drm: Add support for GEM buffers backed by non-coherent memory")
Acked-by: Paul Cercueil <paul@crapouillou.net>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.14+
Link: https://patchwork.freedesktop.org/patch/msgid/20210708175146.10618-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_cma_helper.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gem_cma_helper.c
+++ b/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -210,8 +210,13 @@ void drm_gem_cma_free_object(struct drm_
 			dma_buf_vunmap(gem_obj->import_attach->dmabuf, &map);
 		drm_prime_gem_destroy(gem_obj, cma_obj->sgt);
 	} else if (cma_obj->vaddr) {
-		dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
-			    cma_obj->vaddr, cma_obj->paddr);
+		if (cma_obj->map_noncoherent)
+			dma_free_noncoherent(gem_obj->dev->dev, cma_obj->base.size,
+					     cma_obj->vaddr, cma_obj->paddr,
+					     DMA_TO_DEVICE);
+		else
+			dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
+				    cma_obj->vaddr, cma_obj->paddr);
 	}
 
 	drm_gem_object_release(gem_obj);


