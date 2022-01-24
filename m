Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DD9498A24
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344487AbiAXTBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:01:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56920 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344054AbiAXS7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:59:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EDAEB81232;
        Mon, 24 Jan 2022 18:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE3DC340E8;
        Mon, 24 Jan 2022 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050756;
        bh=mOa3viRnCiyugN9lsjwtjitWUVuvU+gNzpDpjLjWNzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwoAm/SKUAqIeRNVaFY9g5m6hhBwAyQYw71Q0oNmpcUx5v185nDozUBxnFTzJAuxt
         7U5wGz7KLACcOaVgRXV1eT5aPPWxloHIXzrIzZr+tjQnWvRf2mDNM0E9rFHrN06O6G
         tDl7LZcZor3J63bhj3eGbYj16SP4FCtm2jXRC0Co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Lukas Wunner <lukas@wunner.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 102/157] serial: pl010: Drop CR register reset on set_termios
Date:   Mon, 24 Jan 2022 19:43:12 +0100
Message-Id: <20220124183935.998455892@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 08a0c6dff91c965e39905cf200d22db989203ccb ]

pl010_set_termios() briefly resets the CR register to zero.

Where does this register write come from?

The PL010 driver's IRQ handler ambauart_int() originally modified the CR
register without holding the port spinlock.  ambauart_set_termios() also
modified that register.  To prevent concurrent read-modify-writes by the
IRQ handler and to prevent transmission while changing baudrate,
ambauart_set_termios() had to disable interrupts.  That is achieved by
writing zero to the CR register.

However in 2004 the PL010 driver was amended to acquire the port
spinlock in the IRQ handler, obviating the need to disable interrupts in
->set_termios():
https://git.kernel.org/history/history/c/157c0342e591

That rendered the CR register write obsolete.  Drop it.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/fcaff16e5b1abb4cc3da5a2879ac13f278b99ed0.1641128728.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl010.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 5d41d5b92619a..7f4ba92739663 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -465,14 +465,11 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 	if ((termios->c_cflag & CREAD) == 0)
 		uap->port.ignore_status_mask |= UART_DUMMY_RSR_RX;
 
-	/* first, disable everything */
 	old_cr = readb(uap->port.membase + UART010_CR) & ~UART010_CR_MSIE;
 
 	if (UART_ENABLE_MS(port, termios->c_cflag))
 		old_cr |= UART010_CR_MSIE;
 
-	writel(0, uap->port.membase + UART010_CR);
-
 	/* Set baud rate */
 	quot -= 1;
 	writel((quot & 0xf00) >> 8, uap->port.membase + UART010_LCRM);
-- 
2.34.1



