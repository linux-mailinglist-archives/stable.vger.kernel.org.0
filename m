Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE193499938
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451798AbiAXVdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:33:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45706 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452206AbiAXVYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:24:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D16D6614CB;
        Mon, 24 Jan 2022 21:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DC8C340E4;
        Mon, 24 Jan 2022 21:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059456;
        bh=3kPQFQXrFwsqTMtVM9ew+ZI2qMLU4r4nNQNU7LoZqa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnCDK0m1xmVUdGxArAjBoIOM+r0ggwcZZQQT1NwzHH/p4ryshzsu/K94aUhPeZiw1
         kVp5FtBMymFvcQPzNqbc5re5acb+GQBhDiQsKfRQPpuzEm8Z605f6IbbHnVBPqMpuf
         wofZLctTVLk5xJelg7o+wv3Ss8hIDayiJc/JVL1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0589/1039] mxser: dont throttle manually
Date:   Mon, 24 Jan 2022 19:39:38 +0100
Message-Id: <20220124184145.134971912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



