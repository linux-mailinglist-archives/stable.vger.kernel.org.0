Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B24D3C4AD9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbhGLGx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240013AbhGLGub (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4371C60FE3;
        Mon, 12 Jul 2021 06:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072447;
        bh=ca+4qMqjW87wckmY2GdNOKKzEHj/4vbYdkg3bg5FsYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjND1mRbw5H72EEqVf4xBAX4qGaTwhudLPPx1QiL+0lRkGLJ+ZqZ05Wdwj+e6X9te
         yCYcfAjw//H+6nYCUwKEV4Sq13F0Y7OdCxAxGNaVMDeeVfDkSBOCIcvAbjSALSfw4P
         aX3tJkrfUReb1EIWEm0ev8v2QLYUuDgB3Ar6dPns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sven Peter <sven@svenpeter.dev>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 500/593] iommu/dma: Fix IOVA reserve dma ranges
Date:   Mon, 12 Jul 2021 08:11:00 +0200
Message-Id: <20210712060946.548906430@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 0cbcd3fc3e7e..840dd2b66ce7 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -216,9 +216,11 @@ resv_iova:
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



