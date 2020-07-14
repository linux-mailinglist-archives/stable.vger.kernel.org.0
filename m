Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4555821FA9D
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgGNSyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730282AbgGNSyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:54:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDDE222BEB;
        Tue, 14 Jul 2020 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752849;
        bh=/5tEx96xy1e4vi6a8sCn19YEYK/t5MtKMJLjxv8RtbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u36OA5GhmfMN/W8KlPoIEqw7Vy+xMF/N97tGjWUbCvqSEU1AyaDMgt4xEwozqVWp2
         cF5HSTYFu/vGmspk73AxMKQs+rkYbkpdlp6jJd0RyseRcMdMhMRtOOz9+0kBeIYiDG
         39iLMU2bY2NT+wLYMn4Y0YAsCVTUJvmkJY4wP8Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 009/166] drm/ttm: Fix dma_fence refcnt leak when adding move fence
Date:   Tue, 14 Jul 2020 20:42:54 +0200
Message-Id: <20200714184116.328755976@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



