Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD574A6393
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbiBASSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:18:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57220 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242186AbiBASSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:18:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6235161422;
        Tue,  1 Feb 2022 18:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46250C340EC;
        Tue,  1 Feb 2022 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739489;
        bh=kUEHbF20FQ8ArVttZV69fjTk8yWwV1S7D1FjlWN4r18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcQDuPobBQ/IwtluZwh1Yp/iTSrPnxq+7VOZogQJ3pit340uP8p5yGhDdsVcILSTR
         7pCCiIxCzn2RvC2hREKf+A1yN3LI1MrBbVfVEcndT/LyafHwGhjjK10Zl7IAucVnwY
         EKx9BRiU+X2zG02E3fwkIBQ1SaVywnILYTgQJ0CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Valentin Caron <valentin.caron@foss.st.com>
Subject: [PATCH 4.4 08/25] serial: stm32: fix software flow control transfer
Date:   Tue,  1 Feb 2022 19:16:32 +0100
Message-Id: <20220201180822.426450929@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
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
@@ -279,7 +279,7 @@ static void stm32_start_tx(struct uart_p
 {
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit) && !port->x_char)
 		return;
 
 	stm32_set_bits(port, USART_CR1, USART_CR1_TXEIE | USART_CR1_TE);


