Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE63491725
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344791AbiARCiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:38:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52298 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344852AbiARCfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:35:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0120611D6;
        Tue, 18 Jan 2022 02:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8FC36AE3;
        Tue, 18 Jan 2022 02:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473303;
        bh=6ftHw2PhpvyqVOJfiLYzxPb74sRaD6npgzQ7/f5plLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Alz6ds3MtNrwN+jO2q2nyHTJQmqRWOHdI51ZZn5fZDxNpWYjqeWbPt7XTVMisKmND
         qHZpDY8xBspZlDp8RHoUs81tu6CTUUlb6LPEEMBDTXdzYuX4MAoi//gHJiPZolS2XL
         Psi1+8YwESGWF404gJRxquvn+62BuycT5SuEwiUg24Fe0AtR5SvQuLRTGmMCCBKZ1f
         V6L6jieQY62KOo00movX+J57EYnJ2DEDc0WFOPEs/CFP4qqy8NHH0allKHFjJdD2VS
         NKvcu7HwhPSXDD/scbIPibgY8oYYFpk0Rh+ys0Ki1IBm1CYEC/4EOzrcm3XjVGutu/
         z5AXGFYE+oW1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>, Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        shawnguo@kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 059/188] tty: serial: imx: disable UCR4_OREN in .stop_rx() instead of .shutdown()
Date:   Mon, 17 Jan 2022 21:29:43 -0500
Message-Id: <20220118023152.1948105-59-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 51a9f9423b1a6..7820049aba5af 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -486,18 +486,21 @@ static void imx_uart_stop_tx(struct uart_port *port)
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
@@ -1544,7 +1547,7 @@ static void imx_uart_shutdown(struct uart_port *port)
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4);
-	ucr4 &= ~(UCR4_OREN | UCR4_TCEN);
+	ucr4 &= ~UCR4_TCEN;
 	imx_uart_writel(sport, ucr4, UCR4);
 
 	spin_unlock_irqrestore(&sport->port.lock, flags);
-- 
2.34.1

