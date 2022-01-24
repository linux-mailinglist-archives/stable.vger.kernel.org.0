Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B33F4995ED
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443599AbiAXU5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359047AbiAXUxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157F1C02B86B;
        Mon, 24 Jan 2022 11:59:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7DE260B43;
        Mon, 24 Jan 2022 19:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73670C340E5;
        Mon, 24 Jan 2022 19:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054341;
        bh=nTQQoOcwOSWdtjW4HqwT3MpwSNGEGW1hkZI3TJyvSr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAg2F0TzMBdQ7GBQIlVp37H+WD8oXlmL6xlHLLJxw4B8V+QHijRzfneXvjVSqAvxk
         JBLU+O07iynz5J0ozM/FA1BpeF+mmQjSIjTzbwVzjNpPbSHbDmSq9vjcz3CXtiiV9U
         zKrK+lJKN0IjUW8LsDD/G47iZFM5XBRlXdpaGyfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/563] tty: serial: imx: disable UCR4_OREN in .stop_rx() instead of .shutdown()
Date:   Mon, 24 Jan 2022 19:41:29 +0100
Message-Id: <20220124184035.638726101@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 028e083832b06fdeeb290e1e57dc1f6702c4c215 ]

The UCR4_OREN should be disabled before disabling the uart receiver in
.stop_rx() instead of in the .shutdown().

Otherwise, if we have the overrun error during the receiver disable
process, the overrun interrupt will keep trigging until we disable the
OREN interrupt in the .shutdown(), because the ORE status can only be
cleared when read the rx FIFO or reset the controller.  Although the
called time between the receiver disable and OREN disable in .shutdown()
is very short, there is still the risk of endless interrupt during this
short period of time. So here change to disable OREN before the receiver
been disabled in .stop_rx().

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20211125020349.4980-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 28cc328ddb6eb..93cd8ad57f385 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -508,18 +508,21 @@ static void imx_uart_stop_tx(struct uart_port *port)
 static void imx_uart_stop_rx(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
-	u32 ucr1, ucr2;
+	u32 ucr1, ucr2, ucr4;
 
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr2 = imx_uart_readl(sport, UCR2);
+	ucr4 = imx_uart_readl(sport, UCR4);
 
 	if (sport->dma_is_enabled) {
 		ucr1 &= ~(UCR1_RXDMAEN | UCR1_ATDMAEN);
 	} else {
 		ucr1 &= ~UCR1_RRDYEN;
 		ucr2 &= ~UCR2_ATEN;
+		ucr4 &= ~UCR4_OREN;
 	}
 	imx_uart_writel(sport, ucr1, UCR1);
+	imx_uart_writel(sport, ucr4, UCR4);
 
 	ucr2 &= ~UCR2_RXEN;
 	imx_uart_writel(sport, ucr2, UCR2);
@@ -1576,7 +1579,7 @@ static void imx_uart_shutdown(struct uart_port *port)
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4);
-	ucr4 &= ~(UCR4_OREN | UCR4_TCEN);
+	ucr4 &= ~UCR4_TCEN;
 	imx_uart_writel(sport, ucr4, UCR4);
 
 	spin_unlock_irqrestore(&sport->port.lock, flags);
-- 
2.34.1



