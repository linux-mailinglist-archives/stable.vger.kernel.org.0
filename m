Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8663354901A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbiFMKSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241671AbiFMKRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:17:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349CBD12A;
        Mon, 13 Jun 2022 03:15:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0EC32CE1109;
        Mon, 13 Jun 2022 10:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24ACC3411C;
        Mon, 13 Jun 2022 10:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115338;
        bh=9I/GjD4aHksi/15bfsartGYolBCbeN+8cPg/9xg+7aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNOJyc7jRSotwyXAB4CG+dm5lGmimGViMiHBzqj3Yy+z2zO9zjWe4Dj+AOpzrjVqX
         r5d52RcvbfH2ZRB1mRigH6vPl16IIuKAOK5Y0BbnlkeHgSG1+MO0/xo76R8XZfbLmk
         Atn8Xz34NCE6xROsmkNAIGrcMPQ+lm3BfPvw2HHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 040/167] spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout
Date:   Mon, 13 Jun 2022 12:08:34 +0200
Message-Id: <20220613094850.290100819@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8b1ea69a63eb62f97cef63e6d816b64ed84e8760 ]

wait_for_completion_timeout() returns unsigned long not int.
It returns 0 if timed out, and positive if completed.
The check for <= 0 is ambiguous and should be == 0 here
indicating timeout which is the only error case.

Fixes: 5720ec0a6d26 ("spi: spi-ti-qspi: Add DMA support for QSPI mmap read")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220411111034.24447-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ti-qspi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index b0a5486936c0..0b0f69551da0 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -401,6 +401,7 @@ static int ti_qspi_dma_xfer(struct ti_qspi *qspi, dma_addr_t dma_dst,
 	enum dma_ctrl_flags flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 	struct dma_async_tx_descriptor *tx;
 	int ret;
+	unsigned long time_left;
 
 	tx = dma_dev->device_prep_dma_memcpy(chan, dma_dst, dma_src,
 					     len, flags);
@@ -420,9 +421,9 @@ static int ti_qspi_dma_xfer(struct ti_qspi *qspi, dma_addr_t dma_dst,
 	}
 
 	dma_async_issue_pending(chan);
-	ret = wait_for_completion_timeout(&qspi->transfer_complete,
+	time_left = wait_for_completion_timeout(&qspi->transfer_complete,
 					  msecs_to_jiffies(len));
-	if (ret <= 0) {
+	if (time_left == 0) {
 		dmaengine_terminate_sync(chan);
 		dev_err(qspi->dev, "DMA wait_for_completion_timeout\n");
 		return -ETIMEDOUT;
-- 
2.35.1



