Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76E43BBBC1
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhGELCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhGELCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C5606141C;
        Mon,  5 Jul 2021 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482780;
        bh=uvJEh0sxCUzclhUTIdb3WixNobiqcA+N5C6zNMxBtcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWSRzJwO4CcL8p75JTIMMJXAaQtnNvdt/oZqekdVf1Th0NK3zmR1db22QB07a+5ms
         CufAS2iilDuLLvNAcjNKgQgNflU75jt8RF/ylDjCMAoHlxdM0wTZvO5hVNRkApQzhd
         jG6jB1JxzgXUjzy4vI4APeBPz24258v6IYRdpmVYLznXiy2cXBu6luW3441zBzt8Xx
         h4EvexO6yuCHEzkAqlN0CV6SqWocCp6VM59me3138KZwqbHhU8fSNKla5xoXSZxFzB
         D2jr7N5R6bt0ROKcgGKNjvNwR3/STimFQXnXlLZz8Hl6bj7lkQky4hq7qmQJjiNiHF
         ftfAaz6QuZ5QQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 4/7] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Mon,  5 Jul 2021 06:59:31 -0400
Message-Id: <20210705105934.1513188-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.15-rc1
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

