Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3C43B610A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhF1Obg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234383AbhF1O3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F90E61C86;
        Mon, 28 Jun 2021 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890376;
        bh=VL+/AH8Xfy2zo2JtDmPB2fLvSbaiSbgT9qXKIlTq0DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlXqlfdxo542gZgKCfxrQMw5+qsBg6emGxgAYZaZY4I+X6rn/rWMwkrt/4Xz2/tpn
         THHHcpOXSxE9wGSRZvPo7LeKxXWWg7A8Ef9s+YYiGw9FADdsRSaP3tXKXZ4i9OaEwd
         hWeT9Xtg1zwRcAvA+lC9gcLbBuTFua12bPkEQWCNqHEZeE0XvhYcBhHuRHNbJlUaod
         M7fLotpjAoa8nPHMj6AlPj6B4IS2ziH3Tc3UOiPahFHsr1Oy0xW9E9wZzDP+mrbkP7
         ID1ATpuwPYBls7Co8dGp0WG38FTopeOGMdhCkrVKe3c7Ydw1Devq4PTaS9VXphRa/0
         efXGDGdxwPicg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 007/101] drm/amdgpu: wait for moving fence after pinning
Date:   Mon, 28 Jun 2021 10:24:33 -0400
Message-Id: <20210628142607.32218-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 1b56dbc1f304..e93ccdc5faf4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -238,9 +238,21 @@ static int amdgpu_dma_buf_pin(struct dma_buf_attachment *attach)
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

