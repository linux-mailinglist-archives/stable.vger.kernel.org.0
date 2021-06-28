Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642003B6A2A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbhF1VXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237868AbhF1VXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6076361D03;
        Mon, 28 Jun 2021 21:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915257;
        bh=uvJEh0sxCUzclhUTIdb3WixNobiqcA+N5C6zNMxBtcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDghOrgAGxjexYn0aH4rZguWqJav7fNkQ03GXpFl4PhPY9A3gPcd7keLU3vKi6bQu
         CcXB1RpifGARIAMPQ580Auhk59LbATQMWeRrDgQ8hFYqeIanITckZuzJMhGHz3FjdQ
         VuFAet1Ll9OSEmHKGdz/6PCz2bqbnnKGY0szDJNPBYuGMZaNghqgQE41boAugdbs3m
         1g4TwhIpvrIq+iFkE4yS4YNauYrekzvkwqCFZkaDH05xKOYQnUAbOxTerVQu5o9vVw
         tyn8DW8GvkjVFE2cvb86XLkKyv0otRCNlBhRsbO5WwEKJnKL7qOGEktBn13S9NGrjZ
         DUIdBha/rie3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 4/5] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Mon, 28 Jun 2021 17:20:50 -0400
Message-Id: <20210628212051.43265-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212051.43265-1-sashal@kernel.org>
References: <20210628212051.43265-1-sashal@kernel.org>
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
index f2720a006199..0a47a2a5553d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -549,7 +549,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_tt *ttm_dma = (struct ttm_tt *)nvbo->bo.ttm;
 	int i, j;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 	if (!ttm_dma->pages) {
 		NV_DEBUG(drm, "ttm_dma 0x%p: pages NULL\n", ttm_dma);
@@ -585,7 +585,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_tt *ttm_dma = (struct ttm_tt *)nvbo->bo.ttm;
 	int i, j;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 	if (!ttm_dma->pages) {
 		NV_DEBUG(drm, "ttm_dma 0x%p: pages NULL\n", ttm_dma);
-- 
2.30.2

