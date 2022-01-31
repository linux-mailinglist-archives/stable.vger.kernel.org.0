Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A214A4167
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358448AbiAaLDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50434 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348665AbiAaLC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1118AB82A5D;
        Mon, 31 Jan 2022 11:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9ADC340E8;
        Mon, 31 Jan 2022 11:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626946;
        bh=6NHEPOCdbLajHTXCT6/7QGmrW1avCiXJhoiMG0d+svg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xd44LJJEONGHcpaeVLse/MqoFeWjLtUMcz4mIj7jrZCIVgR4gVqzgHISO8hIoO9/q
         xFrP4ym/4gxrQvhCvKBQnKp98lCSt5ENXAJZ2aaLoTpvo+3dIcoKODpQeNvA5Vz3Ce
         VHNmoeaXiyfyBkBhbRvqDDc9gKf3jF/V4tUsKw4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Valentin Caron <valentin.caron@foss.st.com>
Subject: [PATCH 5.10 025/100] serial: stm32: fix software flow control transfer
Date:   Mon, 31 Jan 2022 11:55:46 +0100
Message-Id: <20220131105221.310598828@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
@@ -574,7 +574,7 @@ static void stm32_usart_start_tx(struct
 	struct serial_rs485 *rs485conf = &port->rs485;
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit) && !port->x_char)
 		return;
 
 	if (rs485conf->flags & SER_RS485_ENABLED) {


