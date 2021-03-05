Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F3132EAB7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhCEMjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhCEMjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:39:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41AE864F44;
        Fri,  5 Mar 2021 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947975;
        bh=TdtoEh6p1SmB8tRJe6fnMmOp9l/pQ/zzA2PAkGW870Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwDwaWDLVSSnPZzEBUUwrdzc5oxS+xTNV1GmTP9RL5ViKksavUCJpL5m94tB6R5rX
         FwDfoKlg2n1XffQ1A6bPIwd6c6zHehnWb2Zxi2uNWHfJl/QCDywup+xUJuk3ntvOut
         TMCj7UXLBhRpqk5J7ZYn3fOBOUVM1UfgjLESMCh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Doug Horn <doughorn@google.com>
Subject: [PATCH 4.14 05/39] drm/virtio: use kvmalloc for large allocations
Date:   Fri,  5 Mar 2021 13:22:04 +0100
Message-Id: <20210305120852.026335422@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
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
@@ -865,9 +865,9 @@ int virtio_gpu_object_attach(struct virt
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


