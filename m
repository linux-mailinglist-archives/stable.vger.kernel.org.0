Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C926AF4A2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbjCGTSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbjCGTRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72294211E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2988661522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDF7C433EF;
        Tue,  7 Mar 2023 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215698;
        bh=7+2RgukAqTas/UvgBNF60fwofIKQhB1nJt1hnCvLNj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lk/GnQT9Ltoay0BUtguJ336vlR8u9FO43tylfarCeKmMJcyTSaKPMfIp9FU+OWY35
         49Z0zIEE1+iBQoBJbTERWRHSHVZUOUM0w9UPEn+RD9p/RSjbpxLJw4PUZ3mHFkXDDx
         K3e5T26sY+wOyvLMX5vTWti1Bxgc5iPcm0bVfB40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Fabio Estevam <festevam@denx.de>, Marek Vasut <marex@denx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/567] tty: serial: imx: Handle RS485 DE signal active high
Date:   Tue,  7 Mar 2023 18:01:04 +0100
Message-Id: <20230307165920.115518982@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 79d0224f6bf296d04cd843cfc49921b19c97bb09 ]

The default polarity of RS485 DE signal is active high. This driver does
not handle such case properly. Currently, when a pin is multiplexed as a
UART CTS_B on boot, this pin is pulled HIGH by the i.MX UART CTS circuit,
which activates DE signal on the RS485 transceiver and thus behave as if
the RS485 was transmitting data, so the system blocks the RS485 bus when
it starts and until user application takes over. This behavior is not OK.
The problem consists of two separate parts.

First, the i.MX UART IP requires UCR1 UARTEN and UCR2 RXEN to be set for
UCR2 CTSC and CTS bits to have any effect. The UCR2 CTSC bit permits the
driver to set CTS (RTS_B or RS485 DE signal) to either level sychronous
to the internal UART IP clock. Compared to other options, like GPIO CTS
control, this has the benefit of being synchronous to the UART IP clock
and thus without glitches or bus delays. The reason for the CTS design
is likely because when the Receiver is disabled, the UART IP can never
indicate that it is ready to receive data by assering CTS signal, so
the CTS is always pulled HIGH by default.

When the port is closed by user space, imx_uart_stop_rx() clears UCR2
RXEN bit, and imx_uart_shutdown() clears UCR1 UARTEN bit. This disables
UART Receiver and UART itself, and forces CTS signal HIGH, which leads
to the RS485 bus being blocked because RS485 DE is incorrectly active.

The proposed solution for this problem is to keep the Receiver running
even after the port is closed, but in loopback mode. This disconnects
the RX FIFO input from the RXD external signal, and since UCR2 TXEN is
cleared, the UART Transmitter is disabled, so nothing can feed data in
the RX FIFO. Because the Receiver is still enabled, the UCR2 CTSC and
CTS bits still have effect and the CTS (RS485 DE) control is retained.

Note that in case of RS485 DE signal active low, there is no problem and
no special handling is necessary. The CTS signal defaults to HIGH, thus
the RS485 is by default set to Receive and the bus is not blocked.

Note that while there is the possibility to control CTS using GPIO with
either CTS polarity, this has the downside of not being synchronous to
the UART IP clock and thus glitchy and susceptible to slow DE switching.

Second, on boot, before the UART driver probe callback is called, the
driver core triggers pinctrl_init_done() and configures the IOMUXC to
default state. At this point, UCR1 UARTEN and UCR2 RXEN are both still
cleared, but UART CTS_B (RS485 DE) is configured as CTS function, thus
the RTS signal is pulled HIGH by the UART IP CTS circuit.

One part of the solution here is to enable UCR1 UARTEN and UCR2 RXEN and
UTS loopback in this driver probe callback, thus unblocking the CTSC and
CTS control early on. But this is still too late, since the pin control
is already configured and CTS has been pulled HIGH for a short period
of time.

When Linux kernel boots and this driver is bound, the pin control is set
to special "init" state if the state is available, and driver can switch
the "default" state afterward when ready. This state can be used to set
the CTS line as a GPIO in DT temporarily, and a GPIO hog can force such
GPIO to LOW, thus keeping the RS485 DE line LOW early on boot. Once the
driver takes over and UCR1 UARTEN and UCR2 RXEN and UTS loopback are all
enabled, the driver can switch to "default" pin control state and control
the CTS line as function instead. DT binding example is below:

"
&gpio6 {
  rts-init-hog {
    gpio-hog;
    gpios = <5 0>;
    output-low;
    line-name = "rs485-de";
  };
};

&uart5 { /* DHCOM UART2 */
  pinctrl-0 = <&pinctrl_uart5>;
  pinctrl-1 = <&pinctrl_uart5_init>;
  pinctrl-names = "default", "init";
  ...
};
pinctrl_uart5_init: uart5-init-grp {
  fsl,pins = <
...
    MX6QDL_PAD_CSI0_DAT19__GPIO6_IO05       0x30b1
  >;
};

