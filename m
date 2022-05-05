Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7664751CC3A
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386427AbiEEWic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386430AbiEEWi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:38:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0105FF0D
        for <stable@vger.kernel.org>; Thu,  5 May 2022 15:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D55B830E9
        for <stable@vger.kernel.org>; Thu,  5 May 2022 22:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E407C385A8;
        Thu,  5 May 2022 22:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651790076;
        bh=9tN/sZ2nFT0OfBVjUpHY9xa0dTgf7B9Wl7qVEIOnUKA=;
        h=Subject:To:From:Date:From;
        b=dM7AVBvstPfVJsyNJLm+jsfTCkTxBYm8JAFLdgfDO4LuGv1pNCp4z0EJ4e+M+y2k7
         KWp4664a4C6IEPQFXG3GhUnjTRihxDPDXvBsiLMA4mpyc1WjLaC6l3b0T94ocVubN4
         KYy1bIGEWZK6YaxOvx5syb11DUz6yG3c53yO5nvk=
Subject: patch "serial: 8250_mtk: Make sure to select the right FEATURE_SEL" added to tty-linus
To:     angelogioacchino.delregno@collabora.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 May 2022 23:00:38 +0200
Message-ID: <165178443861100@kroah.com>
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

    serial: 8250_mtk: Make sure to select the right FEATURE_SEL

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6f81fdded0d024c7d4084d434764f30bca1cd6b1 Mon Sep 17 00:00:00 2001
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Date: Wed, 27 Apr 2022 15:23:27 +0200
Subject: serial: 8250_mtk: Make sure to select the right FEATURE_SEL

Set the FEATURE_SEL at probe time to make sure that BIT(0) is enabled:
this guarantees that when the port is configured as AP UART, the
right register layout is interpreted by the UART IP.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220427132328.228297-3-angelogioacchino.delregno@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index cd62a5f34014..28e36459642c 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -54,6 +54,9 @@
 #define MTK_UART_TX_TRIGGER	1
 #define MTK_UART_RX_TRIGGER	MTK_UART_RX_SIZE
 
+#define MTK_UART_FEATURE_SEL	39	/* Feature Selection register */
+#define MTK_UART_FEAT_NEWRMAP	BIT(0)	/* Use new register map */
+
 #ifdef CONFIG_SERIAL_8250_DMA
 enum dma_rx_status {
 	DMA_RX_START = 0,
@@ -569,6 +572,10 @@ static int mtk8250_probe(struct platform_device *pdev)
 		uart.dma = data->dma;
 #endif
 
+	/* Set AP UART new register map */
+	writel(MTK_UART_FEAT_NEWRMAP, uart.port.membase +
+	       (MTK_UART_FEATURE_SEL << uart.port.regshift));
+
 	/* Disable Rate Fix function */
 	writel(0x0, uart.port.membase +
 			(MTK_UART_RATE_FIX << uart.port.regshift));
-- 
2.36.0


