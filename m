Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04672119A6
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgGBBXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgGBBXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F5920748;
        Thu,  2 Jul 2020 01:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593652983;
        bh=/5tEx96xy1e4vi6a8sCn19YEYK/t5MtKMJLjxv8RtbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMBLrFTTWgmGJbCRnVFdgqAuWGcGnW+rafceudbV1+Sy9KoJjWC83fN9SQ5H2Kkwt
         BS4VPWly8zyKoIMhkCVOSnehRJ121wxMjhpbCl82P9E8PRCkVFKe45aQApftDPLBuu
         s4FGxCeKnU/1dNrjPcCi/jRMZmG/+Lc/qsQ5U/xU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.7 07/53] drm/ttm: Fix dma_fence refcnt leak when adding move fence
Date:   Wed,  1 Jul 2020 21:21:16 -0400
Message-Id: <20200702012202.2700645-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 11425c4519e2c974a100fc984867046d905b9380 ]

ttm_bo_add_move_fence() invokes dma_fence_get(), which returns a
reference of the specified dma_fence object to "fence" with increased
refcnt.

When ttm_bo_add_move_fence() returns, local variable "fence" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
ttm_bo_add_move_fence(). When no_wait_gpu flag is equals to true, the
function forgets to decrease the refcnt increased by dma_fence_get(),
causing a refcnt leak.

Fix this issue by calling dma_fence_put() when no_wait_gpu flag is
equals to true.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/370221/
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 9e07c3f75156b..ef5bc00c73e23 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -881,8 +881,10 @@ static int ttm_bo_add_move_fence(struct ttm_buffer_object *bo,
 	if (!fence)
 		return 0;
 
-	if (no_wait_gpu)
+	if (no_wait_gpu) {
+		dma_fence_put(fence);
 		return -EBUSY;
+	}
 
 	dma_resv_add_shared_fence(bo->base.resv, fence);
 
-- 
2.25.1

