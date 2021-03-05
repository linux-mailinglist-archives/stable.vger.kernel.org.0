Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A97432EA47
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhCEMht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233054AbhCEMhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:37:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3076501B;
        Fri,  5 Mar 2021 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947832;
        bh=3NGzFDKrJXS4I/2GBiL2uOxZfuT4lRQRB1jdRqdvHGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdEgkhzna7bLO4qauOFaC0Qc+3/zBAGe7kMzHleZ01dHtC6yf5T9rp3PJdZnFQg0V
         aIYaoXAW0BEz3FPFk2YZ+zP/YbB4Sy3zMbjZJPluxBKmcb8pQI3CBhLH6SsLHaUMdf
         sVxqxrJBl4FY+7VGn4lPPAX2ZT1xCCLvPdYBBKJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Doug Horn <doughorn@google.com>
Subject: [PATCH 4.19 03/52] drm/virtio: use kvmalloc for large allocations
Date:   Fri,  5 Mar 2021 13:21:34 +0100
Message-Id: <20210305120853.828809591@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit ea86f3defd55f141a44146e66cbf8ffb683d60da upstream.

We observed that some of virtio_gpu_object_shmem_init() allocations
can be rather costly - order 6 - which can be difficult to fulfill
under memory pressure conditions. Switch to kvmalloc_array() in
virtio_gpu_object_shmem_init() and let the kernel vmalloc the entries
array.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: http://patchwork.freedesktop.org/patch/msgid/20201105014744.1662226-1-senozhatsky@chromium.org
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Doug Horn <doughorn@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -868,9 +868,9 @@ int virtio_gpu_object_attach(struct virt
 	}
 
 	/* gets freed when the ring has consumed it */
-	ents = kmalloc_array(obj->pages->nents,
-			     sizeof(struct virtio_gpu_mem_entry),
-			     GFP_KERNEL);
+	ents = kvmalloc_array(obj->pages->nents,
+			      sizeof(struct virtio_gpu_mem_entry),
+			      GFP_KERNEL);
 	if (!ents) {
 		DRM_ERROR("failed to allocate ent list\n");
 		return -ENOMEM;