pinctrl_uart5: uart5-grp {
  fsl,pins = <
...
    MX6QDL_PAD_CSI0_DAT19__UART5_CTS_B      0x30b1
  >;
};
"

Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Reviewed-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20220929144400.13571-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ef25e16ea967 ("tty: serial: imx: disable Ageing Timer interrupt request irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 64 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 711edb835c274..136da4bebe85a 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -484,7 +484,7 @@ static void imx_uart_stop_tx(struct uart_port *port)
 static void imx_uart_stop_rx(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
-	u32 ucr1, ucr2, ucr4;
+	u32 ucr1, ucr2, ucr4, uts;
 
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr2 = imx_uart_readl(sport, UCR2);
@@ -500,7 +500,18 @@ static void imx_uart_stop_rx(struct uart_port *port)
 	imx_uart_writel(sport, ucr1, UCR1);
 	imx_uart_writel(sport, ucr4, UCR4);
 
-	ucr2 &= ~UCR2_RXEN;
+	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
+	if (port->rs485.flags & SER_RS485_ENABLED &&
+	    port->rs485.flags & SER_RS485_RTS_ON_SEND &&
+	    sport->have_rtscts && !sport->have_rtsgpio) {
+		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+		uts |= UTS_LOOP;
+		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+		ucr2 |= UCR2_RXEN;
+	} else {
+		ucr2 &= ~UCR2_RXEN;
+	}
+
 	imx_uart_writel(sport, ucr2, UCR2);
 }
 
@@ -1383,7 +1394,7 @@ static int imx_uart_startup(struct uart_port *port)
 	int retval, i;
 	unsigned long flags;
 	int dma_is_inited = 0;
-	u32 ucr1, ucr2, ucr3, ucr4;
+	u32 ucr1, ucr2, ucr3, ucr4, uts;
 
 	retval = clk_prepare_enable(sport->clk_per);
 	if (retval)
@@ -1488,6 +1499,11 @@ static int imx_uart_startup(struct uart_port *port)
 		imx_uart_writel(sport, ucr2, UCR2);
 	}
 
+	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
+	uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+	uts &= ~UTS_LOOP;
+	imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	return 0;
@@ -1497,7 +1513,7 @@ static void imx_uart_shutdown(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long flags;
-	u32 ucr1, ucr2, ucr4;
+	u32 ucr1, ucr2, ucr4, uts;
 
 	if (sport->dma_is_enabled) {
 		dmaengine_terminate_sync(sport->dma_chan_tx);
@@ -1541,7 +1557,18 @@ static void imx_uart_shutdown(struct uart_port *port)
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	ucr1 = imx_uart_readl(sport, UCR1);
-	ucr1 &= ~(UCR1_TRDYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN | UCR1_RXDMAEN | UCR1_ATDMAEN);
+	ucr1 &= ~(UCR1_TRDYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_RXDMAEN | UCR1_ATDMAEN);
+	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
+	if (port->rs485.flags & SER_RS485_ENABLED &&
+	    port->rs485.flags & SER_RS485_RTS_ON_SEND &&
+	    sport->have_rtscts && !sport->have_rtsgpio) {
+		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+		uts |= UTS_LOOP;
+		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+		ucr1 |= UCR1_UARTEN;
+	} else {
+		ucr1 &= ~UCR1_UARTEN;
+	}
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4);
@@ -2189,7 +2216,7 @@ static int imx_uart_probe(struct platform_device *pdev)
 	void __iomem *base;
 	u32 dma_buf_conf[2];
 	int ret = 0;
-	u32 ucr1;
+	u32 ucr1, ucr2, uts;
 	struct resource *res;
 	int txirq, rxirq, rtsirq;
 
@@ -2321,6 +2348,31 @@ static int imx_uart_probe(struct platform_device *pdev)
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
 	imx_uart_writel(sport, ucr1, UCR1);
 
+	/*
+	 * In case RS485 is enabled without GPIO RTS control, the UART IP
+	 * is used to control CTS signal. Keep both the UART and Receiver
+	 * enabled, otherwise the UART IP pulls CTS signal always HIGH no
+	 * matter how the UCR2 CTSC and CTS bits are set. To prevent any
+	 * data from being fed into the RX FIFO, enable loopback mode in
+	 * UTS register, which disconnects the RX path from external RXD
+	 * pin and connects it to the Transceiver, which is disabled, so
+	 * no data can be fed to the RX FIFO that way.
+	 */
+	if (sport->port.rs485.flags & SER_RS485_ENABLED &&
+	    sport->have_rtscts && !sport->have_rtsgpio) {
+		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+		uts |= UTS_LOOP;
+		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+
+		ucr1 = imx_uart_readl(sport, UCR1);
+		ucr1 |= UCR1_UARTEN;
+		imx_uart_writel(sport, ucr1, UCR1);
+
+		ucr2 = imx_uart_readl(sport, UCR2);
+		ucr2 |= UCR2_RXEN;
+		imx_uart_writel(sport, ucr2, UCR2);
+	}
+
 	if (!imx_uart_is_imx1(sport) && sport->dte_mode) {
 		/*
 		 * The DCEDTE bit changes the direction of DSR, DCD, DTR and RI
-- 
2.39.2



