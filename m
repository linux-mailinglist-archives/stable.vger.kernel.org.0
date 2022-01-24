Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1AA49A246
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365655AbiAXXv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578647AbiAXWDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:03:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573A9C036BF6;
        Mon, 24 Jan 2022 12:41:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBA7061008;
        Mon, 24 Jan 2022 20:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE042C340E5;
        Mon, 24 Jan 2022 20:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056908;
        bh=8FkV0WtrVsrhL39FmDN47upyPEIVbo4YCWDOsiA95Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsbMrF+F9Cwif76Fr1tJ+mkbM2TSikyv420/XVj9tHBpIhqCLmtNDD9sVN1dcs0/J
         xOWTJx1B9dc0floapjRIbE4aOWHYbq1JZCalSjKIyWoLtwhAaeMnKmEed7+t87I9H4
         zmLNyCb4NwVVAieXWmf/SJA1rJy69m+LlMq0/Adw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Lukas Wunner <lukas@wunner.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 612/846] serial: pl011: Drop CR register reset on set_termios
Date:   Mon, 24 Jan 2022 19:42:09 +0100
Message-Id: <20220124184122.148545675@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit e368cc656fd6d0075f1c3ab9676e2001451e3e04 ]

pl011_set_termios() briefly resets the CR register to zero, thereby
glitching DTR/RTS signals.  With rs485 this may result in the bus being
occupied for no reason.

Where does this register write originate from?

The PL011 driver was forked from the PL010 driver in 2004:
https://git.kernel.org/history/history/c/157c0342e591

Until this commit, the PL010 driver's IRQ handler ambauart_int()
modified the CR register without holding the port spinlock.

ambauart_set_termios() also modified that register.  To prevent
concurrent read-modify-writes by the IRQ handler and to prevent
transmission while changing baudrate, ambauart_set_termios() had to
disable interrupts.  On the PL010, that is achieved by writing zero to
the CR register.

However, on the PL011, interrupts are disabled in the IMSC register,
not in the CR register.

Additionally, the commit amended both the PL010 and PL011 driver to
acquire the port spinlock in the IRQ handler, obviating the need to
disable interrupts in ->set_termios().

So the CR register write is obsolete for two reasons.  Drop it.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/f49f945375f5ccb979893c49f1129f51651ac738.1641129062.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index b831d4d64c0a2..6ec34260d6b18 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2105,9 +2105,7 @@ pl011_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (port->rs485.flags & SER_RS485_ENABLED)
 		termios->c_cflag &= ~CRTSCTS;
 
-	/* first, disable everything */
 	old_cr = pl011_read(uap, REG_CR);
-	pl011_write(0, uap, REG_CR);
 
 	if (termios->c_cflag & CRTSCTS) {
 		if (old_cr & UART011_CR_RTS)
-- 
2.34.1



