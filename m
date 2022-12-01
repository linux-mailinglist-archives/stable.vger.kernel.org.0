Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51063EBA2
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 09:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLAIyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 03:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLAIyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 03:54:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452823D92D
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 00:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669884856; x=1701420856;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5S04XEVszvqHluDKodEz2778W3pgCoVJ2UKcAubiyDY=;
  b=KHxYhFtKjQm73hryU65PoKr4Y61zVLADRRFKIMmagr+J212XZjeRZuoY
   Fo/RbpEp5HQi6hXfZoncjZKzdXbhsye3iBevvxMJ2W5lgAhfE5xjCFeII
   9eQKrZCBYfkT6e0NwMddMQAE2jR6MTr3YP/bcmoLPBUQFkzrjr0b8k/Xt
   DGrJlGY8LWHK2h7UdukKXiF5p/4MR5GUsPJOSWs+ePeMIagk1g/dKQFxu
   L6qLxW2RzYqUSiGJBRT0zD05wEzzSZqKfdPWmnVMesQk3UGxPw8ru0kfF
   cX3Ege/nlD/N3aPwwlUDhpZ1693po21fEG4FtN3NLxiNYg+vT0+xijClN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="342555744"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="342555744"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 00:54:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="646679278"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="646679278"
Received: from akoroglu-mobl.ger.corp.intel.com ([10.251.212.165])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 00:54:13 -0800
Date:   Thu, 1 Dec 2022 10:54:08 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherry Sun <sherry.sun@nxp.com>
cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH proper backport to 5.15 1/1] tty: serial: fsl_lpuart: don't
 break the on-going transfer when global reset
Message-ID: <1b26798d-fdbd-9e21-b745-1ed335e75b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Hi stable folks,

These two stable-deps seem to be pulled into stable only due to diff 
context:

07481f448b63 ("serial: fsl_lpuart: Fill in rs485_supported")
8925c31c1ac2 ("serial: Add rs485_supported to uart_port")

I think those two should be dropped from the stable queue and the queued 
fix for 76bad3f88750 ("tty: serial: fsl_lpuart: don't break the on-going 
transfer when global reset") replaced with this backport.

 drivers/tty/serial/fsl_lpuart.c | 76 +++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 44ed4285e1ef..df6254724729 100644
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
@@ -395,33 +396,6 @@ static unsigned int lpuart_get_baud_clk_rate(struct lpuart_port *sport)
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
@@ -2644,6 +2618,54 @@ static struct uart_driver lpuart_reg = {
 	.cons		= LPUART_CONSOLE,
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
2.30.2

