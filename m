Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCD83B6372
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhF1O5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234567AbhF1OxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15E161D41;
        Mon, 28 Jun 2021 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891046;
        bh=TTNoOWy/W2/+OH9FQG92HKqHLAhFB645HhLAwb+PQsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCINEutLBX/6izc5yR6i7WiZDpmm53K1zTLRwFL0dl1U7iNUYZzZB2dSAjtoq8rlH
         6bFuQ90Fu+MZC5V8xtZLDUddQH3neIrd7CSOV7y7XwKlGilR6hukNvjGth9Dg1ynQT
         122MvWKzRfV5dhO9DkXL6SOCKoRs3e/6kjojB6PXLOTIAdc6N5bYGcCqZNm1E+oaO7
         OqvRzqF9KO//0p49irZblbJr6U43nlvoPNwOXyXU+ix5OTJ1O7fkiocEHBcsnOYpfZ
         yhlxi3gpo4d6GHjN5S4msNpG6RC040cYZZtoofKA5KUUxUIBFcT4fKr1Vo/QgCyR0Y
         CrI0Om4pmqpyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 65/88] drm/nouveau: wait for moving fence after pinning v2
Date:   Mon, 28 Jun 2021 10:36:05 -0400
Message-Id: <20210628143628.33342-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index 1fefc93af1d7..bbfce7b9d03e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -98,7 +98,22 @@ int nouveau_gem_prime_pin(struct drm_gem_object *obj)
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

