Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1245657C01
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiL1P1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiL1P1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFD11409F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A786C6152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE550C433EF;
        Wed, 28 Dec 2022 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241264;
        bh=L4HOynuojP2OpWV5mn8z5MgOqF0nYwEKQpFd26sPJ8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gobch21mmPKBNl7U2BNVKZbqhuDr0MJ0Di4vVf0u3NXdujdWQz35F9P158iCt/6ss
         9hPkWtMPX5+AOVODObffyZC07pmR00Oj6rdURvDZ5yc5BYX/W0Nzj2Yq3o4PqbOrG5
         tYCmwwJnXcUiHZEEIMXqj0y8bTgudSx7dkqedXG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Valentin Caron <valentin.caron@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 459/731] serial: stm32: move dma_request_chan() before clk_prepare_enable()
Date:   Wed, 28 Dec 2022 15:39:26 +0100
Message-Id: <20221228144309.858081206@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Caron <valentin.caron@foss.st.com>

[ Upstream commit 0d114e9ff940ebad8e88267013bf96c605a6b336 ]

If dma_request_chan() returns a PROBE_DEFER error, clk_disable_unprepare()
will be called and USART clock will be disabled. But early console can be
still active on the same USART.

While moving dma_request_chan() before clk_prepare_enable(), the clock
won't be taken in case of a DMA PROBE_DEFER error, and so it doesn't need
to be disabled. Then USART is still clocked for early console.

Fixes: a7770a4bfcf4 ("serial: stm32: defer probe for dma devices")
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20221118170602.1057863-1-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 47 ++++++++++++++++----------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index ce7ff7a0207f..5c60960e185d 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1363,22 +1363,10 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	if (!stm32port->info)
 		return -EINVAL;
 
-	ret = stm32_usart_init_port(stm32port, pdev);
-	if (ret)
-		return ret;
-
-	if (stm32port->wakeup_src) {
-		device_set_wakeup_capable(&pdev->dev, true);
-		ret = dev_pm_set_wake_irq(&pdev->dev, stm32port->port.irq);
-		if (ret)
-			goto err_deinit_port;
-	}
-
 	stm32port->rx_ch = dma_request_chan(&pdev->dev, "rx");
-	if (PTR_ERR(stm32port->rx_ch) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
-		goto err_wakeirq;
-	}
+	if (PTR_ERR(stm32port->rx_ch) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
 	/* Fall back in interrupt mode for any non-deferral error */
 	if (IS_ERR(stm32port->rx_ch))
 		stm32port->rx_ch = NULL;
@@ -1392,6 +1380,17 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	if (IS_ERR(stm32port->tx_ch))
 		stm32port->tx_ch = NULL;
 
+	ret = stm32_usart_init_port(stm32port, pdev);
+	if (ret)
+		goto err_dma_tx;
+
+	if (stm32port->wakeup_src) {
+		device_set_wakeup_capable(&pdev->dev, true);
+		ret = dev_pm_set_wake_irq(&pdev->dev, stm32port->port.irq);
+		if (ret)
+			goto err_deinit_port;
+	}
+
 	if (stm32port->rx_ch && stm32_usart_of_dma_rx_probe(stm32port, pdev)) {
 		/* Fall back in interrupt mode */
 		dma_release_channel(stm32port->rx_ch);
@@ -1428,19 +1427,11 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 
-	if (stm32port->tx_ch) {
+	if (stm32port->tx_ch)
 		stm32_usart_of_dma_tx_remove(stm32port, pdev);
-		dma_release_channel(stm32port->tx_ch);
-	}
-
 	if (stm32port->rx_ch)
 		stm32_usart_of_dma_rx_remove(stm32port, pdev);
 
-err_dma_rx:
-	if (stm32port->rx_ch)
-		dma_release_channel(stm32port->rx_ch);
-
-err_wakeirq:
 	if (stm32port->wakeup_src)
 		dev_pm_clear_wake_irq(&pdev->dev);
 
@@ -1450,6 +1441,14 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 
 	stm32_usart_deinit_port(stm32port);
 
+err_dma_tx:
+	if (stm32port->tx_ch)
+		dma_release_channel(stm32port->tx_ch);
+
+err_dma_rx:
+	if (stm32port->rx_ch)
+		dma_release_channel(stm32port->rx_ch);
+
 	return ret;
 }
 
-- 
2.35.1



