Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A872FC7D7
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbhATB3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbhATB30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAED623442;
        Wed, 20 Jan 2021 01:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106080;
        bh=5WUoD5zwsd4RXHHGhCQkpJlGUZLtx2s2ZRLAwnOOOLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CL1ZtN1BXQzcYsGYRZ2SYL1PMzNVamJJbo7XrjBfG4GsOX0ylONVfqZ7PrmvFW9rY
         NYLUVYa/ZjOkmj46M7MMgvEuPPJBz8TpztK2NqBpFidtergI/o453S8cG0PE2fptOZ
         uaKsQO+T9UEXgpXBS+1zoqv+8XC7dyrrn3dFV7dM6DcqVt3u43cuUcP3brcv+1fz4E
         mIDKaIZFuGIilpj5OEXZmsDa4R95QRxsRKUBFGcm7pFy/MllLhPCgDKQkzfg3LnAGj
         8TgwPsVDT2rVDqVxBuNrO2c1D6vnmEKfjoTM7QwM5/6fSR9h+/Z5IKMtGgn2DtDST6
         2x/UMSohLevAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 14/15] drm/nouveau/mmu: fix vram heap sizing
Date:   Tue, 19 Jan 2021 20:27:39 -0500
Message-Id: <20210120012740.770354-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012740.770354-1-sashal@kernel.org>
References: <20210120012740.770354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit add42781ad76c5ae65127bf13852a4c6b2f08849 ]

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c
index ee11ccaf0563c..cb51e248cb41b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c
@@ -316,9 +316,9 @@ nvkm_mmu_vram(struct nvkm_mmu *mmu)
 {
 	struct nvkm_device *device = mmu->subdev.device;
 	struct nvkm_mm *mm = &device->fb->ram->vram;
-	const u32 sizeN = nvkm_mm_heap_size(mm, NVKM_RAM_MM_NORMAL);
-	const u32 sizeU = nvkm_mm_heap_size(mm, NVKM_RAM_MM_NOMAP);
-	const u32 sizeM = nvkm_mm_heap_size(mm, NVKM_RAM_MM_MIXED);
+	const u64 sizeN = nvkm_mm_heap_size(mm, NVKM_RAM_MM_NORMAL);
+	const u64 sizeU = nvkm_mm_heap_size(mm, NVKM_RAM_MM_NOMAP);
+	const u64 sizeM = nvkm_mm_heap_size(mm, NVKM_RAM_MM_MIXED);
 	u8 type = NVKM_MEM_KIND * !!mmu->func->kind;
 	u8 heap = NVKM_MEM_VRAM;
 	int heapM, heapN, heapU;
-- 
2.27.0

