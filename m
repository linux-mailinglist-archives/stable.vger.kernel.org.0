Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DEA4914E8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbiARCZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:25:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239178AbiARCXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED17A608C0;
        Tue, 18 Jan 2022 02:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C15C36AEB;
        Tue, 18 Jan 2022 02:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472612;
        bh=k0ORuEQnGTqteUEkwb9luAXHUAo6NBshCwtibeD8tfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjZp2KSFeQUNxzEIs5227gZt2w4axRlSAQLE9gjP4NK62ujIBjHjMCWsFXJ/v/a76
         6kqSogQ1w2vdQqXiSiEuhUFcQ7pwUBTXidzFDclOy+9z/mAlFyyRLRCLfRxRpDXSr1
         aVLTClyyqxl3tJCAQXr/PJj/5vVL+FVLMwJAL16iylyKtU+GvzxQsFnuQQeT8LVifs
         POL3bqkWTVtFTaVtvSU7LhdmUqomVj5D7yoFwqEFwv6C0Al50NqKL17f5CVddQF159
         2rESS9zMK3vxiaYEhkV1lOq6sWLLX7HjWvtCpLf7swN8yWb8yKbxxmgqrrErlBNY4T
         /O/BTe9IVV3LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>, Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        shawnguo@kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 070/217] tty: serial: imx: disable UCR4_OREN in .stop_rx() instead of .shutdown()
Date:   Mon, 17 Jan 2022 21:17:13 -0500
Message-Id: <20220118021940.1942199-70-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 90f82e6c54e46..6f7f382d0b1fa 100644
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

