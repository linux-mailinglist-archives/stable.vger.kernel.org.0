Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140C13B5FDD
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhF1OVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232603AbhF1OVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A32861C77;
        Mon, 28 Jun 2021 14:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889917;
        bh=WrVM/L2WjFciJlbvd0pxCnF87zjgocgPaqks/9vT3wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fB8WD3R7wuYTK6epZEv7/zpi0cY5viohZua0Z0uYxZ993yPP2PA9K/ZRpfK5pM6sc
         vEkkabIaPQWJnWyB15IXlfaaPNOO6AzVZkMqy/LFHtsRB0VxuzbyTnpFN1japdQqKD
         4ve+aTo2uSAMaDGmF1WiRdBhZnNR/UGd98ccyfi4jVjKA4C6Clqw319qSc+EAaL/6C
         tsVSIeLqZmft/RA7RiA85NAdrw4I0caQtfuJ2/U1nDoynEOzyVRhcN+nYoGYyWSvLE
         MbAH1u78RZ4AGHXf8z8jE3DR5bzmLpa912B9foABIkZMZpkEagqAkN7r8+MCYtPVUU
         BqpZcWLGCigrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 007/110] drm/amdgpu: wait for moving fence after pinning
Date:   Mon, 28 Jun 2021 10:16:45 -0400
Message-Id: <20210628141828.31757-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 8ddf5b9bb479570a3825d70fecfb9399bc15700c upstream.

We actually need to wait for the moving fence after pinning
the BO to make sure that the pin is completed.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
References: https://lore.kernel.org/dri-devel/20210621151758.2347474-1-daniel.vetter@ffwll.ch/
CC: stable@kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210622114506.106349-3-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index 47e0b48dc26f..1c4623d25a62 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -214,9 +214,21 @@ static int amdgpu_dma_buf_pin(struct dma_buf_attachment *attach)
 {
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	int r;
 
 	/* pin buffer into GTT */
-	return amdgpu_bo_pin(bo, AMDGPU_GEM_DOMAIN_GTT);
+	r = amdgpu_bo_pin(bo, AMDGPU_GEM_DOMAIN_GTT);
+	if (r)
+		return r;
+
+	if (bo->tbo.moving) {
+		r = dma_fence_wait(bo->tbo.moving, true);
+		if (r) {
+			amdgpu_bo_unpin(bo);
+			return r;
+		}
+	}
+	return 0;
 }
 
 /**
-- 
2.30.2

