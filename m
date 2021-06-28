Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C93B636F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhF1O47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232633AbhF1OxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CE8061D3F;
        Mon, 28 Jun 2021 14:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891047;
        bh=u9S9ZUXnYem/UEMKI6Ucu33qh1Zhd3RCsTz0D6C3tNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrH2v/H0qhOK1b1/4mqx5BjoEhIzXwG7SsG9QOIkP8Atr2mvyiMBEyw+EaTOkha6q
         OIAruUf0WPIlJeFq5C9y8ETaZ94JaKkn+TLA+AGlezR1RNva9UuJGcxVDXROyyBF5Q
         yGfyojjAcQYCZuAS3NdHbvYMuozj+hiTDcU9Db9qdDtzZYpMvTCTdf1vwq/FidLV1H
         BcN7GrgZhKwNk+cuQqhwGFAnkDDasKYdrBnFXp1b8C0nhX/iY/83Uz374dU8y9hc3i
         hg8Dcu33+myS7LHKVHRNiRWMrL6G2MLb8biDsTm303C5qDkK1AX11X2pflhwfAu8L8
         2OmuCOQ8p0o/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 66/88] drm/radeon: wait for moving fence after pinning
Date:   Mon, 28 Jun 2021 10:36:06 -0400
Message-Id: <20210628143628.33342-67-sashal@kernel.org>
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
index 7110d403322c..c138e07f51a3 100644
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -92,9 +92,19 @@ int radeon_gem_prime_pin(struct drm_gem_object *obj)
 
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

