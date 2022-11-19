Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F29B630A8B
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbiKSC1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKSC0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:26:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247516DFF1;
        Fri, 18 Nov 2022 18:16:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5577624B7;
        Sat, 19 Nov 2022 02:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D82CC433B5;
        Sat, 19 Nov 2022 02:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824177;
        bh=w9KGRntzBkhBwrHXOH/VZK9iq0Ck1XmrFUPD30d801w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlDbsQgoPjxDtGH7IEM89y6b3eFg7jGGg9/bwajLww3CtgT/6zfKSt/WlqXAWhOCZ
         dH7/JBWjS5sZCuxzML9ZWbnHUPEc5r6I0pyixJu45uUdJcw1huyVnFxjo8W4v1E85L
         11+UUdfh/qiwLbQRHGy97tbfo0ebjU4qxtDfVADyeKIO2D/8wPC9oZTV8uP5vjMfYr
         1GAmAqKHpJBskWa9URejgX5kJ/oYPaD4OIj/5XdiUmJE1BHL2+QtPDRyzlNNoB/fOT
         xymIHvSIsz+p9DQrE5tPdkezUDjIKkfGt2kdbdWKffUZ8WxIMPkAnCJurVw5yWO6jF
         zRsKL4c461UfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alain.volmat@foss.st.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 4/8] spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run
Date:   Fri, 18 Nov 2022 21:16:05 -0500
Message-Id: <20221119021610.1775469-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021610.1775469-1-sashal@kernel.org>
References: <20221119021610.1775469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 62aa1a344b0904549f6de7af958e8a1136fd5228 ]

When this driver is used with a driver that uses preallocated spi_transfer
structs. The speed_hz is halved by every run. This results in:

spi_stm32 44004000.spi: SPI transfer setup failed
ads7846 spi0.0: SPI transfer failed: -22

Example when running with DIV_ROUND_UP():
- First run; speed_hz = 1000000, spi->clk_rate 125000000
  div 125 -> mbrdiv = 7, cur_speed = 976562
- Second run; speed_hz = 976562
  div 128,00007 (roundup to 129) -> mbrdiv = 8, cur_speed = 488281
- Third run; speed_hz = 488281
  div 256,000131072067109 (roundup to 257) and then -EINVAL is returned.

Use DIV_ROUND_CLOSEST to allow to round down and allow us to keep the
set speed.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20221103080043.3033414-1-sean@geanix.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 8d692f16d90a..b8565da54a72 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -255,7 +255,7 @@ static int stm32_spi_prepare_mbr(struct stm32_spi *spi, u32 speed_hz)
 	u32 div, mbrdiv;
 
 	/* Ensure spi->clk_rate is even */
-	div = DIV_ROUND_UP(spi->clk_rate & ~0x1, speed_hz);
+	div = DIV_ROUND_CLOSEST(spi->clk_rate & ~0x1, speed_hz);
 
 	/*
 	 * SPI framework set xfer->speed_hz to master->max_speed_hz if
-- 
2.35.1

