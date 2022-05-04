Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AB951A616
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350649AbiEDQwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353797AbiEDQw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E05473A6;
        Wed,  4 May 2022 09:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C0A9B82552;
        Wed,  4 May 2022 16:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0496AC385B0;
        Wed,  4 May 2022 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682917;
        bh=dR2rosQz0KUtee7nTyTCC27JjP3MR6tspTPQM5RkkMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4TofSUHkVkCnk+3MPI++WadavhJrWFa9M8lx1Advn6a2e+O0Y00SNUUnJlC/dt/m
         Dp8mUi9KZ3QyyoJ4X/yKe1YQcuC4s45hpnqpL6FgUvM3r/sPL6JROB+L62c/XkJN0i
         d4GLJXwod2wRqZi4SjngBXuC440VHYpdZuG39fMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 23/84] serial: imx: fix overrun interrupts in DMA mode
Date:   Wed,  4 May 2022 18:44:04 +0200
Message-Id: <20220504152929.410802997@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3ee82c6e41f3d2212647ce0bc5a05a0f69097824 upstream.

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
Link: https://lore.kernel.org/r/20220411081957.7846-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1401,7 +1401,7 @@ static int imx_uart_startup(struct uart_
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4) & ~UCR4_OREN;
-	if (!sport->dma_is_enabled)
+	if (!dma_is_inited)
 		ucr4 |= UCR4_OREN;
 	imx_uart_writel(sport, ucr4, UCR4);
 


