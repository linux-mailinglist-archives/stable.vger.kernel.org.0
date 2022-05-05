Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346BD51CC25
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386430AbiEEWid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386425AbiEEWi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:38:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C40E5F8CE
        for <stable@vger.kernel.org>; Thu,  5 May 2022 15:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A969661F50
        for <stable@vger.kernel.org>; Thu,  5 May 2022 22:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3662C385A4;
        Thu,  5 May 2022 22:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651790075;
        bh=IL2eza21Y2MizLPKiF2LMccxi4WYSNjYZtp7EYNibzg=;
        h=Subject:To:From:Date:From;
        b=wvgzUp/2HwexgCh6mDzH7n5l3TCfHDb+rLNWYAqtQ+p5RScTvvkwLJKkfjaohpTv4
         tNWVom0l0fTCnGDGyC237UvRPe5IEP+uaGUl6WowKBerLlCxM5NFNqsClL+Jc8mrkf
         VlU/4I9mslNErPOvWOhzgGm/+OGWdcB9LGKE8pYI=
Subject: patch "serial: 8250_mtk: Fix UART_EFR register address" added to tty-linus
To:     angelogioacchino.delregno@collabora.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 May 2022 23:00:37 +0200
Message-ID: <16517844373026@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_mtk: Fix UART_EFR register address

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bb0b197aadd928f52ce6f01f0ee977f0a08cf1be Mon Sep 17 00:00:00 2001
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Date: Wed, 27 Apr 2022 15:23:26 +0200
Subject: serial: 8250_mtk: Fix UART_EFR register address

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
 drivers/tty/serial/8250/8250_mtk.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index f4a0caa56f84..cd62a5f34014 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -37,6 +37,7 @@
 #define MTK_UART_IER_RTSI	0x40	/* Enable RTS Modem status interrupt */
 #define MTK_UART_IER_CTSI	0x80	/* Enable CTS Modem status interrupt */
 
+#define MTK_UART_EFR		38	/* I/O: Extended Features Register */
 #define MTK_UART_EFR_EN		0x10	/* Enable enhancement feature */
 #define MTK_UART_EFR_RTS	0x40	/* Enable hardware rx flow control */
 #define MTK_UART_EFR_CTS	0x80	/* Enable hardware tx flow control */
@@ -169,7 +170,7 @@ static void mtk8250_dma_enable(struct uart_8250_port *up)
 		   MTK_UART_DMA_EN_RX | MTK_UART_DMA_EN_TX);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 
 	if (dmaengine_slave_config(dma->rxchan, &dma->rxconf) != 0)
@@ -232,7 +233,7 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 	int lcr = serial_in(up, UART_LCR);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 	lcr = serial_in(up, UART_LCR);
 
@@ -241,7 +242,7 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 		serial_out(up, MTK_UART_ESCAPE_DAT, MTK_UART_ESCAPE_CHAR);
 		serial_out(up, MTK_UART_ESCAPE_EN, 0x00);
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-		serial_out(up, UART_EFR, serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK)));
 		serial_out(up, UART_LCR, lcr);
 		mtk8250_disable_intrs(up, MTK_UART_IER_XOFFI |
@@ -255,8 +256,8 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable hw flow control*/
-		serial_out(up, UART_EFR, MTK_UART_EFR_HW_FC |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_HW_FC |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
 		serial_out(up, UART_LCR, lcr);
@@ -270,8 +271,8 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable sw flow control */
-		serial_out(up, UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
 		serial_out(up, UART_XON1, START_CHAR(port->state->port.tty));
-- 
2.36.0


