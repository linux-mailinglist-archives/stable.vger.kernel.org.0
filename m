Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCE43B6182
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhF1OgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234948AbhF1Oe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A7A619C3;
        Mon, 28 Jun 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890610;
        bh=2ypD3oMBtrLO1SzSha045+tdcFrEZG5HxN7LR6fut0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDjVG9fJzHH+YSrGmTwpA64Zrs2nIv9CNNGoic5rj/YIAp/z/jZbHWrn+IsRnE5vi
         99vOhIDuXpQ8qLaOluS2pquBXKW+48TOAbNecR9bq1I8mTLdzxqm3FUpvw8walTFjp
         p85LaXTQ/9y+5/CrH9NhbSuKBdjc5Qwrq6MJvjDvtBd6cFoq2+epi4CmqB2Xr+MKvh
         /xPNDHrypHngtnUDUXQ3KjqPjuh4MHqd0IEVKWstDUvtlE+LD0gFf9zBTz/q5k7+kF
         jIlr/Amttz0XlQ7sS+KL09YIy7LlqhNlY/VkwaYrcvmzs9TqaP+3I2zzTTuZUIMDXO
         96zwaVO9G0ZOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 04/71] drm/nouveau: wait for moving fence after pinning v2
Date:   Mon, 28 Jun 2021 10:28:57 -0400
Message-Id: <20210628143004.32596-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 17b11f71795abdce46f62a808f906857e525cea8 upstream.

We actually need to wait for the moving fence after pinning
the BO to make sure that the pin is completed.

v2: grab the lock while waiting

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
References: https://lore.kernel.org/dri-devel/20210621151758.2347474-1-daniel.vetter@ffwll.ch/
CC: stable@kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210622114506.106349-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_prime.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index bae6a3eccee0..f9ee562f72d3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -112,7 +112,22 @@ int nouveau_gem_prime_pin(struct drm_gem_object *obj)
 	if (ret)
 		return -EINVAL;
 
-	return 0;
+	ret = ttm_bo_reserve(&nvbo->bo, false, false, NULL);
+	if (ret)
+		goto error;
+
+	if (nvbo->bo.moving)
+		ret = dma_fence_wait(nvbo->bo.moving, true);
+
+	ttm_bo_unreserve(&nvbo->bo);
+	if (ret)
+		goto error;
+
+	return ret;
+
+error:
+	nouveau_bo_unpin(nvbo);
+	return ret;
 }
 
 void nouveau_gem_prime_unpin(struct drm_gem_object *obj)
-- 
2.30.2

