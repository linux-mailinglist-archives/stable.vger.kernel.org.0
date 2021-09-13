Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487B5409006
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbhIMNs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243856AbhIMNq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:46:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD04861528;
        Mon, 13 Sep 2021 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539936;
        bh=PZFijUnzFm1xU7t6cRsvOEqatyXFFIlW64bKY8NGXoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZ/Bs3MDH+pkS8gXMecO4aJ4SMtv6g50GgkM4gWnHTbEToeGxdVRDvMbU+NN23gjS
         yf+20LM9UT291/ZQ30grGqEXcsH+HZ6Gk8K9fZUy0UrhbMcquWwHC6RC9geRQXFadj
         X4b6Gzj8PqYx9jCQiZEeKHIxoyX9YRFMsoMnI+AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+97388eb9d31b997fe1d0@syzkaller.appspotmail.com,
        Jiri Slaby <jirislaby@kernel.org>,
        Nguyen Dinh Phi <phind.uet@gmail.com>
Subject: [PATCH 5.10 221/236] tty: Fix data race between tiocsti() and flush_to_ldisc()
Date:   Mon, 13 Sep 2021 15:15:26 +0200
Message-Id: <20210913131107.877083865@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
@@ -2257,8 +2257,6 @@ static int tty_fasync(int fd, struct fil
  *	Locking:
  *		Called functions take tty_ldiscs_lock
  *		current->signal->tty check is safe without locks
- *
- *	FIXME: may race normal receive processing
  */
 
 static int tiocsti(struct tty_struct *tty, char __user *p)
@@ -2274,8 +2272,10 @@ static int tiocsti(struct tty_struct *tt
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


