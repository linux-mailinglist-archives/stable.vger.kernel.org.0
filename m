Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38243F880A
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhHZMxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhHZMx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55B456103E;
        Thu, 26 Aug 2021 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629982359;
        bh=Ifp8v5SssKni3SjNCRZ45WYA0bOSQYMUM9nuXllpaxY=;
        h=Subject:To:From:Date:From;
        b=lH2rQJ6seKxRek6BLe0CoJ+NnYaB3BvR1W9p3riZCdPnRVPtAWE93CU8s2SBhDkvE
         hNY/Adl4epyX0eIHR3mwqF5eCfhrZWdjivVNrOShMU/XVvwBx1yAavavYCSZ7T0XdY
         Az3v7J+/weozSgFa7qvoJuewX85CfwH4T8N9Q89M=
Subject: patch "tty: Fix data race between tiocsti() and flush_to_ldisc()" added to tty-testing
To:     phind.uet@gmail.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 26 Aug 2021 14:52:20 +0200
Message-ID: <162998234017582@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: Fix data race between tiocsti() and flush_to_ldisc()

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From bb2853a6a421a052268eee00fd5d3f6b3504b2b1 Mon Sep 17 00:00:00 2001
From: Nguyen Dinh Phi <phind.uet@gmail.com>
Date: Mon, 23 Aug 2021 08:06:41 +0800
Subject: tty: Fix data race between tiocsti() and flush_to_ldisc()

The ops->receive_buf() may be accessed concurrently from these two
functions.  If the driver flushes data to the line discipline
receive_buf() method while tiocsti() is waiting for the
ops->receive_buf() to finish its work, the data race will happen.

For example:
tty_ioctl			|tty_ldisc_receive_buf
 ->tioctsi			| ->tty_port_default_receive_buf
				|  ->tty_ldisc_receive_buf
   ->hci_uart_tty_receive	|   ->hci_uart_tty_receive
    ->h4_recv                   |    ->h4_recv

In this case, the h4 receive buffer will be overwritten by the
latecomer, and we will lost the data.

Hence, change tioctsi() function to use the exclusive lock interface
from tty_buffer to avoid the data race.

Reported-by: syzbot+97388eb9d31b997fe1d0@syzkaller.appspotmail.com
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Link: https://lore.kernel.org/r/20210823000641.2082292-1-phind.uet@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e8532006e960..6616d4a0d41d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2290,8 +2290,6 @@ static int tty_fasync(int fd, struct file *filp, int on)
  *	Locking:
  *		Called functions take tty_ldiscs_lock
  *		current->signal->tty check is safe without locks
- *
- *	FIXME: may race normal receive processing
  */
 
 static int tiocsti(struct tty_struct *tty, char __user *p)
@@ -2307,8 +2305,10 @@ static int tiocsti(struct tty_struct *tty, char __user *p)
 	ld = tty_ldisc_ref_wait(tty);
 	if (!ld)
 		return -EIO;
+	tty_buffer_lock_exclusive(tty->port);
 	if (ld->ops->receive_buf)
 		ld->ops->receive_buf(tty, &ch, &mbz, 1);
+	tty_buffer_unlock_exclusive(tty->port);
 	tty_ldisc_deref(ld);
 	return 0;
 }
-- 
2.32.0


