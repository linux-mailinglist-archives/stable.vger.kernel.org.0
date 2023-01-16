Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A56C66CAAA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbjAPRFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjAPRFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:05:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877255D139
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C35DB81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFEEC433D2;
        Mon, 16 Jan 2023 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887608;
        bh=SzzpCuY2JzoB5lQBTZTMxKNAvtAAKnX+907JGjk5odA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=roCsyK+eaOcG/90TG96OrGh+dF8pH9gjleRNkeX2oBmQX68LEsycbjzEee5CdhK4t
         ehRN3Mrc3anJzCCaLExkF85S0pX8s+tDvxumgRvE9Siqar0FZNE86VBwnubgoEWDXH
         rbpd63PE+zgP1UgFZkmVBWvPHdtKJ+TIoUJGR/wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shardar Shariff Md <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 214/521] serial: tegra: report clk rate errors
Date:   Mon, 16 Jan 2023 16:47:56 +0100
Message-Id: <20230116154856.733983653@linuxfoundation.org>
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

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit d781ec21bae6ff8f9e07682e8947a654484611f5 ]

Standard UART controllers support +/-4% baud rate error tolerance.
Tegra186 only supports 0% to +4% error tolerance whereas other Tegra
chips support standard +/-4% rate. Add chip data for knowing error
tolerance level for each soc. Creating new compatible for Tegra194
chip as it supports baud rate error tolerance of -2 to +2%, different
from older chips.

Signed-off-by: Shardar Shariff Md <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-12-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 59 +++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index aae4c167f529..e11d19742cf6 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -89,6 +89,8 @@ struct tegra_uart_chip_data {
 	bool	fifo_mode_enable_status;
 	int	uart_max_port;
 	int	max_dma_burst_bytes;
+	int	error_tolerance_low_range;
+	int	error_tolerance_high_range;
 };
 
 struct tegra_baud_tolerance {
@@ -135,6 +137,8 @@ struct tegra_uart_port {
 	unsigned int				rx_bytes_requested;
 	struct tegra_baud_tolerance		*baud_tolerance;
 	int					n_adjustable_baud_rates;
+	int					required_rate;
+	int					configured_rate;
 };
 
 static void tegra_uart_start_next_tx(struct tegra_uart_port *tup);
@@ -318,6 +322,22 @@ static long tegra_get_tolerance_rate(struct tegra_uart_port *tup,
 	return rate;
 }
 
+static int tegra_check_rate_in_range(struct tegra_uart_port *tup)
+{
+	long diff;
+
+	diff = ((long)(tup->configured_rate - tup->required_rate) * 10000)
+		/ tup->required_rate;
+	if (diff < (tup->cdata->error_tolerance_low_range * 100) ||
+	    diff > (tup->cdata->error_tolerance_high_range * 100)) {
+		dev_err(tup->uport.dev,
+			"configured baud rate is out of range by %ld", diff);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int tegra_set_baudrate(struct tegra_uart_port *tup, unsigned int baud)
 {
 	unsigned long rate;
@@ -330,6 +350,8 @@ static int tegra_set_baudrate(struct tegra_uart_port *tup, unsigned int baud)
 
 	if (tup->cdata->support_clk_src_div) {
 		rate = baud * 16;
+		tup->required_rate = rate;
+
 		if (tup->n_adjustable_baud_rates)
 			rate = tegra_get_tolerance_rate(tup, baud, rate);
 
@@ -339,7 +361,11 @@ static int tegra_set_baudrate(struct tegra_uart_port *tup, unsigned int baud)
 				"clk_set_rate() failed for rate %lu\n", rate);
 			return ret;
 		}
+		tup->configured_rate = clk_get_rate(tup->uart_clk);
 		divisor = 1;
+		ret = tegra_check_rate_in_range(tup);
+		if (ret < 0)
+			return ret;
 	} else {
 		rate = clk_get_rate(tup->uart_clk);
 		divisor = DIV_ROUND_CLOSEST(rate, baud * 16);
@@ -937,7 +963,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 * enqueued
 	 */
 	tup->lcr_shadow = TEGRA_UART_DEFAULT_LSR;
-	tegra_set_baudrate(tup, TEGRA_UART_DEFAULT_BAUD);
+	ret = tegra_set_baudrate(tup, TEGRA_UART_DEFAULT_BAUD);
+	if (ret < 0) {
+		dev_err(tup->uport.dev, "Failed to set baud rate\n");
+		return ret;
+	}
 	tup->fcr_shadow |= UART_FCR_DMA_SELECT;
 	tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
 
@@ -1136,6 +1166,7 @@ static void tegra_uart_set_termios(struct uart_port *u,
 	struct clk *parent_clk = clk_get_parent(tup->uart_clk);
 	unsigned long parent_clk_rate = clk_get_rate(parent_clk);
 	int max_divider = (tup->cdata->support_clk_src_div) ? 0x7FFF : 0xFFFF;
+	int ret;
 
 	max_divider *= 16;
 	spin_lock_irqsave(&u->lock, flags);
@@ -1208,7 +1239,11 @@ static void tegra_uart_set_termios(struct uart_port *u,
 			parent_clk_rate/max_divider,
 			parent_clk_rate/16);
 	spin_unlock_irqrestore(&u->lock, flags);
-	tegra_set_baudrate(tup, baud);
+	ret = tegra_set_baudrate(tup, baud);
+	if (ret < 0) {
+		dev_err(tup->uport.dev, "Failed to set baud rate\n");
+		return;
+	}
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
 	spin_lock_irqsave(&u->lock, flags);
@@ -1338,6 +1373,8 @@ static struct tegra_uart_chip_data tegra20_uart_chip_data = {
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
+	.error_tolerance_low_range	= 0,
+	.error_tolerance_high_range	= 4,
 };
 
 static struct tegra_uart_chip_data tegra30_uart_chip_data = {
@@ -1347,6 +1384,8 @@ static struct tegra_uart_chip_data tegra30_uart_chip_data = {
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
+	.error_tolerance_low_range	= 0,
+	.error_tolerance_high_range	= 4,
 };
 
 static struct tegra_uart_chip_data tegra186_uart_chip_data = {
@@ -1356,6 +1395,19 @@ static struct tegra_uart_chip_data tegra186_uart_chip_data = {
 	.fifo_mode_enable_status	= true,
 	.uart_max_port			= 8,
 	.max_dma_burst_bytes		= 8,
+	.error_tolerance_low_range	= 0,
+	.error_tolerance_high_range	= 4,
+};
+
+static struct tegra_uart_chip_data tegra194_uart_chip_data = {
+	.tx_fifo_full_status		= true,
+	.allow_txfifo_reset_fifo_mode	= false,
+	.support_clk_src_div		= true,
+	.fifo_mode_enable_status	= true,
+	.uart_max_port			= 8,
+	.max_dma_burst_bytes		= 8,
+	.error_tolerance_low_range	= -2,
+	.error_tolerance_high_range	= 2,
 };
 
 static const struct of_device_id tegra_uart_of_match[] = {
@@ -1368,6 +1420,9 @@ static const struct of_device_id tegra_uart_of_match[] = {
 	}, {
 		.compatible     = "nvidia,tegra186-hsuart",
 		.data		= &tegra186_uart_chip_data,
+	}, {
+		.compatible     = "nvidia,tegra194-hsuart",
+		.data		= &tegra194_uart_chip_data,
 	}, {
 	},
 };
-- 
2.35.1



