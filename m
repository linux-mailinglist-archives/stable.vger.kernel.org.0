Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA2F37C802
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbhELQEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234780AbhELP65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:58:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2901C61973;
        Wed, 12 May 2021 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833518;
        bh=1EU/S4DKdxK4bC4Ueq9ZlLV5redgJacoyvV2gblYSXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6VF5pNK0AMeAKP9zyRWg2huAe8FoUHnrETkAjMeslNEdGWVRUHbBhn7iZkWP0/HD
         cB9+v9m+NkRU7rmQloxSVATEE+wBJ72xIMRnCxRk16ZCVehZ9fyzonqiT7Q+Dk0xWB
         pjrgSBK36QyPgZdGZWD0VTr5TY93Trot7Fy2eZLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 147/601] serial: stm32: fix startup by enabling usart for reception
Date:   Wed, 12 May 2021 16:43:44 +0200
Message-Id: <20210512144832.659532679@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit f4518a8a75f5be1a121b0c95ad9c6b1eb27d920e ]

RX is configured, but usart is not enabled in startup function.
Kernel documentation specifies that startup should enable the port for
reception.
Fix the startup by enabling usart for reception.

Fixes: 84872dc448fe ("serial: stm32: add RX and TX FIFO flush")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-3-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 1f7fe285bb1f..909a0d991ba1 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -633,6 +633,7 @@ static int stm32_usart_startup(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	const char *name = to_platform_device(port->dev)->name;
 	u32 val;
 	int ret;
@@ -657,7 +658,7 @@ static int stm32_usart_startup(struct uart_port *port)
 	}
 
 	/* RX FIFO enabling */
-	val = stm32_port->cr1_irq | USART_CR1_RE;
+	val = stm32_port->cr1_irq | USART_CR1_RE | BIT(cfg->uart_enable_bit);
 	if (stm32_port->fifoen)
 		val |= USART_CR1_FIFOEN;
 	stm32_usart_set_bits(port, ofs->cr1, val);
-- 
2.30.2



