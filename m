Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A499BFA29D
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfKMCEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:04:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbfKMCB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:01:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F66222CA;
        Wed, 13 Nov 2019 02:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610517;
        bh=u2HPfRf/Kr1Qq6s8M6REfzpCPG/qBcR8on1BXqhMHJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v06lANdtncHlAYR4rZTxb5gEvisqmkl65CHuORZHZmhFCCvV9JAYXIecwcJZjtGa9
         sUySp91pd/8ZrK1bvZRRK8EqJGppce6c3FsPmh1d2DU9Bgz1hcscPs2lkSFs/FNdQb
         gHWCVzn5YY/yeHGiDrjdIBddUBkmrT9ab77QjEkw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.4 16/48] mtd: rawnand: sh_flctl: Use proper enum for flctl_dma_fifo0_transfer
Date:   Tue, 12 Nov 2019 21:00:59 -0500
Message-Id: <20191113020131.13356-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit e2bfa4ca23d9b5a7bdfcf21319fad9b59e38a05c ]

Clang warns when one enumerated type is converted implicitly to another:

drivers/mtd/nand/raw/sh_flctl.c:483:46: warning: implicit conversion
from enumeration type 'enum dma_transfer_direction' to different
enumeration type 'enum dma_data_direction' [-Wenum-conversion]
                flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_DEV_TO_MEM) > 0)
                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
drivers/mtd/nand/raw/sh_flctl.c:542:46: warning: implicit conversion
from enumeration type 'enum dma_transfer_direction' to different
enumeration type 'enum dma_data_direction' [-Wenum-conversion]
                flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_MEM_TO_DEV) > 0)
                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
2 warnings generated.

Use the proper enums from dma_data_direction to satisfy Clang.

DMA_MEM_TO_DEV = DMA_TO_DEVICE = 1
DMA_DEV_TO_MEM = DMA_FROM_DEVICE = 2

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/sh_flctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 1f2785ee909fe..c00a180306e50 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -428,7 +428,7 @@ static void read_fiforeg(struct sh_flctl *flctl, int rlen, int offset)
 
 	/* initiate DMA transfer */
 	if (flctl->chan_fifo0_rx && rlen >= 32 &&
-		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_DEV_TO_MEM) > 0)
+		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_FROM_DEVICE) > 0)
 			goto convert;	/* DMA success */
 
 	/* do polling transfer */
@@ -487,7 +487,7 @@ static void write_ec_fiforeg(struct sh_flctl *flctl, int rlen,
 
 	/* initiate DMA transfer */
 	if (flctl->chan_fifo0_tx && rlen >= 32 &&
-		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_MEM_TO_DEV) > 0)
+		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_TO_DEVICE) > 0)
 			return;	/* DMA success */
 
 	/* do polling transfer */
-- 
2.20.1

