Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6859F170310
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 16:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgBZPsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 10:48:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45405 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728436AbgBZPsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 10:48:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582732084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=0hBOHXRxGQzs7sC6MP4NSUkQgLwz4qRn+BWsljwDM7Q=;
        b=eDfIyeCdBgkGP/nzsUjHA0hDpt7lpso1EVy0fnI4aHgh5x46jdd2LsJYYwxkdOkpCk8RIA
        /9bJn2ZYnkCcG2E4WcyGeUAvPOpA5zkflJMUiMKEdZzdRRCJh1D3WtFOyqrBh2yPwL8Fth
        SkbkoqnwnuX9aIUL2WSh0wfEjCmWGYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-3H3FylnoMz6nWrRPDbsPGQ-1; Wed, 26 Feb 2020 10:47:59 -0500
X-MC-Unique: 3H3FylnoMz6nWrRPDbsPGQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA4141137840;
        Wed, 26 Feb 2020 15:47:57 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-150.ams2.redhat.com [10.36.116.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10D1A60BE1;
        Wed, 26 Feb 2020 15:47:54 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 2D95E1FCE8; Wed, 26 Feb 2020 16:47:53 +0100 (CET)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     tzimmermann@suse.de, gurchetansingh@chromium.org,
        olvaffe@gmail.com, Guillaume.Gardet@arm.com,
        Gerd Hoffmann <kraxel@redhat.com>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO GPU DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/3] drm/virtio: fix mmap page attributes
Date:   Wed, 26 Feb 2020 16:47:51 +0100
Message-Id: <20200226154752.24328-3-kraxel@redhat.com>
In-Reply-To: <20200226154752.24328-1-kraxel@redhat.com>
References: <20200226154752.24328-1-kraxel@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

virtio-gpu uses cached mappings, set
drm_gem_shmem_object.map_cached accordingly.

Cc: stable@vger.kernel.org
Fixes: c66df701e783 ("drm/virtio: switch from ttm to gem shmem helpers")
Reported-by: Gurchetan Singh <gurchetansingh@chromium.org>
Reported-by: Guillaume Gardet <Guillaume.Gardet@arm.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 3d2a6d489bfc..59319435218f 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -119,6 +119,7 @@ struct drm_gem_object *virtio_gpu_create_object(struct drm_device *dev,
 		return NULL;
 
 	bo->base.base.funcs = &virtio_gpu_gem_funcs;
+	bo->base.map_cached = true;
 	return &bo->base.base;
 }
 
-- 
2.18.2

