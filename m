Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416143B6A55
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbhF1V0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238033AbhF1VX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F1B61CF1;
        Mon, 28 Jun 2021 21:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915280;
        bh=mhQaTVy8s+F/kumuxowScws01H/8UkfLxvLYMWg9T48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O57lK0vVGtZvBGdmHzTykv3edAiBMHY3TYWA424k/Xbm53+nB5nSXkxNuxc6rBvRR
         qFzLlffp6qNCTqbPzuZE8QP6/Ofv2H2y9RCFoT+HlaKjhtVncYXramjB3qGQb4N3au
         9a6puzbTawllLTlBQZrXKe8EBOfEpETv67nIRJILzasM4mG9094ac6D3FWsuo4sfE6
         lgRSHltkJGckyP97PeOFPeKnmwpYpr0Td8qmgZPd1u2qkhitFRJsi0iQvxFtyHjAwx
         7BVKDl29z2lBXChJEROWS79sAKs9I2m0tL8UQwPz2sWfBe9FrZZR1AgJC+vymY+CI5
         cdKyXOzi1yvWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 2/2] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Mon, 28 Jun 2021 17:21:17 -0400
Message-Id: <20210628212117.43676-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212117.43676-1-sashal@kernel.org>
References: <20210628212117.43676-1-sashal@kernel.org>
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
index a2e6a81669e7..94b7798bdea4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -447,7 +447,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -467,7 +467,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
-- 
2.30.2

