Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90E64317B
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiLETPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbiLETOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:14:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2B41F2FD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35391CE13A6
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26056C433C1;
        Mon,  5 Dec 2022 19:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267679;
        bh=azR+UGpNMZu1AePQRPQhuVshd/dae+Vk3Ued6p+RAhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyfP9zNvbu644OnhE7xreAzdUn/7wKvUZFbslgUMP37anhjEYFls9OTelcNVPqYnJ
         ezxdTcq4Tbr7oK/vcZ8OAwICAtl9um/k1QyhVcbjZYmQiJLaZ8XG+GCzV9gAdEmUOP
         SvWQ8seJeIJKeC4FcG5XZMMVmRn40Au+/CEqtgLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Nyekjaer <sean@geanix.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/77] spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run
Date:   Mon,  5 Dec 2022 20:08:55 +0100
Message-Id: <20221205190801.022993920@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c8e546439fff..87502f39bc4f 100644
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



