Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C468A52917D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343821AbiEPUFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348860AbiEPT7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E0B640B;
        Mon, 16 May 2022 12:51:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 432C860A50;
        Mon, 16 May 2022 19:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1D0C385AA;
        Mon, 16 May 2022 19:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730695;
        bh=hxQr3HJrF4KGHrYdn2UKe4Ty6jxRkxNLvEZh7rMK530=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3BD8QrRZGYR5zB1PUV8z5lvOGxeuPFNgLkJM+bqb+NoUqatz8E/AWMws5nRu65Ec
         qLFjSn9tk4zYRKXmGB9zf/8Vdg9bc2FscofVvtVupsHLsfLutZancWcoIM+za0z1e1
         lAkQihSpFe5C5m3QKmEdphTuN8ka80qOon9ejzlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.15 080/102] serial: 8250_mtk: Fix register address for XON/XOFF character
Date:   Mon, 16 May 2022 21:36:54 +0200
Message-Id: <20220516193626.290818981@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
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

commit e1bfdbc7daca171c74a577b3dd0b36d76bb0ffcc upstream.

The XON1/XOFF1 character registers are at offset 0xa0 and 0xa8
respectively, so we cannot use the definition in serial_port.h.

Fixes: bdbd0a7f8f03 ("serial: 8250-mtk: modify baudrate setting")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220427132328.228297-4-angelogioacchino.delregno@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -54,6 +54,9 @@
 #define MTK_UART_TX_TRIGGER	1
 #define MTK_UART_RX_TRIGGER	MTK_UART_RX_SIZE
 
+#define MTK_UART_XON1		40	/* I/O: Xon character 1 */
+#define MTK_UART_XOFF1		42	/* I/O: Xoff character 1 */
+
 #ifdef CONFIG_SERIAL_8250_DMA
 enum dma_rx_status {
 	DMA_RX_START = 0,
@@ -275,8 +278,8 @@ static void mtk8250_set_flow_ctrl(struct
 			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
-		serial_out(up, UART_XON1, START_CHAR(port->state->port.tty));
-		serial_out(up, UART_XOFF1, STOP_CHAR(port->state->port.tty));
+		serial_out(up, MTK_UART_XON1, START_CHAR(port->state->port.tty));
+		serial_out(up, MTK_UART_XOFF1, STOP_CHAR(port->state->port.tty));
 		serial_out(up, UART_LCR, lcr);
 		mtk8250_disable_intrs(up, MTK_UART_IER_CTSI|MTK_UART_IER_RTSI);
 		mtk8250_enable_intrs(up, MTK_UART_IER_XOFFI);


