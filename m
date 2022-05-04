Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E416A51A77F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355333AbiEDRGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356074AbiEDREw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381845007F;
        Wed,  4 May 2022 09:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D107FB8278E;
        Wed,  4 May 2022 16:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FFAC385AA;
        Wed,  4 May 2022 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683223;
        bh=zDziTLnsss2snsLkpWMuxnhSovQWKHnxQj50ZFeHjpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0KxEvr9E0QHfWQN/4U/lLrgNADzrOK+dSsf5wC4IeTZ020hvVuz6C+4nSUC/WcCT
         N8RJbOJQ7WRuLnVAFJA18sYJmwrOZSWdsCk67DQ11Rq5R529OKGQdzE+7Miy+IW0Vd
         cigBihkuZkONZatMtei5j6cQtJP8n/WKCCxhCS/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/177] mtd: rawnand: Fix return value check of wait_for_completion_timeout
Date:   Wed,  4 May 2022 18:44:29 +0200
Message-Id: <20220504153059.888618092@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 084c16ab423a8890121b902b405823bfec5b4365 ]

wait_for_completion_timeout() returns unsigned long not int.
It returns 0 if timed out, and positive if completed.
The check for <= 0 is ambiguous and should be == 0 here
indicating timeout which is the only error case.

Fixes: 83738d87e3a0 ("mtd: sh_flctl: Add DMA capabilty")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220412083435.29254-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sh_flctl.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/raw/sh_flctl.c b/drivers/mtd/nand/raw/sh_flctl.c
index 13df4bdf792a..8f89e2d3d817 100644
--- a/drivers/mtd/nand/raw/sh_flctl.c
+++ b/drivers/mtd/nand/raw/sh_flctl.c
@@ -384,7 +384,8 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl *flctl, unsigned long *buf,
 	dma_addr_t dma_addr;
 	dma_cookie_t cookie;
 	uint32_t reg;
-	int ret;
+	int ret = 0;
+	unsigned long time_left;
 
 	if (dir == DMA_FROM_DEVICE) {
 		chan = flctl->chan_fifo0_rx;
@@ -425,13 +426,14 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl *flctl, unsigned long *buf,
 		goto out;
 	}
 
-	ret =
+	time_left =
 	wait_for_completion_timeout(&flctl->dma_complete,
 				msecs_to_jiffies(3000));
 
-	if (ret <= 0) {
+	if (time_left == 0) {
 		dmaengine_terminate_all(chan);
 		dev_err(&flctl->pdev->dev, "wait_for_completion_timeout\n");
+		ret = -ETIMEDOUT;
 	}
 
 out:
@@ -441,7 +443,7 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl *flctl, unsigned long *buf,
 
 	dma_unmap_single(chan->device->dev, dma_addr, len, dir);
 
-	/* ret > 0 is success */
+	/* ret == 0 is success */
 	return ret;
 }
 
@@ -465,7 +467,7 @@ static void read_fiforeg(struct sh_flctl *flctl, int rlen, int offset)
 
 	/* initiate DMA transfer */
 	if (flctl->chan_fifo0_rx && rlen >= 32 &&
-		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_FROM_DEVICE) > 0)
+		!flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_FROM_DEVICE))
 			goto convert;	/* DMA success */
 
 	/* do polling transfer */
@@ -524,7 +526,7 @@ static void write_ec_fiforeg(struct sh_flctl *flctl, int rlen,
 
 	/* initiate DMA transfer */
 	if (flctl->chan_fifo0_tx && rlen >= 32 &&
-		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_TO_DEVICE) > 0)
+		!flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_TO_DEVICE))
 			return;	/* DMA success */
 
 	/* do polling transfer */
-- 
2.35.1



