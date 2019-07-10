Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E344648E1
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfGJPCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbfGJPCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:02:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E8F5208E4;
        Wed, 10 Jul 2019 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562770970;
        bh=DKmi2KSCPS3wMYyfLM0R/J5dmrI2ctocBVqUSRoPeWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdgMR5AvQcCP4iK2wHfKzP33QSZGFpL1ecUr96teZ7+qzTuhp/LmugCpQyrKiKOW9
         pvyuGX6lfXzkGBP7Vg8qWzn/fkraz2/bXCQG7Ttn5GVVsohOpTpq6nkm8tWacVJF7W
         wkc6UQWU9tlotbmUx+cLiR3XlS/jelCYn3+9U+KU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 05/11] drm/etnaviv: add missing failure path to destroy suballoc
Date:   Wed, 10 Jul 2019 11:02:32 -0400
Message-Id: <20190710150240.6984-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150240.6984-1-sashal@kernel.org>
References: <20190710150240.6984-1-sashal@kernel.org>
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
index 6904535475de..4cf44575a27b 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -762,7 +762,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 	if (IS_ERR(gpu->cmdbuf_suballoc)) {
 		dev_err(gpu->dev, "Failed to create cmdbuf suballocator\n");
 		ret = PTR_ERR(gpu->cmdbuf_suballoc);
-		goto fail;
+		goto destroy_iommu;
 	}
 
 	/* Create buffer: */
@@ -770,7 +770,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 				  PAGE_SIZE);
 	if (ret) {
 		dev_err(gpu->dev, "could not create command buffer\n");
-		goto destroy_iommu;
+		goto destroy_suballoc;
 	}
 
 	if (gpu->mmu->version == ETNAVIV_IOMMU_V1 &&
@@ -802,6 +802,9 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
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

