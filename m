Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA973B5FDA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhF1OVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232620AbhF1OVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6C2061C76;
        Mon, 28 Jun 2021 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889915;
        bh=LnEQK4NfgqhdST7Zo4MItNRSuSbj6Pu2gjJ5JxhEp1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3HKqTY8kdOD5UvnFj+UAcrB5YqT0cxXjYKzk5TAW0BH7zrwqg+g3V7eH5jI7EBVm
         Te5juPa9RzZKf/UT5A16dvlgFh7USHge5gxTq9NMxryWgoa/AXZu3HLpOqBJGW8cSz
         X8Vb6fKtNnpwdk+y+cLHB9Sys97FH4GcZMPYWcNGEYyf6wWHylCx2TqrCEM/e1YiRX
         eVYspgWjUXOhhAsZ4CyUUrK1Gjemy+U2RC/RYlaSg20hdao0Cx9tEtSMnBRng7v/Yd
         PGywlAE2OuCKoGVKGaeoW6U865wmxMHnWL616nU5VFGDmUSZNFatA4A0Ea6e07Ctob
         UfiuQikGTozQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 005/110] drm/nouveau: wait for moving fence after pinning v2
Date:   Mon, 28 Jun 2021 10:16:43 -0400
Message-Id: <20210628141828.31757-6-sashal@kernel.org>
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
index 347488685f74..60019d0532fc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -93,7 +93,22 @@ int nouveau_gem_prime_pin(struct drm_gem_object *obj)
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

