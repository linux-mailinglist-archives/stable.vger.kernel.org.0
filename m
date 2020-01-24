Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885F21481A0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgAXLV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390482AbgAXLV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:29 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C99206D5;
        Fri, 24 Jan 2020 11:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864888;
        bh=sD/unQ5VtH3soFU+qFEFtW8QFjKO1BxoT8p4rKlWsmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljNn1z6s57HAtZoODaXMk3OfAxh1lXHv7oCTu7RIDdDUH2ZdrXUZHnGtKieNsH5vN
         yCQxzfdjoSuWQtESmVDbVuYIWZr70raJAucvZ+9XueitqtRUsOGQIUBa3rl5VGa2lT
         f/HsFhfYpqDhIqwjvY5MMaQDYGc0F1xBEBaZITKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 393/639] serial: stm32: fix wakeup source initialization
Date:   Fri, 24 Jan 2020 10:29:23 +0100
Message-Id: <20200124093136.166513982@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@st.com>

[ Upstream commit 5297f274e8b61ceb9676cba6649d3de9d03387ad ]

Fixes dedicated_irq_wakeup issue and deactivated uart as wakeup source by
default.

Fixes: 270e5a74fe4c ("serial: stm32: add wakeup mechanism")
Signed-off-by: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index d603be9669a96..1334e42939776 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -557,7 +557,6 @@ static int stm32_startup(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	const char *name = to_platform_device(port->dev)->name;
 	u32 val;
 	int ret;
@@ -568,15 +567,6 @@ static int stm32_startup(struct uart_port *port)
 	if (ret)
 		return ret;
 
-	if (cfg->has_wakeup && stm32_port->wakeirq >= 0) {
-		ret = dev_pm_set_dedicated_wake_irq(port->dev,
-						    stm32_port->wakeirq);
-		if (ret) {
-			free_irq(port->irq, port);
-			return ret;
-		}
-	}
-
 	val = USART_CR1_RXNEIE | USART_CR1_TE | USART_CR1_RE;
 	if (stm32_port->fifoen)
 		val |= USART_CR1_FIFOEN;
@@ -607,7 +597,6 @@ static void stm32_shutdown(struct uart_port *port)
 
 	stm32_clr_bits(port, ofs->cr1, val);
 
-	dev_pm_clear_wake_irq(port->dev);
 	free_irq(port->irq, port);
 }
 
@@ -1079,11 +1068,18 @@ static int stm32_serial_probe(struct platform_device *pdev)
 		ret = device_init_wakeup(&pdev->dev, true);
 		if (ret)
 			goto err_uninit;
+
+		ret = dev_pm_set_dedicated_wake_irq(&pdev->dev,
+						    stm32port->wakeirq);
+		if (ret)
+			goto err_nowup;
+
+		device_set_wakeup_enable(&pdev->dev, false);
 	}
 
 	ret = uart_add_one_port(&stm32_usart_driver, &stm32port->port);
 	if (ret)
-		goto err_nowup;
+		goto err_wirq;
 
 	ret = stm32_of_dma_rx_probe(stm32port, pdev);
 	if (ret)
@@ -1097,6 +1093,10 @@ static int stm32_serial_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_wirq:
+	if (stm32port->info->cfg.has_wakeup && stm32port->wakeirq >= 0)
+		dev_pm_clear_wake_irq(&pdev->dev);
+
 err_nowup:
 	if (stm32port->info->cfg.has_wakeup && stm32port->wakeirq >= 0)
 		device_init_wakeup(&pdev->dev, false);
@@ -1134,8 +1134,10 @@ static int stm32_serial_remove(struct platform_device *pdev)
 				  TX_BUF_L, stm32_port->tx_buf,
 				  stm32_port->tx_dma_buf);
 
-	if (cfg->has_wakeup && stm32_port->wakeirq >= 0)
+	if (cfg->has_wakeup && stm32_port->wakeirq >= 0) {
+		dev_pm_clear_wake_irq(&pdev->dev);
 		device_init_wakeup(&pdev->dev, false);
+	}
 
 	clk_disable_unprepare(stm32_port->clk);
 
-- 
2.20.1



