Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9520C72B04
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 11:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfGXJDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 05:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfGXJDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 05:03:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D4DE2189F;
        Wed, 24 Jul 2019 09:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563959016;
        bh=ZMuVhEy5eiKMhvpbRZK1g6QBsE1C0jFMHoo3S//3MAY=;
        h=Subject:To:From:Date:From;
        b=GzsAfFM1qUUQQq6XcjVF9EXRmyxhwa3191+5hnV8Y/cP5jbr+WC+wwJwljlVVEDzW
         hwZftZll6tosHjVtziOA3Jn9fWRUxpN4L+scIhEzH4Mv261ZA7E1p4hA528C5SYiJr
         O9kshjygVvhwRg2YWWZfWEbNlfkF1S/YtZYE5S+Q=
Subject: patch "binder: prevent transactions to context manager from its own process." added to char-misc-linus
To:     hridya@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jul 2019 11:03:26 +0200
Message-ID: <15639590066949@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: prevent transactions to context manager from its own process.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 49ed96943a8e0c62cc5a9b0a6cfc88be87d1fcec Mon Sep 17 00:00:00 2001
From: Hridya Valsaraju <hridya@google.com>
Date: Mon, 15 Jul 2019 12:18:04 -0700
Subject: binder: prevent transactions to context manager from its own process.

Currently, a transaction to context manager from its own process
is prevented by checking if its binder_proc struct is the same as
that of the sender. However, this would not catch cases where the
process opens the binder device again and uses the new fd to send
a transaction to the context manager.

Reported-by: syzbot+8b3c354d33c4ac78bfad@syzkaller.appspotmail.com
Signed-off-by: Hridya Valsaraju <hridya@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190715191804.112933-1-hridya@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 5bde08603fbc..dc1c83eafc22 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2988,7 +2988,7 @@ static void binder_transaction(struct binder_proc *proc,
 			else
 				return_error = BR_DEAD_REPLY;
 			mutex_unlock(&context->context_mgr_node_lock);
-			if (target_node && target_proc == proc) {
+			if (target_node && target_proc->pid == proc->pid) {
 				binder_user_error("%d:%d got transaction to context manager from process owning it\n",
 						  proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;
-- 
2.22.0


