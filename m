Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC2C4A44B2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349998AbiAaLcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379012AbiAaL3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3B4C0613F4;
        Mon, 31 Jan 2022 03:18:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB11361219;
        Mon, 31 Jan 2022 11:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF9C340EE;
        Mon, 31 Jan 2022 11:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627918;
        bh=sqyygVI7jB6s+EcdQCLiiMSNgGux1lWXm0JDOSxnCgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIPNcia1YKnoENBGhYMB7Z9Lgx/l/eH2jTy6Eb8+RpqI4Cp/K2eK/0oTC3xO99Lqd
         5U+5WxaSOtrwpqmh4Q6nVDytjWxKotsy6FDl7s7pbMZcVu5ZhlZZW/hHII0WczjFYb
         5UplVLGAQkaqlvulFutMP4g6nNJpy6McGljtmTWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Valentin Caron <valentin.caron@foss.st.com>
Subject: [PATCH 5.16 067/200] serial: stm32: fix software flow control transfer
Date:   Mon, 31 Jan 2022 11:55:30 +0100
Message-Id: <20220131105235.833558161@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Caron <valentin.caron@foss.st.com>

commit 037b91ec7729524107982e36ec4b40f9b174f7a2 upstream.

x_char is ignored by stm32_usart_start_tx() when xmit buffer is empty.

Fix start_tx condition to allow x_char to be sent.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20220111164441.6178-3-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -696,7 +696,7 @@ static void stm32_usart_start_tx(struct
 	struct serial_rs485 *rs485conf = &port->rs485;
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit) && !port->x_char)
 		return;
 
 	if (rs485conf->flags & SER_RS485_ENABLED) {


