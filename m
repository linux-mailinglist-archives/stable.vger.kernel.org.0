Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98E411A6B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243885AbhITQto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243737AbhITQtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A1626126A;
        Mon, 20 Sep 2021 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156456;
        bh=KznGqbpdKimRziCEd4TIKw06NWpwAcLxY32b4WXHJ68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCRhGF3yTcAgisqdgfZu3NoaF/YZLTlsdpEmaOpyqiYRul5OxKacwU3CWbFAcvq5k
         0fMBAfRg5bVjO7g53Q2wVLyXXwwvt/NtW0NxtjZoFnjalVa4OtivhMBVqLVSsWMnQp
         3AKJT98lvcPAevbWnXhxUisxQPkcHhw2SVX1sgWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+97388eb9d31b997fe1d0@syzkaller.appspotmail.com,
        Jiri Slaby <jirislaby@kernel.org>,
        Nguyen Dinh Phi <phind.uet@gmail.com>
Subject: [PATCH 4.4 068/133] tty: Fix data race between tiocsti() and flush_to_ldisc()
Date:   Mon, 20 Sep 2021 18:42:26 +0200
Message-Id: <20210920163914.871557859@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -2287,8 +2287,6 @@ static int tty_fasync(int fd, struct fil
  *	Locking:
  *		Called functions take tty_ldiscs_lock
  *		current->signal->tty check is safe without locks
- *
- *	FIXME: may race normal receive processing
  */
 
 static int tiocsti(struct tty_struct *tty, char __user *p)
@@ -2302,8 +2300,10 @@ static int tiocsti(struct tty_struct *tt
 		return -EFAULT;
 	tty_audit_tiocsti(tty, ch);
 	ld = tty_ldisc_ref_wait(tty);
+	tty_buffer_lock_exclusive(tty->port);
 	if (ld->ops->receive_buf)
 		ld->ops->receive_buf(tty, &ch, &mbz, 1);
+	tty_buffer_unlock_exclusive(tty->port);
 	tty_ldisc_deref(ld);
 	return 0;
 }


