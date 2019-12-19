Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3403126BA3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfLSSy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbfLSSy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F932465E;
        Thu, 19 Dec 2019 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781697;
        bh=2psHlqRzmmA3xx2kZl7EqC/jBdJeenrOy2m5Qcvq0PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwWk3aj80uzbZdJmSChR5C+VRn3cOj5/l9ZJzJ8Nt8Wkbk3+pT6b1T4iumJunUpGU
         l9nk0gZLxylMICVjaeXhm+y+tcBCT63y7SCK7xkq9gwC9G0ydKC2WfUkJNDAdWc+0U
         bHNoKoaZrcTrYZKhyyvLnXqUbHQ8DgpKzHVc4B9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 44/80] drm/panfrost: Fix a BO leak in panfrost_ioctl_mmap_bo()
Date:   Thu, 19 Dec 2019 19:34:36 +0100
Message-Id: <20191219183111.994129838@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 3bb69dbcb9e8430e0cc9990cff427ca3ae25ffdc upstream.

We should release the reference we grabbed when an error occurs.

Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191129135908.2439529-4-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_drv.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -303,14 +303,17 @@ static int panfrost_ioctl_mmap_bo(struct
 	}
 
 	/* Don't allow mmapping of heap objects as pages are not pinned. */
-	if (to_panfrost_bo(gem_obj)->is_heap)
-		return -EINVAL;
+	if (to_panfrost_bo(gem_obj)->is_heap) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = drm_gem_create_mmap_offset(gem_obj);
 	if (ret == 0)
 		args->offset = drm_vma_node_offset_addr(&gem_obj->vma_node);
-	drm_gem_object_put_unlocked(gem_obj);
 
+out:
+	drm_gem_object_put_unlocked(gem_obj);
 	return ret;
 }
 


