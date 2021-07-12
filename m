Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114153C5554
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355578AbhGLIJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353524AbhGLICa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FFED613D9;
        Mon, 12 Jul 2021 07:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076529;
        bh=Bpq/MmB/02H+JLEhnVvAKr4K9Tdo/epgwWdxe59CIhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q91NqEX+r5GycGjYsNbV7Fz+N6QP3r4y92stlCiLLiKskY44u1mVvlYMQFtZuk1rA
         VTb4DtPZ+Mt+XmnTTp1Iqib0LURkLnth9e7HSYKLLKCiPX55IyqRcS6QWzdA6LEEiz
         mKy+fsCfb53MUCJtL6zU9qYRSzKZ0QTjHuQAhoYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sven Peter <sven@svenpeter.dev>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 682/800] iommu/dma: Fix IOVA reserve dma ranges
Date:   Mon, 12 Jul 2021 08:11:45 +0200
Message-Id: <20210712061039.412652267@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinath Mannam <srinath.mannam@broadcom.com>

[ Upstream commit 571f316074a203e979ea90211d9acf423dfe5f46 ]

Fix IOVA reserve failure in the case when address of first memory region
listed in dma-ranges is equal to 0x0.

Fixes: aadad097cd46f ("iommu/dma: Reserve IOVA for PCIe inaccessible DMA address")
Signed-off-by: Srinath Mannam <srinath.mannam@broadcom.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20200914072319.6091-1-srinath.mannam@broadcom.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7bcdd1205535..95e7349ac3f1 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -243,9 +243,11 @@ resv_iova:
 			lo = iova_pfn(iovad, start);
 			hi = iova_pfn(iovad, end);
 			reserve_iova(iovad, lo, hi);
-		} else {
+		} else if (end < start) {
 			/* dma_ranges list should be sorted */
-			dev_err(&dev->dev, "Failed to reserve IOVA\n");
+			dev_err(&dev->dev,
+				"Failed to reserve IOVA [%#010llx-%#010llx]\n",
+				start, end);
 			return -EINVAL;
 		}
 
-- 
2.30.2



