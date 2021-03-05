Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE9832E8B8
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhCEM2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhCEM2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E239D65035;
        Fri,  5 Mar 2021 12:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947287;
        bh=Xgy4NCA67+GfBymP3+F3xB7Abwlcvf9yCQhokQ4A9Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNef2fT3hRlLJDqahq1/RUCWZ9l80NXeUcgq78ji508TX4c6EppzlyhBNz+NctwOd
         TlbZW5X+JZUxHrtVjqgJqdHGyS067CPexJOBWhhB217tw1yXc/D6sEyTUfwofniJRz
         nNNGcl6K4+5lByEh7nXOhzqtGcoEIntwKCmlA/lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Doug Horn <doughorn@google.com>
Subject: [PATCH 5.10 004/102] drm/virtio: use kvmalloc for large allocations
Date:   Fri,  5 Mar 2021 13:20:23 +0100
Message-Id: <20210305120903.495591839@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
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
 drivers/gpu/drm/virtio/virtgpu_object.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -172,8 +172,9 @@ static int virtio_gpu_object_shmem_init(
 		*nents = shmem->pages->orig_nents;
 	}
 
-	*ents = kmalloc_array(*nents, sizeof(struct virtio_gpu_mem_entry),
-			      GFP_KERNEL);
+	*ents = kvmalloc_array(*nents,
+			       sizeof(struct virtio_gpu_mem_entry),
+			       GFP_KERNEL);
 	if (!(*ents)) {
 		DRM_ERROR("failed to allocate ent list\n");
 		return -ENOMEM;


