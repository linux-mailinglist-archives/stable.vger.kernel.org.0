Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF3E304ABD
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbhAZE66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbhAYSuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78683224D4;
        Mon, 25 Jan 2021 18:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600574;
        bh=46LKZqi4rI03Ulvwlf0N0EAJL+Igftaxc2HOIZHrbhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUFZzIX18dtBHkCrqAhyiTOX+qc4IFTAL5I4fIcB0k1RCe/LRc9A4OTzhVfPIWtkx
         IB1MRT2dT+E42xN5B0yTsr1C4gn9c5AHQREKTCGP70+rix+Fh8cWTUzn3SjNXE3feX
         ib4kMVJJ5scGCcCxnGWJL60rs+gJ4QGClgScMg4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/199] drm/nouveau/mmu: fix vram heap sizing
Date:   Mon, 25 Jan 2021 19:38:10 +0100
Message-Id: <20210125183219.140964182@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



