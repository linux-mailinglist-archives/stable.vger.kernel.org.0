Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E65B4FB5DA
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 10:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbiDKIXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 04:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiDKIXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 04:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB1E3E0DD;
        Mon, 11 Apr 2022 01:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15C63B81116;
        Mon, 11 Apr 2022 08:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1856C385A3;
        Mon, 11 Apr 2022 08:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649665286;
        bh=4+LOnSStvWlAPl01BPsjosP7fQbotLCvIhbQuoTuxEI=;
        h=From:To:Cc:Subject:Date:From;
        b=PhYufBekLXyrTi8xBJ3iWg0X58bvoSJ+Z3uBXUXl0rxUZH++UQ5mxSjQbmaqXwLSe
         WplY5qSXzTgFd6ZhrtO0LEbEAcpHp6veVQJjhcRLeFLpKGb0bBbjwzsB+rle5DHuga
         R+Q6J+Z0DZ/uvf7/ryr34i717ksxZrHfKodU7veh6MS97ETS5Eg14mDm8Yt0+Cf8ln
         7EQvXu2N9DMRgcFfFgKa3LRB8iVVYsph4/h0wHMu8K7W4c3efos7Ig58hGcjsJk/qr
         2Hga8mHvMO9J9lFedQGsaShc21aI34SLCZccTvW6Zn6SymTs3qxfMPADNnXsqJ7XIj
         AXuol3yqUtTdw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ndpIW-00023s-1E; Mon, 11 Apr 2022 10:21:20 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH] serial: imx: fix overrun interrupts in DMA mode
Date:   Mon, 11 Apr 2022 10:19:57 +0200
Message-Id: <20220411081957.7846-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 76821e222c18 ("serial: imx: ensure that RX irqs are off if RX is
off") accidentally enabled overrun interrupts unconditionally when
deferring DMA enable until after the receiver has been enabled during
startup.

Fix this by using the DMA-initialised instead of DMA-enabled flag to
determine whether overrun interrupts should be enabled.

Note that overrun interrupts are already accounted for in
imx_uart_clear_rx_errors() when using DMA since commit 41d98b5da92f
("serial: imx-serial - update RX error counters when DMA is used").

Fixes: 76821e222c18 ("serial: imx: ensure that RX irqs are off if RX is off")
Cc: stable@vger.kernel.org      # 4.17
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index fd38e6ed4fda..a2100be8d554 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1448,7 +1448,7 @@ static int imx_uart_startup(struct uart_port *port)
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4) & ~(UCR4_OREN | UCR4_INVR);
-	if (!sport->dma_is_enabled)
+	if (!dma_is_inited)
 		ucr4 |= UCR4_OREN;
 	if (sport->inverted_rx)
 		ucr4 |= UCR4_INVR;
-- 
2.35.1

