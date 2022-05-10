Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC05A521772
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbiEJNZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242944AbiEJNZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D865F229069;
        Tue, 10 May 2022 06:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48310CE1E73;
        Tue, 10 May 2022 13:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E60C385A6;
        Tue, 10 May 2022 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188704;
        bh=KuEDchK1xt4RAfy8GkCUQ79VgEtPAkixDOkJZp07Tyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBIfxceSxuOzdvp+qrKyCxIq7fUJOSgW/qcB3f4fmI6bT9+FSCKWzkZwgmWRr8PMv
         OAyPRTv4+QH1q32TIJ00CsmAZUBpcLdjz1sT9cGRIDRtlMxXGgSWvUp7pu0301RTZe
         nI+S2xCI0LuAKcybNBqekOKyURy62jy+i6yxILyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 17/88] serial: imx: fix overrun interrupts in DMA mode
Date:   Tue, 10 May 2022 15:07:02 +0200
Message-Id: <20220510130734.246749915@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
@@ -1369,7 +1369,7 @@ static int imx_uart_startup(struct uart_
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4) & ~UCR4_OREN;
-	if (!sport->dma_is_enabled)
+	if (!dma_is_inited)
 		ucr4 |= UCR4_OREN;
 	imx_uart_writel(sport, ucr4, UCR4);
 


