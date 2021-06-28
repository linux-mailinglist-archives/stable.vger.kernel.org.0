Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EE53B6A4C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbhF1V0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237968AbhF1VXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 971D961D05;
        Mon, 28 Jun 2021 21:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915268;
        bh=C/HLHG6Av8lXqimOwroFa0oITaX+axl/LT1kTAHBQKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foCe8AjheKgWrQCKP4Yka6knjjeqAzFwgpHXXblqlCWeBE9W7TRPtxMelNJNPyvAL
         m9WdtAHOfRqE/vj7cpRzLgZmb0Da8c2k9r303I5i93NG2M6k+MA6LBBeWdwKvHHxaf
         Y4ckcwmGABhU9BTndfEJIMznYC/y5VnzbQualY/T1J8hgwgbvLQb34nvdPhvlnHErO
         41QWgxMABP4Vi7q3Lwd/wTe2xfaFkfhKzIZbUIUvmqevbaD54uoTUR6/3y6u+hLKYL
         IRlXQGFPH26Lo+Fleiedk3CE0BmJoQH7HGm8nmgZ/tO4Q1Y0GAb0XHZwSo8OLpOIXz
         BVhHp7yoAtsag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 2/3] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Mon, 28 Jun 2021 17:21:04 -0400
Message-Id: <20210628212105.43449-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212105.43449-1-sashal@kernel.org>
References: <20210628212105.43449-1-sashal@kernel.org>
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
index f8015e0318d7..f7603be569fc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -542,7 +542,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -562,7 +562,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
-- 
2.30.2

