Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0A25409B5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349919AbiFGSMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350398AbiFGSK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:10:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76DA85EE4;
        Tue,  7 Jun 2022 10:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F7E6170B;
        Tue,  7 Jun 2022 17:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D01C385A5;
        Tue,  7 Jun 2022 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624115;
        bh=1vuZle/aJdf8IXFfMGotKYrT8HQrM8syeDFZeWAjPJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JE/s9n8ku4iH2M2l4FoDRbSNvnr0rHdOsQYvpI2b2rbKjcf2AMFqZHDGpIDAb87fh
         NgXnsEVjg/TceGDMAkp0G3dcrR/jwflJVe06gkuiyN7F274VgaIeQZO9Dp2/uf+7Ej
         ZQUR8pfyTZvtN0cKUQLedcZl5pvgon9AeOfZDlK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/667] spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout
Date:   Tue,  7 Jun 2022 18:57:54 +0200
Message-Id: <20220607164941.066387237@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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



