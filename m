Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918373B6184
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhF1OgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234958AbhF1Oe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A9E61C7A;
        Mon, 28 Jun 2021 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890610;
        bh=QOuBBdXeke7QOSkcWHNmZztW+K3a7ygHLbyq7wJBmng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt9PpymtfCvsNgEtbGfbOYjOz4To8GCCA07yNWX8iPUx7F0ZMV86jphNDfEoa30gK
         37zkd5kSdt23iykmYxKfJO8+6ToNBU/SL5Q2AAnanA39REYZ9YmIpe8XSy+/BLSXcW
         1Wrv5pSDbE0k//MhD1PzOHb01qDSuUh4fokf3YdAIaEjmd5k6bvPTMKWeadGNnLbrG
         Qmahra4O0Ug2n8ri2fSwdS3yByL178uvTgQNObOjGyd+x3O4mdAsFKq95Lg0zyMG86
         UuK51u7+kxqOMQiReFeOXGGXzbQfQE5xT8UvzK+nbS5i85hPCmnG2PxEsf2MXa6CGw
         EO1dU3xJFvk+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 05/71] drm/radeon: wait for moving fence after pinning
Date:   Mon, 28 Jun 2021 10:28:58 -0400
Message-Id: <20210628143004.32596-6-sashal@kernel.org>
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
index b906e8fbd5f3..7bc33a80934c 100644
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -94,9 +94,19 @@ int radeon_gem_prime_pin(struct drm_gem_object *obj)
 
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

