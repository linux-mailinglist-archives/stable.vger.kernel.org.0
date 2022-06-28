Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DC755D3ED
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243881AbiF1CWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243878AbiF1CWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:22:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AE724BFB;
        Mon, 27 Jun 2022 19:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8D57CE1BD3;
        Tue, 28 Jun 2022 02:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A40C36AF2;
        Tue, 28 Jun 2022 02:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382912;
        bh=NiB08PHBrGbxEHA9x3A6NC5XZ6j/Z0J8wAaPOiplP7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/A5hOL4GTXKlaAdwHaizBhDbsAM30pqAkshQMeO3mC+37AYm6vWx7IWqcu1p0jm0
         2pKtfKqix53ahdJWcGHqExN7+EKvBTUWyIofCEGAt2h+Xbl0vAEN0uvZbXZBiv/nHX
         PlJPF8O+DZfNqvYKdHfERQxJslQwaxIPuHS5TerWZYI/qcahpJ1bvZeBNGB+nVJDsB
         cGaL+bT3tbyIr5Xfu/EeqSBORfy0+lD3TotTX8ZO9ipPRewLIYwVmSpko+6iFgTvhs
         cMXLyN8wti8WP3g5yEj9WiSVGuczGmcgXSHyF30gXgsQG0UTL0+Jb/3dfPFKiNLJ88
         NA9l5F/WyhU6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Lin <jon.lin@rock-chips.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 19/41] spi: rockchip: Unmask IRQ at the final to avoid preemption
Date:   Mon, 27 Jun 2022 22:20:38 -0400
Message-Id: <20220628022100.595243-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Lin <jon.lin@rock-chips.com>

[ Upstream commit 419bc8f681a0dc63588cee693b6d45e7caa6006c ]

Avoid pio_write process is preempted, resulting in abnormal state.

Signed-off-by: Jon Lin <jon.lin@rock-chips.com>
Signed-off-by: Jon <jon.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20220617124251.5051-1-jon.lin@rock-chips.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index b721b62118e1..7880a4f25284 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -380,15 +380,18 @@ static int rockchip_spi_prepare_irq(struct rockchip_spi *rs,
 	rs->tx_left = rs->tx ? xfer->len / rs->n_bytes : 0;
 	rs->rx_left = xfer->len / rs->n_bytes;
 
-	if (rs->cs_inactive)
-		writel_relaxed(INT_RF_FULL | INT_CS_INACTIVE, rs->regs + ROCKCHIP_SPI_IMR);
-	else
-		writel_relaxed(INT_RF_FULL, rs->regs + ROCKCHIP_SPI_IMR);
+	writel_relaxed(0xffffffff, rs->regs + ROCKCHIP_SPI_ICR);
+
 	spi_enable_chip(rs, true);
 
 	if (rs->tx_left)
 		rockchip_spi_pio_writer(rs);
 
+	if (rs->cs_inactive)
+		writel_relaxed(INT_RF_FULL | INT_CS_INACTIVE, rs->regs + ROCKCHIP_SPI_IMR);
+	else
+		writel_relaxed(INT_RF_FULL, rs->regs + ROCKCHIP_SPI_IMR);
+
 	/* 1 means the transfer is in progress */
 	return 1;
 }
-- 
2.35.1

