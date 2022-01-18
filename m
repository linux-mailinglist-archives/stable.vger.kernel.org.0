Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E73491A7F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352452AbiARDAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345915AbiARCsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:48:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F0BC06174E;
        Mon, 17 Jan 2022 18:39:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24BBEB8125F;
        Tue, 18 Jan 2022 02:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0CDC36AEB;
        Tue, 18 Jan 2022 02:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473577;
        bh=s/Gb1+A0zdS6AV7USnmioZzAIOaTo9cubpQqrOa/pnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N90EAq8SrnIFnnVF/k6RjWu1IRleFZEk4/8SfSS+cidW0W5VGCPb4UeFM+tDj0JaN
         b6f4nQVA1616P8Y+tN7PawdRRa2+kn5rNcQYuZJyGUUO3tdnwmZQPKSduFRrWbIVgs
         DQFC9B7Ngzbw6xTpwXd1PYrAOK+FoHktAq1gMV3lyW8g6PlCr6Wv8iTZMx004lFyhG
         10xSFX3l8uNnwgh8cNYRmTNPVQorywTzHGRtR0Pcl8QPT3TIvcvwpcufd+OCWnQVrT
         6dUdyPv4SfzuP5wxu7d5P/vKoWRYSzQw94gR422c1rV0qUt3/vv60LeNMdYmaaZx8y
         giefyDf8GXo/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        jirislaby@kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 177/188] serial: pl011: Drop CR register reset on set_termios
Date:   Mon, 17 Jan 2022 21:31:41 -0500
Message-Id: <20220118023152.1948105-177-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 52518a606c06a..9b1b0d9bdf7be 100644
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

