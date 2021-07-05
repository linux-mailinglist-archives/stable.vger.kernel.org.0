Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF13BBBD2
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhGELCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbhGELCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D40D6142F;
        Mon,  5 Jul 2021 11:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482802;
        bh=IW0R6kgmf6PFdCJOSJkRf6uhmpkBAYUPXrL6zXFRqLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdCf1vA4ym4tv4e+OIlh5bKMGzOFWEakagbjEYFK994cepm4vLrnRTHs0sFoYxWVO
         ch9kI4nrCxm7FycQZKcKMYpztr4lo6pD7mgvEyBM4tqso2DSpwfGkh2BYrRgYPdgYP
         cLpX11lHSRdy0B9xZKepZpLR7XVVkracNOz+fftM4rgr7Y15VXpSIfaqI5Gsk0R+gd
         5KV1/Z9sjs/T9pGKN3fDbA65UaQ30PTUcP/ETTQrf8TRMiqNKBgNqdtKiyLUWbn+oT
         U/6KvDxx36OIA9AmxmRxrNnXyagw6hcYqWLDuzfGbpdviuBZDMamSyGYxvjj5/8pE0
         tlrQYpTr6Dl4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 3/7] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Mon,  5 Jul 2021 06:59:53 -0400
Message-Id: <20210705105957.1513284-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.48-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit d330099115597bbc238d6758a4930e72b49ea9ba ]

AGP for example doesn't have a dma_address array.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210614110517.1624-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 7daa12eec01b..b4946b595d86 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -590,7 +590,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -610,7 +610,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
-- 
2.30.2

