Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBE966CAA5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjAPRFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbjAPRES (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:04:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DCF5D109
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DDF5B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB95FC433D2;
        Mon, 16 Jan 2023 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887595;
        bh=Gs4EHS7OKBi1zaE9jA1U/E2h8za93rQpnt3j6Uz0xgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdG3Q3kvlKz040R5K6Dm7swVoyuqO9yyFj3XIbEWYjtIVcIUf7O9KwQ2+e2fqmv+A
         ApkHeJWVTFVyCL7JnVuGj2qHZCnpm+XC5wFPQL36ASTZ4TdTDBd1fmzpceLLsSfUoq
         Ak1wnhRqps4bID4oKq28x//4xPfb/tCeij6eLSxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ahung Cheng <ahcheng@nvidia.com>,
        Shardar Mohammed <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/521] serial: tegra: avoid reg access when clk disabled
Date:   Mon, 16 Jan 2023 16:47:51 +0100
Message-Id: <20230116154856.501068374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Ahung Cheng <ahcheng@nvidia.com>

[ Upstream commit 494f79bd2365703e4093efa0ecf4b139d83aba97 ]

This avoids two race conditions from the UART shutdown sequence both
leading to 'Machine check error in AXI2APB' and kernel oops.

One was that the clock was disabled before the DMA was terminated making
it possible for the DMA callbacks to be called after the clock was
disabled. These callbacks could write to the UART registers causing
timeout.

The second was that the clock was disabled before the UART was
completely flagged as closed. This is done after the shutdown is called
and a new write could be started after the clock was disabled.
tegra_uart_start_pio_tx could be called causing timeout.

Given that the baud rate is reset at the end of shutdown sequence, this
fix is to examine the baud rate to avoid register access from both race
conditions.

Besides, terminate the DMA before disabling the clock.

Signed-off-by: Ahung Cheng <ahcheng@nvidia.com>
Signed-off-by: Shardar Mohammed <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-3-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index ee480a1480e8..c113a0b1ece1 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -126,6 +126,8 @@ struct tegra_uart_port {
 
 static void tegra_uart_start_next_tx(struct tegra_uart_port *tup);
 static int tegra_uart_start_rx_dma(struct tegra_uart_port *tup);
+static void tegra_uart_dma_channel_free(struct tegra_uart_port *tup,
+					bool dma_to_memory);
 
 static inline unsigned long tegra_uart_read(struct tegra_uart_port *tup,
 		unsigned long reg)
@@ -440,6 +442,9 @@ static void tegra_uart_start_next_tx(struct tegra_uart_port *tup)
 	unsigned long count;
 	struct circ_buf *xmit = &tup->uport.state->xmit;
 
+	if (!tup->current_baud)
+		return;
+
 	tail = (unsigned long)&xmit->buf[xmit->tail];
 	count = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 	if (!count)
@@ -803,6 +808,12 @@ static void tegra_uart_hw_deinit(struct tegra_uart_port *tup)
 	tup->current_baud = 0;
 	spin_unlock_irqrestore(&tup->uport.lock, flags);
 
+	tup->rx_in_progress = 0;
+	tup->tx_in_progress = 0;
+
+	tegra_uart_dma_channel_free(tup, true);
+	tegra_uart_dma_channel_free(tup, false);
+
 	clk_disable_unprepare(tup->uart_clk);
 }
 
@@ -1040,12 +1051,6 @@ static void tegra_uart_shutdown(struct uart_port *u)
 	struct tegra_uart_port *tup = to_tegra_uport(u);
 
 	tegra_uart_hw_deinit(tup);
-
-	tup->rx_in_progress = 0;
-	tup->tx_in_progress = 0;
-
-	tegra_uart_dma_channel_free(tup, true);
-	tegra_uart_dma_channel_free(tup, false);
 	free_irq(u->irq, tup);
 }
 
-- 
2.35.1



