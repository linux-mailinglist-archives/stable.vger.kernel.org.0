Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E7163DE0B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiK3SdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiK3SdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B332B2EF4C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 696FCB81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D67C433C1;
        Wed, 30 Nov 2022 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833184;
        bh=f+lxCLA+CNJtDVBpW/eLQdk9ausdDEo9yuAXKj/QmqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH48SBRN+6ipgipTZ4+tGRRSW1vpqWIEsMXE9Am5VdJ8qrgF/PB2nJhqTw1STkaQr
         dUmVhXxgsFAcUmCFcYzBSmGMO+aZC8+U//ZOBB1JP9wFFdiK39f5z5ef7kPpn80I3V
         UotLHPviGWj/Gh0GDjUqfJrCqpmPVOaXHwgSYRTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/206] serial: fsl_lpuart: Fill in rs485_supported
Date:   Wed, 30 Nov 2022 19:20:56 +0100
Message-Id: <20221130180533.096405962@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 07481f448b635d7cebb92d5940f5bea5c4395a26 ]

Add information on supported serial_rs485 features.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220606100433.13793-16-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 76bad3f88750 ("tty: serial: fsl_lpuart: don't break the on-going transfer when global reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 44ed4285e1ef..1d13d88ea363 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2644,6 +2644,11 @@ static struct uart_driver lpuart_reg = {
 	.cons		= LPUART_CONSOLE,
 };
 
+static const struct serial_rs485 lpuart_rs485_supported = {
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND,
+	/* delay_rts_* and RX_DURING_TX are not supported */
+};
+
 static int lpuart_probe(struct platform_device *pdev)
 {
 	const struct lpuart_soc_data *sdata = of_device_get_match_data(&pdev->dev);
@@ -2683,6 +2688,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		sport->port.rs485_config = lpuart32_config_rs485;
 	else
 		sport->port.rs485_config = lpuart_config_rs485;
+	sport->port.rs485_supported = &lpuart_rs485_supported;
 
 	sport->ipg_clk = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(sport->ipg_clk)) {
-- 
2.35.1



