Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8153E3B60D6
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhF1Oat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234242AbhF1O3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E96F261C7B;
        Mon, 28 Jun 2021 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890374;
        bh=oJsQ69sJ0nqRO2QxXdHdJ2AHXTIMcZrKqqxwAOGs6oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUvwH36bMHJfFVpgq6ZkfK20hzhtthxUR7BONFeggcth+5je7kb7XAsyA4YfAQipN
         9rVSDtip2xuCUIdLWd50f0AJS4LcfdvGMhIVsthfWJqf2e0pwnS8D9yA0sMDF29XFV
         7ADXcIvFne2ysGMKLlHobQUlZuwZBrnjEYMbzI+nAQz7KG9FAVKxAoK8MtWaopNUWe
         GBdEvpqV+mR/jNkSkEOfEpJCXR2JFPUuvZw8drpo9o1sInxIONJAxW/e3Na/gpCBqH
         sLFsjE8SGICOG9ZzZlYs4nVJR/cyuTTeFnuNVGkruJ1a0ol5bqToG10s3n2wZqo/0i
         ebyvjg3q24emw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 005/101] drm/nouveau: wait for moving fence after pinning v2
Date:   Mon, 28 Jun 2021 10:24:31 -0400
Message-Id: <20210628142607.32218-6-sashal@kernel.org>
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
index b2ecb91f8ddc..5f5b87f99546 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -111,7 +111,22 @@ int nouveau_gem_prime_pin(struct drm_gem_object *obj)
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

