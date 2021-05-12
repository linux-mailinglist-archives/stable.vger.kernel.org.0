Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724B337CBC5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhELQhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhELQ2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C3DC61937;
        Wed, 12 May 2021 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834976;
        bh=iYd0n8KGS7OVvnUky4wYH+rPfV2YZt8v3fPxNhpzQoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MX9l0zPd7UnUPryfoITdezWMAVieg/TFenJIhF5GQ9rAVcO6D3twOcBD41soNtIJR
         O/CMJvckCrD+pCSQ5ugMQSP3LWES80rkuKs8qTwpAmTMO5aGpcemI46TBvdTI8VNQ6
         DsjSzacbEmoGzfD36LWA5i3wpx8irNEp+bUtRTjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 160/677] serial: stm32: fix startup by enabling usart for reception
Date:   Wed, 12 May 2021 16:43:26 +0200
Message-Id: <20210512144842.563835450@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 3d58824ac2af..c6ca8f964c69 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -634,6 +634,7 @@ static int stm32_usart_startup(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	const char *name = to_platform_device(port->dev)->name;
 	u32 val;
 	int ret;
@@ -658,7 +659,7 @@ static int stm32_usart_startup(struct uart_port *port)
 	}
 
 	/* RX FIFO enabling */
-	val = stm32_port->cr1_irq | USART_CR1_RE;
+	val = stm32_port->cr1_irq | USART_CR1_RE | BIT(cfg->uart_enable_bit);
 	if (stm32_port->fifoen)
 		val |= USART_CR1_FIFOEN;
 	stm32_usart_set_bits(port, ofs->cr1, val);
-- 
2.30.2



