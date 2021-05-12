Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2213A37C7EA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhELQDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238275AbhELP5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EFDB61CB8;
        Wed, 12 May 2021 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833480;
        bh=LHJQggMCwBFOT+IBWn15tQ/S0akoIxyp0tDCh+0y/eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdguB4XzSPIkYZABMdLER+q16ahXx0iU3DO+FfV71+emc+qUZSS2jpIuuZPusADZ5
         m/DyrpyeJMkAEx37oGw5rgSKUUfgc1jV+FWZIxGu2m1izQfwaR8IPDX36ht67lgk+X
         hOov3gpIw+0lRRD6YVQjaquJJbSsyBnx5GMYAvRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 166/601] mtd: rawnand: fsmc: Fix error code in fsmc_nand_probe()
Date:   Wed, 12 May 2021 16:44:03 +0200
Message-Id: <20210512144833.299820480@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e7a97528e3c787802d8c643d6ab2f428511bb047 ]

If dma_request_channel() fails then the probe fails and it should
return a negative error code, but currently it returns success.

fixes: 4774fb0a48aa ("mtd: nand/fsmc: Add DMA support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/YCqaOZ83OvPOzLwh@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/raw/fsmc_nand.c b/drivers/mtd/nand/raw/fsmc_nand.c
index 0101c0fab50a..a24e2f57fa68 100644
--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -1077,11 +1077,13 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 		host->read_dma_chan = dma_request_channel(mask, filter, NULL);
 		if (!host->read_dma_chan) {
 			dev_err(&pdev->dev, "Unable to get read dma channel\n");
+			ret = -ENODEV;
 			goto disable_clk;
 		}
 		host->write_dma_chan = dma_request_channel(mask, filter, NULL);
 		if (!host->write_dma_chan) {
 			dev_err(&pdev->dev, "Unable to get write dma channel\n");
+			ret = -ENODEV;
 			goto release_dma_read_chan;
 		}
 	}
-- 
2.30.2



