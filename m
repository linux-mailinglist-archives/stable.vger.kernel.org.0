Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DDC5950A9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiHPEo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiHPEnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:43:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C94D3998;
        Mon, 15 Aug 2022 13:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B377E611D2;
        Mon, 15 Aug 2022 20:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF8C433C1;
        Mon, 15 Aug 2022 20:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595977;
        bh=FlZRgnf0Nis8Q7Zg7eYvSYAnXAGbYEO4arB46zxJ7y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIdd/0askqFcfjrZpM/3dPjCoy3Z0f34yP5dyIIHC3CROgjSL6o737Gih6/3fD6Zm
         xdETYGFW4byl4JnoEbQQK17pXVHshfoYcU7uwSXD+yLvtB5Y+zlyB/upitMYt7ysWR
         XP9TQx/8+a+wTGyQL27hUEbylcqKKFFiXdSWn1AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0901/1157] serial: 8250_dw: Use serial_lsr_in() in dw8250_handle_irq()
Date:   Mon, 15 Aug 2022 20:04:17 +0200
Message-Id: <20220815180515.506070164@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 197eb5c416ff0e52d152e6ff59b4e759d2f3e10d ]

dw8250_handle_irq() reads LSR under a few conditions, convert both to
use serial_lsr_in() in order to preserve LSR flags properly across
reads.

Fixes: 424d79183af0 ("serial: 8250_dw: Avoid "too much work" from bogus rx timeout interrupt")
Fixes: aa63d786cea2 ("serial: 8250: dw: Add support for DMA flow controlling devices")
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220608095431.18376-6-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index bb6aca07ab56..7e05b431a314 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -253,7 +253,7 @@ static int dw8250_handle_irq(struct uart_port *p)
 	 */
 	if (!up->dma && rx_timeout) {
 		spin_lock_irqsave(&p->lock, flags);
-		status = p->serial_in(p, UART_LSR);
+		status = serial_lsr_in(up);
 
 		if (!(status & (UART_LSR_DR | UART_LSR_BI)))
 			(void) p->serial_in(p, UART_RX);
@@ -263,7 +263,7 @@ static int dw8250_handle_irq(struct uart_port *p)
 
 	/* Manually stop the Rx DMA transfer when acting as flow controller */
 	if (quirks & DW_UART_QUIRK_IS_DMA_FC && up->dma && up->dma->rx_running && rx_timeout) {
-		status = p->serial_in(p, UART_LSR);
+		status = serial_lsr_in(up);
 		if (status & (UART_LSR_DR | UART_LSR_BI)) {
 			dw8250_writel_ext(p, RZN1_UART_RDMACR, 0);
 			dw8250_writel_ext(p, DW_UART_DMASA, 1);
-- 
2.35.1



