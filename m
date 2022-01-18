Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BFC4914E6
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbiARCZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245310AbiARCXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC221C061755;
        Mon, 17 Jan 2022 18:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4D0E60AD9;
        Tue, 18 Jan 2022 02:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC5DC36AEB;
        Tue, 18 Jan 2022 02:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472603;
        bh=3kPQFQXrFwsqTMtVM9ew+ZI2qMLU4r4nNQNU7LoZqa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIdABt43/LTsoT3iZuNpD9DbEfR/6PBcH0OLS5cCXQKgcFpXjV2iI8hdfhTZS96og
         LvmdYOs91a3RBlFHdWKij7C79d9FricXKbO/r5MwZ5KrZp9OdL/UxSmXpNCwo4/d8B
         4LmpEh56KwJrbzD9k4ga4hJPww4ToK1pCJmoWnYRXVs0LJ8fP9Bofx0Ijz3WXMZKa8
         /w2yxcbo6xjYQtHpZKRyRFN6SIq0sxIVjtTDiKPx4SNadS4PLR3g708pXVRRagFmDT
         TJ9TEInUbJsW3f0Yiu297bw+PKJ1gSRxuHf1kH6r8tbrzVBGQx3VaAfH7KT7Pb9UA9
         TEwdacr9WC7Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        shawnguo@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 067/217] mxser: don't throttle manually
Date:   Mon, 17 Jan 2022 21:17:10 -0500
Message-Id: <20220118021940.1942199-67-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit c6693e6e07805f1b7822b13a5b482bf2b6a1f312 ]

First, checking tty->receive_room to signalize whether there is enough space
in the tty buffers does not make much sense. Provided the tty buffers
are in tty_port and those are not checked at all.

Second, if the rx path is throttled, with CRTSCTS, RTS is deasserted,
but is never asserted again. This leads to port "lockup", not accepting
any more input.

So:
1) stty -F /dev/ttyMI0 crtscts # the mxser port
2) stty -F /dev/ttyS6 crtscts # the connected port
3) cat /dev/ttyMI0
4) "write in a loop" to /dev/ttyS6
5) cat from 3) produces the bytes from 4)
6) killall -STOP cat (the 3)'s one)
7) wait for RTS to drop on /dev/ttyMI0
8) killall -CONT cat (again the 3)'s one)

cat erroneously produces no more output now (i.e. no data sent from
ttyS6 to ttyMI can be seen).

Note that the step 7) is performed twice: once from n_tty by
tty_throttle_safe(), once by mxser_stoprx() from the receive path. Then
after step 7), n_tty correctly unthrottles the input, but mxser calls
mxser_stoprx() again as there is still only a little space in n_tty
buffers (tty->receive_room mentioned at the beginning), but the device's
FIFO is/can be already filled.

After this patch, the output is correctly resumed, i.e. n_tty both
throttles and unthrottles without interfering with mxser's attempts.

This allows us to get rid of the non-standard ldisc_stop_rx flag from
struct mxser_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211118073125.12283-15-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/mxser.c | 36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 27caa2f9ba79b..3b5d193b7f245 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -251,8 +251,6 @@ struct mxser_port {
 	u8 MCR;			/* Modem control register */
 	u8 FCR;			/* FIFO control register */
 
-	bool ldisc_stop_rx;
-
 	struct async_icount icount; /* kernel counters for 4 input interrupts */
 	unsigned int timeout;
 
@@ -1323,11 +1321,14 @@ static int mxser_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
-static void mxser_stoprx(struct tty_struct *tty)
+/*
+ * This routine is called by the upper-layer tty layer to signal that
+ * incoming characters should be throttled.
+ */
+static void mxser_throttle(struct tty_struct *tty)
 {
 	struct mxser_port *info = tty->driver_data;
 
-	info->ldisc_stop_rx = true;
 	if (I_IXOFF(tty)) {
 		if (info->board->must_hwid) {
 			info->IER &= ~MOXA_MUST_RECV_ISR;
@@ -1346,21 +1347,11 @@ static void mxser_stoprx(struct tty_struct *tty)
 	}
 }
 
-/*
- * This routine is called by the upper-layer tty layer to signal that
- * incoming characters should be throttled.
- */
-static void mxser_throttle(struct tty_struct *tty)
-{
-	mxser_stoprx(tty);
-}
-
 static void mxser_unthrottle(struct tty_struct *tty)
 {
 	struct mxser_port *info = tty->driver_data;
 
 	/* startrx */
-	info->ldisc_stop_rx = false;
 	if (I_IXOFF(tty)) {
 		if (info->x_char)
 			info->x_char = 0;
@@ -1543,9 +1534,6 @@ static bool mxser_receive_chars_new(struct tty_struct *tty,
 	if (hwid == MOXA_MUST_MU150_HWID)
 		gdl &= MOXA_MUST_GDL_MASK;
 
-	if (gdl >= tty->receive_room && !port->ldisc_stop_rx)
-		mxser_stoprx(tty);
-
 	while (gdl--) {
 		u8 ch = inb(port->ioaddr + UART_RX);
 		tty_insert_flip_char(&port->port, ch, 0);
@@ -1558,10 +1546,8 @@ static u8 mxser_receive_chars_old(struct tty_struct *tty,
 		                struct mxser_port *port, u8 status)
 {
 	enum mxser_must_hwid hwid = port->board->must_hwid;
-	int recv_room = tty->receive_room;
 	int ignored = 0;
 	int max = 256;
-	int cnt = 0;
 	u8 ch;
 
 	do {
@@ -1596,14 +1582,8 @@ static u8 mxser_receive_chars_old(struct tty_struct *tty,
 					port->icount.overrun++;
 				}
 			}
-			tty_insert_flip_char(&port->port, ch, flag);
-			cnt++;
-			if (cnt >= recv_room) {
-				if (!port->ldisc_stop_rx)
-					mxser_stoprx(tty);
+			if (!tty_insert_flip_char(&port->port, ch, flag))
 				break;
-			}
-
 		}
 
 		if (hwid)
@@ -1618,9 +1598,6 @@ static u8 mxser_receive_chars_old(struct tty_struct *tty,
 static u8 mxser_receive_chars(struct tty_struct *tty,
 		struct mxser_port *port, u8 status)
 {
-	if (tty->receive_room == 0 && !port->ldisc_stop_rx)
-		mxser_stoprx(tty);
-
 	if (!mxser_receive_chars_new(tty, port, status))
 		status = mxser_receive_chars_old(tty, port, status);
 
@@ -1833,7 +1810,6 @@ static void mxser_initbrd(struct mxser_board *brd, bool high_baud)
 		tty_port_init(&info->port);
 		info->port.ops = &mxser_port_ops;
 		info->board = brd;
-		info->ldisc_stop_rx = false;
 
 		/* Enhance mode enabled here */
 		if (brd->must_hwid != MOXA_OTHER_UART)
-- 
2.34.1

