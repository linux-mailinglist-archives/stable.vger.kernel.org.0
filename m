Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD546357ED
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbiKWJs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238149AbiKWJsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D709FAE96
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE32061B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48A7C433D6;
        Wed, 23 Nov 2022 09:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196702;
        bh=QOE/lVvYRjvkcYT8oPVwm5W2CV7Y2dJ7oewrDFmfHBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXef5gNaakdGS6fGriiDAiCeRyxft3unLKhYzA+HFe61uif1VZ6DoiHD0e2yvpxe+
         HnXy0IP0vPlfL8jeG/oA+TmfLGUKsUz6bgTepp53MBEyGM9EVz2liPGWBFQVC5Xz1N
         rgjkNq5/3/oOPE/Rw1uvLyrmMxePVygLkdGBpk+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 099/314] tty: serial: fsl_lpuart: dont break the on-going transfer when global reset
Date:   Wed, 23 Nov 2022 09:49:04 +0100
Message-Id: <20221123084629.983820576@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 76bad3f88750f8cc465c489e6846249e0bc3d8f5 ]

lpuart_global_reset() shouldn't break the on-going transmit engine, need
to recover the on-going data transfer after reset.

This can help earlycon here, since commit 60f361722ad2 ("serial:
fsl_lpuart: Reset prior to registration") moved lpuart_global_reset()
before uart_add_one_port(), earlycon is writing during global reset,
as global reset will disable the TX and clear the baud rate register,
which caused the earlycon cannot work any more after reset, needs to
restore the baud rate and re-enable the transmitter to recover the
earlycon write.

Also move the lpuart_global_reset() down, then we can reuse the
lpuart32_tx_empty() without declaration.

Fixes: bd5305dcabbc ("tty: serial: fsl_lpuart: do software reset for imx7ulp and imx8qxp")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221024085844.22786-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 76 +++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 34990901c805..c8297102e087 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -12,6 +12,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -404,33 +405,6 @@ static unsigned int lpuart_get_baud_clk_rate(struct lpuart_port *sport)
 #define lpuart_enable_clks(x)	__lpuart_enable_clks(x, true)
 #define lpuart_disable_clks(x)	__lpuart_enable_clks(x, false)
 
-static int lpuart_global_reset(struct lpuart_port *sport)
-{
-	struct uart_port *port = &sport->port;
-	void __iomem *global_addr;
-	int ret;
-
-	if (uart_console(port))
-		return 0;
-
-	ret = clk_prepare_enable(sport->ipg_clk);
-	if (ret) {
-		dev_err(sport->port.dev, "failed to enable uart ipg clk: %d\n", ret);
-		return ret;
-	}
-
-	if (is_imx7ulp_lpuart(sport) || is_imx8qxp_lpuart(sport)) {
-		global_addr = port->membase + UART_GLOBAL - IMX_REG_OFF;
-		writel(UART_GLOBAL_RST, global_addr);
-		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
-		writel(0, global_addr);
-		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
-	}
-
-	clk_disable_unprepare(sport->ipg_clk);
-	return 0;
-}
-
 static void lpuart_stop_tx(struct uart_port *port)
 {
 	unsigned char temp;
@@ -2641,6 +2615,54 @@ static const struct serial_rs485 lpuart_rs485_supported = {
 	/* delay_rts_* and RX_DURING_TX are not supported */
 };
 
+static int lpuart_global_reset(struct lpuart_port *sport)
+{
+	struct uart_port *port = &sport->port;
+	void __iomem *global_addr;
+	unsigned long ctrl, bd;
+	unsigned int val = 0;
+	int ret;
+
+	ret = clk_prepare_enable(sport->ipg_clk);
+	if (ret) {
+		dev_err(sport->port.dev, "failed to enable uart ipg clk: %d\n", ret);
+		return ret;
+	}
+
+	if (is_imx7ulp_lpuart(sport) || is_imx8qxp_lpuart(sport)) {
+		/*
+		 * If the transmitter is used by earlycon, wait for transmit engine to
+		 * complete and then reset.
+		 */
+		ctrl = lpuart32_read(port, UARTCTRL);
+		if (ctrl & UARTCTRL_TE) {
+			bd = lpuart32_read(&sport->port, UARTBAUD);
+			if (read_poll_timeout(lpuart32_tx_empty, val, val, 1, 100000, false,
+					      port)) {
+				dev_warn(sport->port.dev,
+					 "timeout waiting for transmit engine to complete\n");
+				clk_disable_unprepare(sport->ipg_clk);
+				return 0;
+			}
+		}
+
+		global_addr = port->membase + UART_GLOBAL - IMX_REG_OFF;
+		writel(UART_GLOBAL_RST, global_addr);
+		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
+		writel(0, global_addr);
+		usleep_range(GLOBAL_RST_MIN_US, GLOBAL_RST_MAX_US);
+
+		/* Recover the transmitter for earlycon. */
+		if (ctrl & UARTCTRL_TE) {
+			lpuart32_write(port, bd, UARTBAUD);
+			lpuart32_write(port, ctrl, UARTCTRL);
+		}
+	}
+
+	clk_disable_unprepare(sport->ipg_clk);
+	return 0;
+}
+
 static int lpuart_probe(struct platform_device *pdev)
 {
 	const struct lpuart_soc_data *sdata = of_device_get_match_data(&pdev->dev);
-- 
2.35.1



