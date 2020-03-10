Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E217FD73
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgCJMyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729118AbgCJMym (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:54:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4389024693;
        Tue, 10 Mar 2020 12:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844881;
        bh=QC5C8Uk9u0if6EgfSTcHCywoXNJNJ2CxLhYICpE+pqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMv8r6CPcdFUuYqVdbYAOtH6/MyrZqbC45LD8sYxAmtKyTkD4ABocy2Oj72YteLJi
         jcnj9x4hdBRaWunzTR3EISoAXrXjj1XS7/utDS5Ph97Z0d8m73f7JUmZ0yYenHVwlk
         JiUkBLvBv0tLuHMbIWNbsehuIGVX4yQqYeppEanw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Chia-I Wu <olvaffe@gmail.com>
Subject: [PATCH 5.4 115/168] drm/virtio: make resource id workaround runtime switchable.
Date:   Tue, 10 Mar 2020 13:39:21 +0100
Message-Id: <20200310123647.060007628@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

commit 3e93bc2a58aa241081e043ef9e6e86c42808499a upstream.

Also update the comment with a reference to the virglrenderer fix.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20190822102614.18164-1-kraxel@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/virtio/virtgpu_object.c |   44 +++++++++++++++++---------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -27,34 +27,38 @@
 
 #include "virtgpu_drv.h"
 
+static int virtio_gpu_virglrenderer_workaround = 1;
+module_param_named(virglhack, virtio_gpu_virglrenderer_workaround, int, 0400);
+
 static int virtio_gpu_resource_id_get(struct virtio_gpu_device *vgdev,
 				       uint32_t *resid)
 {
-#if 0
-	int handle = ida_alloc(&vgdev->resource_ida, GFP_KERNEL);
-
-	if (handle < 0)
-		return handle;
-#else
-	static int handle;
-
-	/*
-	 * FIXME: dirty hack to avoid re-using IDs, virglrenderer
-	 * can't deal with that.  Needs fixing in virglrenderer, also
-	 * should figure a better way to handle that in the guest.
-	 */
-	handle++;
-#endif
-
-	*resid = handle + 1;
+	if (virtio_gpu_virglrenderer_workaround) {
+		/*
+		 * Hack to avoid re-using resource IDs.
+		 *
+		 * virglrenderer versions up to (and including) 0.7.0
+		 * can't deal with that.  virglrenderer commit
+		 * "f91a9dd35715 Fix unlinking resources from hash
+		 * table." (Feb 2019) fixes the bug.
+		 */
+		static int handle;
+		handle++;
+		*resid = handle + 1;
+	} else {
+		int handle = ida_alloc(&vgdev->resource_ida, GFP_KERNEL);
+		if (handle < 0)
+			return handle;
+		*resid = handle + 1;
+	}
 	return 0;
 }
 
 static void virtio_gpu_resource_id_put(struct virtio_gpu_device *vgdev, uint32_t id)
 {
-#if 0
-	ida_free(&vgdev->resource_ida, id - 1);
-#endif
+	if (!virtio_gpu_virglrenderer_workaround) {
+		ida_free(&vgdev->resource_ida, id - 1);
+	}
 }
 
 static void virtio_gpu_ttm_bo_destroy(struct ttm_buffer_object *tbo)


