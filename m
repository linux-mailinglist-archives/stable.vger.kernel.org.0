Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7063C4709
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbhGLGbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236018AbhGLG3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91AE60FE3;
        Mon, 12 Jul 2021 06:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071205;
        bh=Tuwmd8AtOPKo4ijqTTBtSqPkHGXKl1uyhUbkw1r3fpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvQ+DAfhVWzhwscKQQ6/tqRcJ9EJ+Is27RyJo8YUiGYk/5cC68eYADXUYSk2UlObz
         sESbqR8KiMRouO74h9TSvj0njbD/rBmSJgDsMO5qOvivxwtZPY8X8zLJB+AiRmrDqX
         Gk3O+BjNvklawBpR+l5jghUDuMdOCXvWty5zOObg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 319/348] serial: 8250: Actually allow UPF_MAGIC_MULTIPLIER baud rates
Date:   Mon, 12 Jul 2021 08:11:43 +0200
Message-Id: <20210712060746.313626984@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 78bcae8616ac277d6cb7f38e211493948ed73e30 ]

Support for magic baud rate divisors of 32770 and 32769 used with SMSC
Super I/O chips for extra baud rates of 230400 and 460800 respectively
where base rate is 115200[1] has been added around Linux 2.5.64, which
predates our repo history, but the origin could be identified as commit
2a717aad772f ("Merge with Linux 2.5.64.") with the old MIPS/Linux repo
also at: <git://git.kernel.org/pub/scm/linux/kernel/git/ralf/linux.git>.

Code that is now in `serial8250_do_get_divisor' was added back then to
`serial8250_get_divisor', but that code would only ever trigger if one
of the higher baud rates was actually requested, and that cannot ever
happen, because the earlier call to `serial8250_get_baud_rate' never
returns them.  This is because it calls `uart_get_baud_rate' with the
maximum requested being the base rate, that is clk/16 or 115200 for SMSC
chips at their nominal clock rate.

Fix it then and allow UPF_MAGIC_MULTIPLIER baud rates to be selected, by
requesting the maximum baud rate of clk/4 rather than clk/16 if the flag
has been set.  Also correct the minimum baud rate, observing that these
ports only support actual (non-magic) divisors of up to 32767 only.


[1] "FDC37M81x, PC98/99 Compliant Enhanced Super I/O Controller with
    Keyboard/Mouse Wake-Up", Standard Microsystems Corporation, Rev.
    03/27/2000, Table 31 - "Baud Rates", p. 77

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2105190412280.29169@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 5b673077639b..6e93aa3623d9 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2557,6 +2557,21 @@ static unsigned int serial8250_get_baud_rate(struct uart_port *port,
 					     struct ktermios *old)
 {
 	unsigned int tolerance = port->uartclk / 100;
+	unsigned int min;
+	unsigned int max;
+
+	/*
+	 * Handle magic divisors for baud rates above baud_base on SMSC
+	 * Super I/O chips.  Enable custom rates of clk/4 and clk/8, but
+	 * disable divisor values beyond 32767, which are unavailable.
+	 */
+	if (port->flags & UPF_MAGIC_MULTIPLIER) {
+		min = port->uartclk / 16 / UART_DIV_MAX >> 1;
+		max = (port->uartclk + tolerance) / 4;
+	} else {
+		min = port->uartclk / 16 / UART_DIV_MAX;
+		max = (port->uartclk + tolerance) / 16;
+	}
 
 	/*
 	 * Ask the core to calculate the divisor for us.
@@ -2564,9 +2579,7 @@ static unsigned int serial8250_get_baud_rate(struct uart_port *port,
 	 * slower than nominal still match standard baud rates without
 	 * causing transmission errors.
 	 */
-	return uart_get_baud_rate(port, termios, old,
-				  port->uartclk / 16 / UART_DIV_MAX,
-				  (port->uartclk + tolerance) / 16);
+	return uart_get_baud_rate(port, termios, old, min, max);
 }
 
 void
-- 
2.30.2



