Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432435870EC
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiHATFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiHATEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:04:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0AE402CC;
        Mon,  1 Aug 2022 12:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B4EA61227;
        Mon,  1 Aug 2022 19:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45337C433D6;
        Mon,  1 Aug 2022 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380589;
        bh=d/iGv3GxcSHuxsO3Syz/ugha7MoQ9UUrS+dhzXkqnuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usQY6CkEjKhkql7+wU8XT0ztMsMdP+K6t1QV5NVYJu3GBUi/sNjWF5p0iIILLnJ86
         kV+rIg/s+RKjCvScIfW37JLiRXlMJsB9ivoVLvSj40fawH9PCLQ7hgX0PtE3pl0Xfu
         VQRg4E6ICD/T+OpYOoq88ny7P02ZvjIiw/jyEeVFpDTQz6qFc7jSqyPm6WUWraCgxy
         x7k6yidd2xtJRYoJR7NdveEHXBu4pxJBfHTar7MG2ymer5dQO+DpV19XrJV/651rlr
         ODu3d/JvgMJ0fdDknRKHL29f0kcmACfbyj0ZHM/gOGEwpmJ7XwCLiXizUnAKvYM3+m
         MpTml4fglUMdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/7] spi: spi-rspi: Fix PIO fallback on RZ platforms
Date:   Mon,  1 Aug 2022 15:02:57 -0400
Message-Id: <20220801190301.3819065-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190301.3819065-1-sashal@kernel.org>
References: <20220801190301.3819065-1-sashal@kernel.org>
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
index ea03cc589e61..4600e3c9e49e 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -612,6 +612,10 @@ static int rspi_dma_transfer(struct rspi_data *rspi, struct sg_table *tx,
 					       rspi->dma_callbacked, HZ);
 	if (ret > 0 && rspi->dma_callbacked) {
 		ret = 0;
+		if (tx)
+			dmaengine_synchronize(rspi->ctlr->dma_tx);
+		if (rx)
+			dmaengine_synchronize(rspi->ctlr->dma_rx);
 	} else {
 		if (!ret) {
 			dev_err(&rspi->ctlr->dev, "DMA timeout\n");
-- 
2.35.1

