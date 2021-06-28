Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFBA3B6A5A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbhF1V04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238059AbhF1VYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF52361D0B;
        Mon, 28 Jun 2021 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915284;
        bh=cwwtqavFK7tU7JXzqiqwlEYlXq2bfP6ekDHIVIt8nIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKkOWJ6dqG837vdtnS3J2t3k575q4aWV/DyPo0qug3DS8T8oU6kMyVuzXrc5IfzKx
         qzegfCLvGfFnS7dxRABc4r7FvIzt+CK4cKkocttmPnt33GOSf6AMUjvT0jkVJWNxIm
         Sdc7hW8MB7GTAHOnH+/qnJGT39uRRGiwNjjXAS+HCbaYXcZeAFlvY/Hw8k1V1J3j9E
         OcZb6xa/xKL38bdq1ksN3dv45RWfjeQMjdXEZ4W94W613wkwwgQAU8VTTIqs5S5LZW
         ViAuRc92WRjDpX4eqIjOv5S1qryRD3D0LicUVOKJzdygBQ7cH3Mp1ZWy+H8BGWvs9N
         mIgRu6thocDwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 2/2] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Mon, 28 Jun 2021 17:21:21 -0400
Message-Id: <20210628212121.43749-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212121.43749-1-sashal@kernel.org>
References: <20210628212121.43749-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 78f520d05de9..58c310930bf2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -458,7 +458,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -478,7 +478,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
-- 
2.30.2

