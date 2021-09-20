Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9506E411D6D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346845AbhITRUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346683AbhITRSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B581D613D2;
        Mon, 20 Sep 2021 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157183;
        bh=+u2gdY82twVzZc/+FP/9XeCbDZTaNroa7jCYQ0Oh/lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJ0U11GO7XPTcyYPUG1n453ML23Lv/KrZ1LmDP/2DHp72sexpeRoU8W2OWqEOyXc1
         DQNK3lL0Y8eh5KeKUIFzs9kTV1m8kslPRmzaGJ3VRnD1/8Xp1nNvZWK1q1pDlWfII+
         hGHRaAwvZoOmDCd0zrdUDjUeGiF/m+V8ih+TEqHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+97388eb9d31b997fe1d0@syzkaller.appspotmail.com,
        Jiri Slaby <jirislaby@kernel.org>,
        Nguyen Dinh Phi <phind.uet@gmail.com>
Subject: [PATCH 4.14 091/217] tty: Fix data race between tiocsti() and flush_to_ldisc()
Date:   Mon, 20 Sep 2021 18:41:52 +0200
Message-Id: <20210920163927.721004034@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>

commit bb2853a6a421a052268eee00fd5d3f6b3504b2b1 upstream.

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
 drivers/tty/tty_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2165,8 +2165,6 @@ static int tty_fasync(int fd, struct fil
  *	Locking:
  *		Called functions take tty_ldiscs_lock
  *		current->signal->tty check is safe without locks
- *
- *	FIXME: may race normal receive processing
  */
 
 static int tiocsti(struct tty_struct *tty, char __user *p)
@@ -2182,8 +2180,10 @@ static int tiocsti(struct tty_struct *tt
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


