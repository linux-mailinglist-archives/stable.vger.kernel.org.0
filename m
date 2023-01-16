Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7D266CAA6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjAPRFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbjAPREf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:04:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412B55D122
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03999B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D671C433EF;
        Mon, 16 Jan 2023 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887597;
        bh=YX3oG2m2mFjOcOVQBQxPZsaQ5W9QTQbByqB1eqV+Y7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aw2ffMV0H2iy89xUVZr9821wXBs/nqXk7N++P+TTMJA+8B82GABruyOhnY3y9JZFd
         8il0SnKZfhUV7Q+V86DiszDFlJG7B6Yt8a3wDBHHcUXFfJpejD+VOzQj3igXWafQXk
         DHO15vTIM/0zBTd51JohrrxSe0gGskXJQHOrOJk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shardar Shariff Md <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 210/521] serial: tegra: check for FIFO mode enabled status
Date:   Mon, 16 Jan 2023 16:47:52 +0100
Message-Id: <20230116154856.550539916@linuxfoundation.org>
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

[ Upstream commit 222dcdff3405a31803aecd3bf66f62d46b8bda98 ]

Chips prior to Tegra186 needed delay of 3 UART clock cycles to avoid
data loss. This issue is fixed in Tegra186 and a new flag is added to
check if FIFO mode is enabled. chip data updated to check if this flag
is available for a chip. Tegra186 has new compatible to enable this
flag.

Signed-off-by: Shardar Shariff Md <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-7-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 52 +++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index c113a0b1ece1..5408486be834 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -72,6 +72,8 @@
 #define TEGRA_TX_PIO				1
 #define TEGRA_TX_DMA				2
 
+#define TEGRA_UART_FCR_IIR_FIFO_EN		0x40
+
 /**
  * tegra_uart_chip_data: SOC specific data.
  *
@@ -84,6 +86,7 @@ struct tegra_uart_chip_data {
 	bool	tx_fifo_full_status;
 	bool	allow_txfifo_reset_fifo_mode;
 	bool	support_clk_src_div;
+	bool	fifo_mode_enable_status;
 };
 
 struct tegra_uart_port {
@@ -245,6 +248,21 @@ static void tegra_uart_wait_sym_time(struct tegra_uart_port *tup,
 			tup->current_baud));
 }
 
+static int tegra_uart_wait_fifo_mode_enabled(struct tegra_uart_port *tup)
+{
+	unsigned long iir;
+	unsigned int tmout = 100;
+
+	do {
+		iir = tegra_uart_read(tup, UART_IIR);
+		if (iir & TEGRA_UART_FCR_IIR_FIFO_EN)
+			return 0;
+		udelay(1);
+	} while (--tmout);
+
+	return -ETIMEDOUT;
+}
+
 static void tegra_uart_fifo_reset(struct tegra_uart_port *tup, u8 fcr_bits)
 {
 	unsigned long fcr = tup->fcr_shadow;
@@ -260,6 +278,8 @@ static void tegra_uart_fifo_reset(struct tegra_uart_port *tup, u8 fcr_bits)
 		tegra_uart_write(tup, fcr, UART_FCR);
 		fcr |= UART_FCR_ENABLE_FIFO;
 		tegra_uart_write(tup, fcr, UART_FCR);
+		if (tup->cdata->fifo_mode_enable_status)
+			tegra_uart_wait_fifo_mode_enabled(tup);
 	}
 
 	/* Dummy read to ensure the write is posted */
@@ -863,12 +883,20 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	/* Dummy read to ensure the write is posted */
 	tegra_uart_read(tup, UART_SCR);
 
-	/*
-	 * For all tegra devices (up to t210), there is a hardware issue that
-	 * requires software to wait for 3 UART clock periods after enabling
-	 * the TX fifo, otherwise data could be lost.
-	 */
-	tegra_uart_wait_cycle_time(tup, 3);
+	if (tup->cdata->fifo_mode_enable_status) {
+		ret = tegra_uart_wait_fifo_mode_enabled(tup);
+		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
+		if (ret < 0)
+			return ret;
+	} else {
+		/*
+		 * For all tegra devices (up to t210), there is a hardware
+		 * issue that requires software to wait for 3 UART clock
+		 * periods after enabling the TX fifo, otherwise data could
+		 * be lost.
+		 */
+		tegra_uart_wait_cycle_time(tup, 3);
+	}
 
 	/*
 	 * Initialize the UART with default configuration
@@ -1232,12 +1260,21 @@ static struct tegra_uart_chip_data tegra20_uart_chip_data = {
 	.tx_fifo_full_status		= false,
 	.allow_txfifo_reset_fifo_mode	= true,
 	.support_clk_src_div		= false,
+	.fifo_mode_enable_status	= false,
 };
 
 static struct tegra_uart_chip_data tegra30_uart_chip_data = {
 	.tx_fifo_full_status		= true,
 	.allow_txfifo_reset_fifo_mode	= false,
 	.support_clk_src_div		= true,
+	.fifo_mode_enable_status	= false,
+};
+
+static struct tegra_uart_chip_data tegra186_uart_chip_data = {
+	.tx_fifo_full_status		= true,
+	.allow_txfifo_reset_fifo_mode	= false,
+	.support_clk_src_div		= true,
+	.fifo_mode_enable_status	= true,
 };
 
 static const struct of_device_id tegra_uart_of_match[] = {
@@ -1247,6 +1284,9 @@ static const struct of_device_id tegra_uart_of_match[] = {
 	}, {
 		.compatible	= "nvidia,tegra20-hsuart",
 		.data		= &tegra20_uart_chip_data,
+	}, {
+		.compatible     = "nvidia,tegra186-hsuart",
+		.data		= &tegra186_uart_chip_data,
 	}, {
 	},
 };
-- 
2.35.1



