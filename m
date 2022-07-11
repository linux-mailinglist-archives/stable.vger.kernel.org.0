Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4056FDAC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiGKJ7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbiGKJ6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:58:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E8DB5D15;
        Mon, 11 Jul 2022 02:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D376A61366;
        Mon, 11 Jul 2022 09:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9CDC34115;
        Mon, 11 Jul 2022 09:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531634;
        bh=72C4Cq7hWJ3xQ8q5umw7jp4XTDXmIZeMx894K7C2sR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAon/scjWfPjDlstymWMlbqgoQ+EipU9/rtfFRkOjkW/DWESSNqq+e2N03xIOD5vU
         8p5gJUMFL0mC8jzxxEeJPAhAhVUtxRO1Pu6moZKIsdlbagcxBuuEZWG+XM35RM6I0K
         ncyh5XXKPh6PyDtCv4Xavwgx+ntBpQpavbTYpbSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/230] serial: 8250_mtk: Make sure to select the right FEATURE_SEL
Date:   Mon, 11 Jul 2022 11:06:32 +0200
Message-Id: <20220711090607.922087626@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 6f81fdded0d024c7d4084d434764f30bca1cd6b1 ]

Set the FEATURE_SEL at probe time to make sure that BIT(0) is enabled:
this guarantees that when the port is configured as AP UART, the
right register layout is interpreted by the UART IP.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220427132328.228297-3-angelogioacchino.delregno@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mtk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index de48a58460f4..de57f47635cd 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -57,6 +57,9 @@
 #define MTK_UART_XON1		40	/* I/O: Xon character 1 */
 #define MTK_UART_XOFF1		42	/* I/O: Xoff character 1 */
 
+#define MTK_UART_FEATURE_SEL	39	/* Feature Selection register */
+#define MTK_UART_FEAT_NEWRMAP	BIT(0)	/* Use new register map */
+
 #ifdef CONFIG_SERIAL_8250_DMA
 enum dma_rx_status {
 	DMA_RX_START = 0,
@@ -572,6 +575,10 @@ static int mtk8250_probe(struct platform_device *pdev)
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
2.35.1



