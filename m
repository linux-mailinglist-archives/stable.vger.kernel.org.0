Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1C658171
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiL1Q2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbiL1Q2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A9C321
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B95E0B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE97C433D2;
        Wed, 28 Dec 2022 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244649;
        bh=CqE0CSaAkh3PlO1as11d/7BWmNUkGMRRYasRiRMzpD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKQeygcwfsWdyRNEf0ggmtfNcPZoiN69DG4VN6+fIlDaoEOBuUiuDLPF1UDszeFgc
         fsxG+QjIHVyUnrTM1fohTa9FRcb/jlOF9EYMjmsbfHzYSoa8kF7t07XdsvBmnJJzz5
         wA4hbLhG2BUv0V3Jlbi3jkZgL6VmKiWSuIGSihw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Valentin Caron <valentin.caron@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0709/1146] serial: stm32: move dma_request_chan() before clk_prepare_enable()
Date:   Wed, 28 Dec 2022 15:37:28 +0100
Message-Id: <20221228144349.404855198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index dfdbcf092fac..b8aed28b8f17 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1681,22 +1681,10 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
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
@@ -1710,6 +1698,17 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
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
@@ -1746,19 +1745,11 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
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
 
@@ -1768,6 +1759,14 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 
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



