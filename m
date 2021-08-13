Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54AB3EB7F9
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhHMPKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241525AbhHMPJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:09:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE07861102;
        Fri, 13 Aug 2021 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867372;
        bh=SgPtoTRX39FrJpoWD/t+Qmi2BCly6j5lEvZ9ZkbZS+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoyNgjOVP71Rz9Omu7F5QdBFP/uCcmubbEX8M40nOjtlAugKDfByagH1FSXVDVBE7
         1wKsA1NrNSGrnBCZEiL+OREg3S3qlvc1yA9V81W54DMBBoPzDIzAh/BZFgYNl2U6RI
         SdSAIloD5YP64HOXV96EFo8vTWqe6sGpqUWechZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 4.9 19/30] serial: 8250: Mask out floating 16/32-bit bus bits
Date:   Fri, 13 Aug 2021 17:06:47 +0200
Message-Id: <20210813150523.059002478@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit e5227c51090e165db4b48dcaa300605bfced7014 upstream.

Make sure only actual 8 bits of the IIR register are used in determining
the port type in `autoconfig'.

The `serial_in' port accessor returns the `unsigned int' type, meaning
that with UPIO_AU, UPIO_MEM16, UPIO_MEM32, and UPIO_MEM32BE access types
more than 8 bits of data are returned, of which the high order bits will
often come from bus lines that are left floating in the data phase.  For
example with the MIPS Malta board's CBUS UART, where the registers are
aligned on 8-byte boundaries and which uses 32-bit accesses, data as
follows is returned:

YAMON> dump -32 0xbf000900 0x40

BF000900: 1F000942 1F000942 1F000900 1F000900  ...B...B........
BF000910: 1F000901 1F000901 1F000900 1F000900  ................
BF000920: 1F000900 1F000900 1F000960 1F000960  ...........`...`
BF000930: 1F000900 1F000900 1F0009FF 1F0009FF  ................

YAMON>

Evidently high-order 24 bits return values previously driven in the
address phase (the 3 highest order address bits used with the command
above are masked out in the simple virtual address mapping used here and
come out at zeros on the external bus), a common scenario with bus lines
left floating, due to bus capacitance.

Consequently when the value of IIR, mapped at 0x1f000910, is retrieved
in `autoconfig', it comes out at 0x1f0009c1 and when it is right-shifted
by 6 and then assigned to 8-bit `scratch' variable, the value calculated
is 0x27, not one of 0, 1, 2, 3 expected in port type determination.

Fix the issue then, by assigning the value returned from `serial_in' to
`scratch' first, which masks out 24 high-order bits retrieved, and only
then right-shift the resulting 8-bit data quantity, producing the value
of 3 in this case, as expected.  Fix the same issue in `serial_dl_read'.

The problem first appeared with Linux 2.6.9-rc3 which predates our repo
history, but the origin could be identified with the old MIPS/Linux repo
also at: <git://git.kernel.org/pub/scm/linux/kernel/git/ralf/linux.git>
as commit e0d2356c0777 ("Merge with Linux 2.6.9-rc3."), where code in
`serial_in' was updated with this case:

+	case UPIO_MEM32:
+		return readl(up->port.membase + offset);
+

which made it produce results outside the unsigned 8-bit range for the
first time, though obviously it is system dependent what actual values
appear in the high order bits retrieved and it may well have been zeros
in the relevant positions with the system the change originally was
intended for.  It is at that point that code in `autoconf' should have
been updated accordingly, but clearly it was overlooked.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org # v2.6.12+
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2106260516220.37803@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -277,7 +277,11 @@ static const struct serial8250_config ua
 /* Uart divisor latch read */
 static int default_serial_dl_read(struct uart_8250_port *up)
 {
-	return serial_in(up, UART_DLL) | serial_in(up, UART_DLM) << 8;
+	/* Assign these in pieces to truncate any bits above 7.  */
+	unsigned char dll = serial_in(up, UART_DLL);
+	unsigned char dlm = serial_in(up, UART_DLM);
+
+	return dll | dlm << 8;
 }
 
 /* Uart divisor latch write */
@@ -1262,9 +1266,11 @@ static void autoconfig(struct uart_8250_
 	serial_out(up, UART_LCR, 0);
 
 	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
-	scratch = serial_in(up, UART_IIR) >> 6;
 
-	switch (scratch) {
+	/* Assign this as it is to truncate any bits above 7.  */
+	scratch = serial_in(up, UART_IIR);
+
+	switch (scratch >> 6) {
 	case 0:
 		autoconfig_8250(up);
 		break;


