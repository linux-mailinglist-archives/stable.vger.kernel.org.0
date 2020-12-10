Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AFF2D5DC9
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389056AbgLJObU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:31:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388798AbgLJObK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:10 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 4.9 28/45] tty: Fix ->pgrp locking in tiocspgrp()
Date:   Thu, 10 Dec 2020 15:26:42 +0100
Message-Id: <20201210142603.739750087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 54ffccbf053b5b6ca4f6e45094b942fab92a25fc upstream.

tiocspgrp() takes two tty_struct pointers: One to the tty that userspace
passed to ioctl() (`tty`) and one to the TTY being changed (`real_tty`).
These pointers are different when ioctl() is called with a master fd.

To properly lock real_tty->pgrp, we must take real_tty->ctrl_lock.

This bug makes it possible for racing ioctl(TIOCSPGRP, ...) calls on
both sides of a PTY pair to corrupt the refcount of `struct pid`,
leading to use-after-free errors.

Fixes: 47f86834bbd4 ("redo locking of tty->pgrp")
CC: stable@kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2645,10 +2645,10 @@ static int tiocspgrp(struct tty_struct *
 	if (session_of_pgrp(pgrp) != task_session(current))
 		goto out_unlock;
 	retval = 0;
-	spin_lock_irq(&tty->ctrl_lock);
+	spin_lock_irq(&real_tty->ctrl_lock);
 	put_pid(real_tty->pgrp);
 	real_tty->pgrp = get_pid(pgrp);
-	spin_unlock_irq(&tty->ctrl_lock);
+	spin_unlock_irq(&real_tty->ctrl_lock);
 out_unlock:
 	rcu_read_unlock();
 	return retval;


