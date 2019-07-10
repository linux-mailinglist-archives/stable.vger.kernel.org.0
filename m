Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEBE64936
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfGJPDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbfGJPDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:03:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74448214AF;
        Wed, 10 Jul 2019 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562770990;
        bh=xLiWQv76Xy1ufLhd/aP1fBIA+yYEgXJzvV65wgiJ1TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQAW5c2qryIQMTYVivFF86HQmbl8aSBupoa1Vky4bv9rLiGhWauLbibVnpagD2fst
         +RRoaaqEepDjatOmToOoivCMS/cXkSXXqXWXgkC7eNkeoT+Igyd6DjIigPdNuAUTQ3
         emJ1q7vZUF1XxYWFXI1ZxCYIV3GiKUfzW0Gqcf4c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 4/9] drm/etnaviv: add missing failure path to destroy suballoc
Date:   Wed, 10 Jul 2019 11:02:54 -0400
Message-Id: <20190710150301.7129-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150301.7129-1-sashal@kernel.org>
References: <20190710150301.7129-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit be132e1375c1fffe48801296279079f8a59a9ed3 ]

When something goes wrong in the GPU init after the cmdbuf suballocator
has been constructed, we fail to destroy it properly. This causes havok
later when the GPU is unbound due to a module unload or similar.

Fixes: e66774dd6f6a (drm/etnaviv: add cmdbuf suballocator)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index f225fbc6edd2..6a859e077ea0 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -760,7 +760,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 	if (IS_ERR(gpu->cmdbuf_suballoc)) {
 		dev_err(gpu->dev, "Failed to create cmdbuf suballocator\n");
 		ret = PTR_ERR(gpu->cmdbuf_suballoc);
-		goto fail;
+		goto destroy_iommu;
 	}
 
 	/* Create buffer: */
@@ -768,7 +768,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 				  PAGE_SIZE);
 	if (ret) {
 		dev_err(gpu->dev, "could not create command buffer\n");
-		goto destroy_iommu;
+		goto destroy_suballoc;
 	}
 
 	if (gpu->mmu->version == ETNAVIV_IOMMU_V1 &&
@@ -800,6 +800,9 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 free_buffer:
 	etnaviv_cmdbuf_free(&gpu->buffer);
 	gpu->buffer.suballoc = NULL;
+destroy_suballoc:
+	etnaviv_cmdbuf_suballoc_destroy(gpu->cmdbuf_suballoc);
+	gpu->cmdbuf_suballoc = NULL;
 destroy_iommu:
 	etnaviv_iommu_destroy(gpu->mmu);
 	gpu->mmu = NULL;
-- 
2.20.1

