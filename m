Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB4F3B6A42
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhF1VXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237933AbhF1VX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A72461D03;
        Mon, 28 Jun 2021 21:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915263;
        bh=IW0R6kgmf6PFdCJOSJkRf6uhmpkBAYUPXrL6zXFRqLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YH21A6goq/lTwW02JXZVv58v8GyD6L9Fa1TFkfLXQgAWd8PYn6jOYmWVSbKxzlKh8
         XpJGLv30oDMj5YgTYls7OUXF5C7/pYCas1Af+XWU82gVxfrKCQSiBE9KaBxYLpW4pi
         kRtmnQ5myO8W0KhHoFrTF8QuBnFKIzFvATu3UIqbNayh2UWw+kP08FAzGtZPjeLTDV
         +b1d3cspvAq3cAkNa5QUn0EuFH2RAYhhEGM/N3//gaKHWcymNAEFvgIdMO7TNS1z77
         Gv1xJLgSXBZkQMnsQ1h0Nyce2vnediOrTCqH5OfJ1brPkNU2HXHvPuFYS7DJmDWnp4
         emeq8jBAXb+sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 3/4] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Mon, 28 Jun 2021 17:20:57 -0400
Message-Id: <20210628212059.43361-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212059.43361-1-sashal@kernel.org>
References: <20210628212059.43361-1-sashal@kernel.org>
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

