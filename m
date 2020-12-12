Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C9F2D8586
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 11:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438525AbgLLKAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 05:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438522AbgLLKAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 05:00:04 -0500
Subject: patch "USB: serial: keyspan_pda: fix dropped unthrottle interrupts" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607767164;
        bh=4cwWQQ9fCmaPrg/AJkqgIMijVjjyj4F8woVlNzs5QUU=;
        h=To:From:Date:From;
        b=BqUpRnIKwHhh03IBBoZyzSXdYAPOHu7mAyT9Jzq/149aNQazEX2YRAhMGcIK9UIV6
         1eL2yXg5QZY4m8qDax2xBt+2HAjLT2eklNajrw1RY8wwGAVl5BBlL9/o5ZRG0TenoC
         LfdfTeWRClw/4Pnv0ORapbXTG0kpgeE3f1beyL8Y=
To:     johan@kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Dec 2020 10:59:17 +0100
Message-ID: <160776715780157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: keyspan_pda: fix dropped unthrottle interrupts

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 696c541c8c6cfa05d65aa24ae2b9e720fc01766e Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Sun, 25 Oct 2020 18:45:47 +0100
Subject: USB: serial: keyspan_pda: fix dropped unthrottle interrupts

Commit c528fcb116e6 ("USB: serial: keyspan_pda: fix receive sanity
checks") broke write-unthrottle handling by dropping well-formed
unthrottle-interrupt packets which are precisely two bytes long. This
could lead to blocked writers not being woken up when buffer space again
becomes available.

Instead, stop unconditionally printing the third byte which is
(presumably) only valid on modem-line changes.

Fixes: c528fcb116e6 ("USB: serial: keyspan_pda: fix receive sanity checks")
Cc: stable <stable@vger.kernel.org>     # 4.11
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index c1333919716b..2d5ad579475a 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -172,11 +172,11 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 		break;
 	case 1:
 		/* status interrupt */
-		if (len < 3) {
+		if (len < 2) {
 			dev_warn(&port->dev, "short interrupt message received\n");
 			break;
 		}
-		dev_dbg(&port->dev, "rx int, d1=%d, d2=%d\n", data[1], data[2]);
+		dev_dbg(&port->dev, "rx int, d1=%d\n", data[1]);
 		switch (data[1]) {
 		case 1: /* modemline change */
 			break;
-- 
2.29.2


