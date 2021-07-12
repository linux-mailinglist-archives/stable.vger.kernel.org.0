Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C5F3C4F93
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243757AbhGLH00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343888AbhGLHYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A78610D1;
        Mon, 12 Jul 2021 07:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074480;
        bh=8aM6KP0ldeY/2jSHS0t+iROeuS+RTD3zgSOyxhturkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qf1xTcVfCtzP6rarW+zdqb4tsUUn8UoOLQxtP3wH9oW4iBaXBV8KH+4wXuhsgq1io
         eLW/s0ITVjKFxV/N0v3wmjAnUxta6QOZQ03FV28z06l5wupgN9sb8gOCMV4chqYoWo
         pnz3MSmtlxIbRNCOGn432YOPJtPtqIA1EaiTGd4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sven Peter <sven@svenpeter.dev>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 595/700] iommu/dma: Fix IOVA reserve dma ranges
Date:   Mon, 12 Jul 2021 08:11:18 +0200
Message-Id: <20210712061039.257426729@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index fdd095e1fa52..5f75ab0dfc73 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -252,9 +252,11 @@ resv_iova:
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



