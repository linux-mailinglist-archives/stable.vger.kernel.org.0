Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7667E622C2
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388934AbfGHP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389335AbfGHP2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F821204EC;
        Mon,  8 Jul 2019 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599723;
        bh=ylqPuutFgMprDE1dCFgn4SIfV7iG8LZauyBpCDxVHy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyIFkBYGFZ6BQhzrNvKx8Bbyn9oxmKqbOlu5rC+W6dRF2CNpxsiolh1SpQPIO8cHW
         GpkX20HnGEZ+p7hhYZyWncOlJnAjcl3i5olBysO0ruwZqkiTIh5SrdaUIOTOt7oMzS
         VKcYxgAnzvYdQSmDTKeMaTrATNQYnQbjiYJEigRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 57/90] drm/etnaviv: add missing failure path to destroy suballoc
Date:   Mon,  8 Jul 2019 17:13:24 +0200
Message-Id: <20190708150525.342053201@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit be132e1375c1fffe48801296279079f8a59a9ed3 upstream.

When something goes wrong in the GPU init after the cmdbuf suballocator
has been constructed, we fail to destroy it properly. This causes havok
later when the GPU is unbound due to a module unload or similar.

Fixes: e66774dd6f6a (drm/etnaviv: add cmdbuf suballocator)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -760,7 +760,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu
 	if (IS_ERR(gpu->cmdbuf_suballoc)) {
 		dev_err(gpu->dev, "Failed to create cmdbuf suballocator\n");
 		ret = PTR_ERR(gpu->cmdbuf_suballoc);
-		goto fail;
+		goto destroy_iommu;
 	}
 
 	/* Create buffer: */
@@ -768,7 +768,7 @@ int etnaviv_gpu_init(struct etnaviv_gpu
 				  PAGE_SIZE);
 	if (ret) {
 		dev_err(gpu->dev, "could not create command buffer\n");
-		goto destroy_iommu;
+		goto destroy_suballoc;
 	}
 
 	if (gpu->mmu->version == ETNAVIV_IOMMU_V1 &&
@@ -800,6 +800,9 @@ int etnaviv_gpu_init(struct etnaviv_gpu
 free_buffer:
 	etnaviv_cmdbuf_free(&gpu->buffer);
 	gpu->buffer.suballoc = NULL;
+destroy_suballoc:
+	etnaviv_cmdbuf_suballoc_destroy(gpu->cmdbuf_suballoc);
+	gpu->cmdbuf_suballoc = NULL;
 destroy_iommu:
 	etnaviv_iommu_destroy(gpu->mmu);
 	gpu->mmu = NULL;


