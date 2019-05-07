Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A4215CDF
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfEGFdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfEGFdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:33:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 360D520B7C;
        Tue,  7 May 2019 05:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207194;
        bh=R0PO4GjbaXvyyFAmNd0CfrHD0e3Tw5YcMEH89b+Fats=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofVyZOL904Rst0gUKmeMmk7vOkJm/3k4UNHxK9SLYRfh+y44u1TfwAMTeb05+X8Vz
         wCaXTzqPGqSmSG8AlUevJyhzvIxJYW4cs96axg2C3zihIGNVRtrEI5T3ktIg1Xd/nQ
         NaPghriRacFLGOG9F4pjm339l+3zyfHSD7wZpMbU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Yi <teroincn@163.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.0 22/99] drm/ttm: fix dma_fence refcount imbalance on error path
Date:   Tue,  7 May 2019 01:31:16 -0400
Message-Id: <20190507053235.29900-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Yi <teroincn@163.com>

[ Upstream commit 543c364d8eeeb42c0edfaac9764f4e9f3d777ec1 ]

the ttm_bo_add_move_fence takes a reference to the struct dma_fence, but
failed to release it on the error path, leading to a memory leak.
add dma_fence_put before return when error occur.

Signed-off-by: Lin Yi <teroincn@163.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 996cadd83f24..d8e1b3f12904 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -881,8 +881,10 @@ static int ttm_bo_add_move_fence(struct ttm_buffer_object *bo,
 		reservation_object_add_shared_fence(bo->resv, fence);
 
 		ret = reservation_object_reserve_shared(bo->resv, 1);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			dma_fence_put(fence);
 			return ret;
+		}
 
 		dma_fence_put(bo->moving);
 		bo->moving = fence;
-- 
2.20.1

