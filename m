Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C474166CAA9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjAPRF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjAPRE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:04:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540883867A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF9B0B81092
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31456C433F0;
        Mon, 16 Jan 2023 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887605;
        bh=bKSewYUn7IQyc+mYJUie8YvuMUhfTTA+XTe6nKiQlCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzqB9yE4a+gRZTmxjs2ewa+6PKZYbX42j2z/IIiZ0VjYAREsbuTe223Nzw7KDySIp
         OiJfl3WhWk6OpUFEG5bN08meHqYJGir7X8KgSfs+z2Qh9OXQPxV9x7VFvMQE9oZHSt
         JCoV5XF8fClv4N249HjcymYBYbizXNPNn2hd+Z8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shardar Shariff Md <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/521] serial: tegra: add support to adjust baud rate
Date:   Mon, 16 Jan 2023 16:47:55 +0100
Message-Id: <20230116154856.699012693@linuxfoundation.org>
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

[ Upstream commit f04a3cc8d4550463e0c15be59d91177a5def1ca5 ]

Add support to adjust baud rates to fall under supported tolerance
range through DT.

Tegra186 chip has a hardware issue resulting in frame errors when
tolerance level for baud rate is negative. Provided entries to adjust
baud rate to be within acceptable range and work with devices that
can send negative baud rate. Also report error when baud rate set is
out of tolerance range of controller updated in device tree.

Signed-off-by: Shardar Shariff Md <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-11-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 68 +++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 6a3c6bf5b964..aae4c167f529 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -91,6 +91,12 @@ struct tegra_uart_chip_data {
 	int	max_dma_burst_bytes;
 };
 
+struct tegra_baud_tolerance {
+	u32 lower_range_baud;
+	u32 upper_range_baud;
+	s32 tolerance;
+};
+
 struct tegra_uart_port {
 	struct uart_port			uport;
 	const struct tegra_uart_chip_data	*cdata;
@@ -127,6 +133,8 @@ struct tegra_uart_port {
 	dma_cookie_t				rx_cookie;
 	unsigned int				tx_bytes_requested;
 	unsigned int				rx_bytes_requested;
+	struct tegra_baud_tolerance		*baud_tolerance;
+	int					n_adjustable_baud_rates;
 };
 
 static void tegra_uart_start_next_tx(struct tegra_uart_port *tup);
@@ -295,6 +303,21 @@ static void tegra_uart_fifo_reset(struct tegra_uart_port *tup, u8 fcr_bits)
 	tegra_uart_wait_cycle_time(tup, 32);
 }
 
+static long tegra_get_tolerance_rate(struct tegra_uart_port *tup,
+				     unsigned int baud, long rate)
+{
+	int i;
+
+	for (i = 0; i < tup->n_adjustable_baud_rates; ++i) {
+		if (baud >= tup->baud_tolerance[i].lower_range_baud &&
+		    baud <= tup->baud_tolerance[i].upper_range_baud)
+			return (rate + (rate *
+				tup->baud_tolerance[i].tolerance) / 10000);
+	}
+
+	return rate;
+}
+
 static int tegra_set_baudrate(struct tegra_uart_port *tup, unsigned int baud)
 {
 	unsigned long rate;
@@ -307,6 +330,9 @@ static int tegra_set_baudrate(struct tegra_uart_port *tup, unsigned int baud)
 
 	if (tup->cdata->support_clk_src_div) {
 		rate = baud * 16;
+		if (tup->n_adjustable_baud_rates)
+			rate = tegra_get_tolerance_rate(tup, baud, rate);
+
 		ret = clk_set_rate(tup->uart_clk, rate);
 		if (ret < 0) {
 			dev_err(tup->uport.dev,
@@ -1250,6 +1276,12 @@ static int tegra_uart_parse_dt(struct platform_device *pdev,
 {
 	struct device_node *np = pdev->dev.of_node;
 	int port;
+	int ret;
+	int index;
+	u32 pval;
+	int count;
+	int n_entries;
+
 
 	port = of_alias_get_id(np, "serial");
 	if (port < 0) {
@@ -1260,6 +1292,42 @@ static int tegra_uart_parse_dt(struct platform_device *pdev,
 
 	tup->enable_modem_interrupt = of_property_read_bool(np,
 					"nvidia,enable-modem-interrupt");
+	n_entries = of_property_count_u32_elems(np, "nvidia,adjust-baud-rates");
+	if (n_entries > 0) {
+		tup->n_adjustable_baud_rates = n_entries / 3;
+		tup->baud_tolerance =
+		devm_kzalloc(&pdev->dev, (tup->n_adjustable_baud_rates) *
+			     sizeof(*tup->baud_tolerance), GFP_KERNEL);
+		if (!tup->baud_tolerance)
+			return -ENOMEM;
+		for (count = 0, index = 0; count < n_entries; count += 3,
+		     index++) {
+			ret =
+			of_property_read_u32_index(np,
+						   "nvidia,adjust-baud-rates",
+						   count, &pval);
+			if (!ret)
+				tup->baud_tolerance[index].lower_range_baud =
+				pval;
+			ret =
+			of_property_read_u32_index(np,
+						   "nvidia,adjust-baud-rates",
+						   count + 1, &pval);
+			if (!ret)
+				tup->baud_tolerance[index].upper_range_baud =
+				pval;
+			ret =
+			of_property_read_u32_index(np,
+						   "nvidia,adjust-baud-rates",
+						   count + 2, &pval);
+			if (!ret)
+				tup->baud_tolerance[index].tolerance =
+				(s32)pval;
+		}
+	} else {
+		tup->n_adjustable_baud_rates = 0;
+	}
+
 	return 0;
 }
 
-- 
2.35.1



