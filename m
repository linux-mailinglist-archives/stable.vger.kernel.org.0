Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F60F21FCC0
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgGNStE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730047AbgGNStA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:49:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0365C22AAA;
        Tue, 14 Jul 2020 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752539;
        bh=t14ieBLjcRC8mGAiZegb7Cr7kUc2KlBM9DA1w+vutoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZrATEcO99ER/+SCPMZVXiZ/QVk9nngnw3Gt0iHorDy+vsXzpjvi3T0wQTVM9agJF
         Kfb3cmfBEhCWBfZMNnRnr4oPRH4FVDNzdYIEflQNS3VQvc3GTtdTLATVMclBqKpUzG
         k88tI8QxKT8NaW/iWirEX2TJWzX6SV4JNq6qj1y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/109] drm/ttm: Fix dma_fence refcnt leak when adding move fence
Date:   Tue, 14 Jul 2020 20:43:11 +0200
Message-Id: <20200714184105.922884512@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
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
index abf165b2f64fc..3ce8ad7603c7f 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -941,8 +941,10 @@ static int ttm_bo_add_move_fence(struct ttm_buffer_object *bo,
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



