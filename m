Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83143B5FDB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhF1OVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232621AbhF1OVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F2A761C75;
        Mon, 28 Jun 2021 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889916;
        bh=Dq89ft9uyFriMY0UgDWQnH4SMG7imil23drZLrwetbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YprkvGOJQrYekCojSN3a48HI2tG9/NOu237o14HQYLxaFJmwO+sx0ZGXmXohMWO+H
         2z2eIsPH4E9kMFnT5qFBiwPFITbWs5Bhc1qJIp9KEulkFgUwBoU55rVMhgYYW4r8P8
         1cInqzCVX+aKzki5lTxzCJp57nZz63ySCHo2y+aNFieNlh1HMT5Z1IqlTUpcISZwyu
         e47jlm/7Ktd2RA4fpd9svxIZ24D0xZwS7puC5ze/2rKEFSa1PjhBkJJJSawaMb3W/7
         DC/cqk0QjfFi8tcQjWSAgFQiEN3N5sgCM+4OSUstGRiL3AMTxhxrCZIQRHhXSkoGxy
         /kBNOEynpWAEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 006/110] drm/radeon: wait for moving fence after pinning
Date:   Mon, 28 Jun 2021 10:16:44 -0400
Message-Id: <20210628141828.31757-7-sashal@kernel.org>
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

commit 4b41726aae563273bb4b4a9462ba51ce4d372f78 upstream.

We actually need to wait for the moving fence after pinning
the BO to make sure that the pin is completed.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
References: https://lore.kernel.org/dri-devel/20210621151758.2347474-1-daniel.vetter@ffwll.ch/
CC: stable@kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210622114506.106349-2-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_prime.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_prime.c b/drivers/gpu/drm/radeon/radeon_prime.c
index 42a87948e28c..4a90807351e7 100644
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -77,9 +77,19 @@ int radeon_gem_prime_pin(struct drm_gem_object *obj)
 
 	/* pin buffer into GTT */
 	ret = radeon_bo_pin(bo, RADEON_GEM_DOMAIN_GTT, NULL);
-	if (likely(ret == 0))
-		bo->prime_shared_count++;
-
+	if (unlikely(ret))
+		goto error;
+
+	if (bo->tbo.moving) {
+		ret = dma_fence_wait(bo->tbo.moving, false);
+		if (unlikely(ret)) {
+			radeon_bo_unpin(bo);
+			goto error;
+		}
+	}
+
+	bo->prime_shared_count++;
+error:
 	radeon_bo_unreserve(bo);
 	return ret;
 }
-- 
2.30.2

