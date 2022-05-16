Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65686528E8E
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346153AbiEPTr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347020AbiEPTq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E02D427F5;
        Mon, 16 May 2022 12:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D46376154E;
        Mon, 16 May 2022 19:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4630C385AA;
        Mon, 16 May 2022 19:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730258;
        bh=9o4RUFqur9mew6cE5fqLdZI9D4SDZqn1UsWDbvfWv3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf8I6p9TZpsFGehl0Pvv2KgHj0FTOisFEx+dhU+9ehu8wkSArAFnwk11Rglms4VTn
         LyjMyOMBazMBHkE4liny0EmKa/mh//lBW2Kw5Q/cIq/FAj4weogN2r7tsWss3kJz/l
         tnbLWJ/2rWIuMlUhZ7wxLn/uo3/IiQQzqvOj4gSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.4 33/43] serial: 8250_mtk: Fix UART_EFR register address
Date:   Mon, 16 May 2022 21:36:44 +0200
Message-Id: <20220516193615.695595614@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
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
@@ -36,6 +36,7 @@
 #define MTK_UART_IER_RTSI	0x40	/* Enable RTS Modem status interrupt */
 #define MTK_UART_IER_CTSI	0x80	/* Enable CTS Modem status interrupt */
 
+#define MTK_UART_EFR		38	/* I/O: Extended Features Register */
 #define MTK_UART_EFR_EN		0x10	/* Enable enhancement feature */
 #define MTK_UART_EFR_RTS	0x40	/* Enable hardware rx flow control */
 #define MTK_UART_EFR_CTS	0x80	/* Enable hardware tx flow control */
@@ -168,7 +169,7 @@ static void mtk8250_dma_enable(struct ua
 		   MTK_UART_DMA_EN_RX | MTK_UART_DMA_EN_TX);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 
 	if (dmaengine_slave_config(dma->rxchan, &dma->rxconf) != 0)
@@ -231,7 +232,7 @@ static void mtk8250_set_flow_ctrl(struct
 	int lcr = serial_in(up, UART_LCR);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 	lcr = serial_in(up, UART_LCR);
 
@@ -240,7 +241,7 @@ static void mtk8250_set_flow_ctrl(struct
 		serial_out(up, MTK_UART_ESCAPE_DAT, MTK_UART_ESCAPE_CHAR);
 		serial_out(up, MTK_UART_ESCAPE_EN, 0x00);
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-		serial_out(up, UART_EFR, serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK)));
 		serial_out(up, UART_LCR, lcr);
 		mtk8250_disable_intrs(up, MTK_UART_IER_XOFFI |
@@ -254,8 +255,8 @@ static void mtk8250_set_flow_ctrl(struct
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable hw flow control*/
-		serial_out(up, UART_EFR, MTK_UART_EFR_HW_FC |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_HW_FC |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
 		serial_out(up, UART_LCR, lcr);
@@ -269,8 +270,8 @@ static void mtk8250_set_flow_ctrl(struct
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable sw flow control */
-		serial_out(up, UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
 		serial_out(up, UART_XON1, START_CHAR(port->state->port.tty));


