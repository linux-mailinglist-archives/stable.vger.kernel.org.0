Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3446587123
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiHATHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbiHATHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:07:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49B24505C;
        Mon,  1 Aug 2022 12:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4971B8163F;
        Mon,  1 Aug 2022 19:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB616C4347C;
        Mon,  1 Aug 2022 19:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380643;
        bh=XCpuFYrf2qOm988WctfaO0Xv4CmAKWB8AYzNBTYtKiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buMeXIzBjHCrNFEmkH2PEunNus2Zip681B9lS0y+AXeEqfxDyEcLULXJNj7v6ZfqC
         X5/AXS5L3LODY+EwwJN8XgTTmEF5jKn5FsFo/KluCJolvZkyQtDx26NlABSEKYLT7x
         /OocNHgvh+lCNFhC4ccDT8zgLjBCcioPo84TwsroD5bZgFAzsrqNScqtsCE6U76lKA
         14tkE4E56VOXGh+zsfURoKDHksfVhB3yXVQenWJdJiAb1F1eCLR5Cd261w2DtgdnXo
         bxBRO2IYM6urEPJe6D9jYWL23WlCsdXaHHLsTEQYrCKVePSpXwsfunJMhHeqoiQnNy
         DNngs5IdF0Vbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/3] spi: spi-rspi: Fix PIO fallback on RZ platforms
Date:   Mon,  1 Aug 2022 15:03:57 -0400
Message-Id: <20220801190359.3820214-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190359.3820214-1-sashal@kernel.org>
References: <20220801190359.3820214-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit b620aa3a7be346f04ae7789b165937615c6ee8d3 ]

RSPI IP on RZ/{A, G2L} SoC's has the same signal for both interrupt
and DMA transfer request. Setting DMARS register for DMA transfer
makes the signal to work as a DMA transfer request signal and
subsequent interrupt requests to the interrupt controller
are masked.

PIO fallback does not work as interrupt signal is disabled.

This patch fixes this issue by re-enabling the interrupts by
calling dmaengine_synchronize().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220721143449.879257-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 07612e8c58ee..9142629b5f8d 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -602,6 +602,10 @@ static int rspi_dma_transfer(struct rspi_data *rspi, struct sg_table *tx,
 					       rspi->dma_callbacked, HZ);
 	if (ret > 0 && rspi->dma_callbacked) {
 		ret = 0;
+		if (tx)
+			dmaengine_synchronize(rspi->ctlr->dma_tx);
+		if (rx)
+			dmaengine_synchronize(rspi->ctlr->dma_rx);
 	} else {
 		if (!ret) {
 			dev_err(&rspi->master->dev, "DMA timeout\n");
-- 
2.35.1

