Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3B22FC7E9
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbhATC3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbhATB2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 070222250E;
        Wed, 20 Jan 2021 01:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106013;
        bh=46LKZqi4rI03Ulvwlf0N0EAJL+Igftaxc2HOIZHrbhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKEjT3jz/l5tGicmISgUmFUWSDiO4T9l+ck8oLvILUVVikEcHEv2gvHLGHcxu/vOs
         BFQs5GGSqED11o1H9pIt+K22eBXykEQ/CBFE9WSwKNFipi+YpJ2dmOjSM8sUpfTUS9
         lbHfR2sKY/mfGY53pX2LCDYDOusrXSOifMv1F+dmRZba7vYlnD8xUNIHr6rEIwQI20
         FO9Lp8sfuc6ge2zoTCUV6HXoqTb8IRjjRge392pRGtb69elCi/AVWaWlIXLGpwNhTn
         r6yWEnrCfpgF1+6a3Y2D3D6M6/N3GWxdvzFYLK0YSWI6dB54f+agn/d3Wikx3KMWHu
         WINLxlfdd6l7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 39/45] drm/nouveau/mmu: fix vram heap sizing
Date:   Tue, 19 Jan 2021 20:25:56 -0500
Message-Id: <20210120012602.769683-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
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
index de91e9a261725..6d5212ae2fd57 100644
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

