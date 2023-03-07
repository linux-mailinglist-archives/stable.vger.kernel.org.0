Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A346AEFA6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjCGSZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjCGSYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694D97A937
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F196061537
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA47C4339B;
        Tue,  7 Mar 2023 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213204;
        bh=0pE87RiyZMep/b+1Fh5ZG2RRKfHzq6oBN7PTl9rMKXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+PX0WQlUS+aMrxbczWifK2yFwk6GzTnPP9txmBhQC69v1RZHheL11FUrKYHLnXeX
         w1d5VzV7HMps8+Ex7NxRTlrDDC0WMB2P0hjisxnjbCzDjSV2Qpkmf7kHw872OWWk46
         NBJDVhraAm2RqpBB25Z7Ep8GTKfEonbPZ62LKzWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi Yang <yiyang13@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 432/885] serial: tegra: Add missing clk_disable_unprepare() in tegra_uart_hw_init()
Date:   Tue,  7 Mar 2023 17:56:06 +0100
Message-Id: <20230307170021.188253087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 38f28cfe9d08e3a47ef008798b275fef8118fc20 ]

Add the missing clk_disable_unprepare() before return from
tegra_uart_hw_init() in the error handling path.
When request_irq() fails in tegra_uart_startup(), 'tup->uart_clk'
has been enabled, fix it by adding clk_disable_unprepare().

Fixes: cc9ca4d95846 ("serial: tegra: Only print FIFO error message when an error occurs")
Fixes: d781ec21bae6 ("serial: tegra: report clk rate errors")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Link: https://lore.kernel.org/r/20221126020852.113378-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index cda9cd4fa92c8..c08360212aa20 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1047,6 +1047,7 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
 		if (ret < 0) {
+			clk_disable_unprepare(tup->uart_clk);
 			dev_err(tup->uport.dev,
 				"Failed to enable FIFO mode: %d\n", ret);
 			return ret;
@@ -1068,6 +1069,7 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 */
 	ret = tegra_set_baudrate(tup, TEGRA_UART_DEFAULT_BAUD);
 	if (ret < 0) {
+		clk_disable_unprepare(tup->uart_clk);
 		dev_err(tup->uport.dev, "Failed to set baud rate\n");
 		return ret;
 	}
@@ -1227,10 +1229,13 @@ static int tegra_uart_startup(struct uart_port *u)
 				dev_name(u->dev), tup);
 	if (ret < 0) {
 		dev_err(u->dev, "Failed to register ISR for IRQ %d\n", u->irq);
-		goto fail_hw_init;
+		goto fail_request_irq;
 	}
 	return 0;
 
+fail_request_irq:
+	/* tup->uart_clk is already enabled in tegra_uart_hw_init */
+	clk_disable_unprepare(tup->uart_clk);
 fail_hw_init:
 	if (!tup->use_rx_pio)
 		tegra_uart_dma_channel_free(tup, true);
-- 
2.39.2



