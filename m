Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD11C5405AF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346517AbiFGR3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346514AbiFGR2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:28:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094A71157CB;
        Tue,  7 Jun 2022 10:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D9D60906;
        Tue,  7 Jun 2022 17:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC335C385A5;
        Tue,  7 Jun 2022 17:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622664;
        bh=1vuZle/aJdf8IXFfMGotKYrT8HQrM8syeDFZeWAjPJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGu+foy4QfitlcHvl1N2W/rMnJk1x6L1xYtvmLlW9sqR+8sr562glPGpFomofbDbx
         ltjZ1rk6USCE1D/Ik0d+g+0lik8fXqzs4uxdRlEldICWp1wipE0scKofLbmovCSRrT
         pFP01huG+Onn/s5ZxZgNBaDDcgXitDOrY31MeyPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/452] spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout
Date:   Tue,  7 Jun 2022 18:59:57 +0200
Message-Id: <20220607164912.731402210@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index e06aafe169e0..081da1fd3fd7 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -448,6 +448,7 @@ static int ti_qspi_dma_xfer(struct ti_qspi *qspi, dma_addr_t dma_dst,
 	enum dma_ctrl_flags flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 	struct dma_async_tx_descriptor *tx;
 	int ret;
+	unsigned long time_left;
 
 	tx = dmaengine_prep_dma_memcpy(chan, dma_dst, dma_src, len, flags);
 	if (!tx) {
@@ -467,9 +468,9 @@ static int ti_qspi_dma_xfer(struct ti_qspi *qspi, dma_addr_t dma_dst,
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



