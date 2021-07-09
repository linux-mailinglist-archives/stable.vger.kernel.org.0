Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF073C2439
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhGINVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231761AbhGINVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE95E61377;
        Fri,  9 Jul 2021 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836736;
        bh=mhQaTVy8s+F/kumuxowScws01H/8UkfLxvLYMWg9T48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OonZxvFjFZ/pk6eYWaPkpnBTeOuHM25wJxAS745WG1SM45ihXOsJIAlYvh0Zg9rhY
         jSDHiQitWbQY8IQsX0nmx0jM2l3aIRez9p4nEBDtzR52PuYBh+NDY0Y0tVcftDaWN7
         pSgxXnJ40S1Wh+laz+9Q+1LDTUk2bJZFxoOhjQCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 6/9] drm/nouveau: fix dma_address check for CPU/GPU sync
Date:   Fri,  9 Jul 2021 15:18:33 +0200
Message-Id: <20210709131551.474917278@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
References: <20210709131542.410636747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



