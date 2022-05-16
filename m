Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F149A528FBF
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243526AbiEPULB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351130AbiEPUCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F5F26FA;
        Mon, 16 May 2022 12:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96FCF60EC4;
        Mon, 16 May 2022 19:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94522C385AA;
        Mon, 16 May 2022 19:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731158;
        bh=k3/81g5qlPZbnqT8EYIg1TFY+nbeoYo8soZiwtxXbI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gg40e1WeZrjKijDyiza7lB1AM2F9ZmnIfs0B+9H8yITaxp3gFqN5+TySUOEraRnn9
         m9jr1c3K4zy9ND4LiLW5KoJd091DOdQutvwsg4CtMrIrba6Zoq8LY8148Dkt1mM6sn
         /OXLxMyX5yGccofgU+IQ4G4crqo6//Gg96dplogI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.17 090/114] serial: 8250_mtk: Fix UART_EFR register address
Date:   Mon, 16 May 2022 21:37:04 +0200
Message-Id: <20220516193628.061740626@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit bb0b197aadd928f52ce6f01f0ee977f0a08cf1be upstream.

On MediaTek SoCs, the UART IP is 16550A compatible, but there are some
specific quirks: we are declaring a register shift of 2, but this is
only valid for the majority of the registers, as there are some that
are out of the standard layout.

Specifically, this driver is using definitions from serial_reg.h, where
we have a UART_EFR register defined as 2: this results in a 0x8 offset,
but there we have the FCR register instead.

The right offset for the EFR register on MediaTek UART is at 0x98,
so, following the decimal definition convention in serial_reg.h and
accounting for the register left shift of two, add and use the correct
register address for this IP, defined as decimal 38, so that the final
calculation results in (0x26 << 2) = 0x98.

Fixes: bdbd0a7f8f03 ("serial: 8250-mtk: modify baudrate setting")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220427132328.228297-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -37,6 +37,7 @@
 #define MTK_UART_IER_RTSI	0x40	/* Enable RTS Modem status interrupt */
 #define MTK_UART_IER_CTSI	0x80	/* Enable CTS Modem status interrupt */
 
+#define MTK_UART_EFR		38	/* I/O: Extended Features Register */
 #define MTK_UART_EFR_EN		0x10	/* Enable enhancement feature */
 #define MTK_UART_EFR_RTS	0x40	/* Enable hardware rx flow control */
 #define MTK_UART_EFR_CTS	0x80	/* Enable hardware tx flow control */
@@ -169,7 +170,7 @@ static void mtk8250_dma_enable(struct ua
 		   MTK_UART_DMA_EN_RX | MTK_UART_DMA_EN_TX);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 
 	if (dmaengine_slave_config(dma->rxchan, &dma->rxconf) != 0)
@@ -232,7 +233,7 @@ static void mtk8250_set_flow_ctrl(struct
 	int lcr = serial_in(up, UART_LCR);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 	lcr = serial_in(up, UART_LCR);
 
@@ -241,7 +242,7 @@ static void mtk8250_set_flow_ctrl(struct
 		serial_out(up, MTK_UART_ESCAPE_DAT, MTK_UART_ESCAPE_CHAR);
 		serial_out(up, MTK_UART_ESCAPE_EN, 0x00);
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-		serial_out(up, UART_EFR, serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK)));
 		serial_out(up, UART_LCR, lcr);
 		mtk8250_disable_intrs(up, MTK_UART_IER_XOFFI |
@@ -255,8 +256,8 @@ static void mtk8250_set_flow_ctrl(struct
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable hw flow control*/
-		serial_out(up, UART_EFR, MTK_UART_EFR_HW_FC |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_HW_FC |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
 		serial_out(up, UART_LCR, lcr);
@@ -270,8 +271,8 @@ static void mtk8250_set_flow_ctrl(struct
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable sw flow control */
-		serial_out(up, UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
 		serial_out(up, UART_XON1, START_CHAR(port->state->port.tty));


