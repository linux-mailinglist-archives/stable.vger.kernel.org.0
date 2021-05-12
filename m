Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C9D37CBC2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbhELQhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234087AbhELQ2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB79961936;
        Wed, 12 May 2021 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834974;
        bh=s6ooNlwQdXo7YqgkRh3gcTgX+pdykZEMcqpxkxJUl/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+Cb1fD2dkVWkfF62toMfYtpx+JrJCgnJLsEvvbhJw9HCAQEnIjiqqPpc2iasN1pb
         ailhTC43TujLX9XuFnx6/E8CoynWUU2biQbaW31xwUCxrPRvIsCCQ81u0pgFmEjOyp
         XXGPzfxEP1Bu4doqE0zixw5ObhIBQ7wbsS80ZSuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 159/677] serial: stm32: fix probe and remove order for dma
Date:   Wed, 12 May 2021 16:43:25 +0200
Message-Id: <20210512144842.531917183@linuxfoundation.org>
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

[ Upstream commit 87fd0741d6dcf63ebdb14050c2b921ae14c7f307 ]

The probe and remove orders are wrong as the uart_port is registered
before saving device data in the probe, and unregistered after DMA
resource deallocation in the remove. uart_port registering should be
done at the end of probe and unregistering should be done at the begin of
remove to avoid resource allocation issues.

Fix probe and remove orders. This enforce resource allocation occur at
proper time.
Terminate both DMA rx and tx transfers before removing device.

Move pm_runtime after uart_remove_one_port() call in remove() to keep the
probe error path.

Fixes: 3489187204eb ("serial: stm32: adding dma support")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-2-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 57 ++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index b3675cf25a69..3d58824ac2af 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1252,10 +1252,6 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 		device_set_wakeup_enable(&pdev->dev, false);
 	}
 
-	ret = uart_add_one_port(&stm32_usart_driver, &stm32port->port);
-	if (ret)
-		goto err_wirq;
-
 	ret = stm32_usart_of_dma_rx_probe(stm32port, pdev);
 	if (ret)
 		dev_info(&pdev->dev, "interrupt mode used for rx (no dma)\n");
@@ -1269,11 +1265,40 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
+
+	ret = uart_add_one_port(&stm32_usart_driver, &stm32port->port);
+	if (ret)
+		goto err_port;
+
 	pm_runtime_put_sync(&pdev->dev);
 
 	return 0;
 
-err_wirq:
+err_port:
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+
+	if (stm32port->rx_ch) {
+		dmaengine_terminate_async(stm32port->rx_ch);
+		dma_release_channel(stm32port->rx_ch);
+	}
+
+	if (stm32port->rx_dma_buf)
+		dma_free_coherent(&pdev->dev,
+				  RX_BUF_L, stm32port->rx_buf,
+				  stm32port->rx_dma_buf);
+
+	if (stm32port->tx_ch) {
+		dmaengine_terminate_async(stm32port->tx_ch);
+		dma_release_channel(stm32port->tx_ch);
+	}
+
+	if (stm32port->tx_dma_buf)
+		dma_free_coherent(&pdev->dev,
+				  TX_BUF_L, stm32port->tx_buf,
+				  stm32port->tx_dma_buf);
+
 	if (stm32port->wakeirq > 0)
 		dev_pm_clear_wake_irq(&pdev->dev);
 
@@ -1295,11 +1320,20 @@ static int stm32_usart_serial_remove(struct platform_device *pdev)
 	int err;
 
 	pm_runtime_get_sync(&pdev->dev);
+	err = uart_remove_one_port(&stm32_usart_driver, port);
+	if (err)
+		return(err);
+
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 
 	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAR);
 
-	if (stm32_port->rx_ch)
+	if (stm32_port->rx_ch) {
+		dmaengine_terminate_async(stm32_port->rx_ch);
 		dma_release_channel(stm32_port->rx_ch);
+	}
 
 	if (stm32_port->rx_dma_buf)
 		dma_free_coherent(&pdev->dev,
@@ -1308,8 +1342,10 @@ static int stm32_usart_serial_remove(struct platform_device *pdev)
 
 	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 
-	if (stm32_port->tx_ch)
+	if (stm32_port->tx_ch) {
+		dmaengine_terminate_async(stm32_port->tx_ch);
 		dma_release_channel(stm32_port->tx_ch);
+	}
 
 	if (stm32_port->tx_dma_buf)
 		dma_free_coherent(&pdev->dev,
@@ -1323,12 +1359,7 @@ static int stm32_usart_serial_remove(struct platform_device *pdev)
 
 	stm32_usart_deinit_port(stm32_port);
 
-	err = uart_remove_one_port(&stm32_usart_driver, port);
-
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_put_noidle(&pdev->dev);
-
-	return err;
+	return 0;
 }
 
 #ifdef CONFIG_SERIAL_STM32_CONSOLE
-- 
2.30.2



