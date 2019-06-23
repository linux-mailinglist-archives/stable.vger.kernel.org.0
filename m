Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1C74FA51
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 07:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfFWFBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 01:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfFWFBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Jun 2019 01:01:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0754E20657;
        Sun, 23 Jun 2019 05:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561266073;
        bh=6ZFfqtXJCaV+mKTDDsVOU2HdcEQ6qUhNC6jnkZcdOCQ=;
        h=Subject:To:From:Date:From;
        b=XU8dXEX8wj1D71dB5SclfQM71FYiPswkR60RaY+BOhud/emjhFli94rvzoystj7+r
         4ntrtPSUX/8yJC1nrJuvF3u87ZbuBWP45gjubKcV21/xFOq+k9BTexaD8scc8zfGAR
         d0qiCLMVTBM3FM/N5pEk6Q8ACjVJMSMgWEXT7hRQ=
Subject: patch "binder: fix memory leak in error path" added to char-misc-testing
To:     tkjos@android.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 07:01:11 +0200
Message-ID: <156126607138234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: fix memory leak in error path

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 1909a671dbc3606685b1daf8b22a16f65ea7edda Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@android.com>
Date: Fri, 21 Jun 2019 10:54:15 -0700
Subject: binder: fix memory leak in error path

syzkallar found a 32-byte memory leak in a rarely executed error
case. The transaction complete work item was not freed if put_user()
failed when writing the BR_TRANSACTION_COMPLETE to the user command
buffer. Fixed by freeing it before put_user() is called.

Reported-by: syzbot+182ce46596c3f2e1eb24@syzkaller.appspotmail.com
Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 748ac489ef7e..8b108e9b31cc 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4256,6 +4256,8 @@ static int binder_thread_read(struct binder_proc *proc,
 		case BINDER_WORK_TRANSACTION_COMPLETE: {
 			binder_inner_proc_unlock(proc);
 			cmd = BR_TRANSACTION_COMPLETE;
+			kfree(w);
+			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
 			if (put_user(cmd, (uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
@@ -4264,8 +4266,6 @@ static int binder_thread_read(struct binder_proc *proc,
 			binder_debug(BINDER_DEBUG_TRANSACTION_COMPLETE,
 				     "%d:%d BR_TRANSACTION_COMPLETE\n",
 				     proc->pid, thread->pid);
-			kfree(w);
-			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
 		} break;
 		case BINDER_WORK_NODE: {
 			struct binder_node *node = container_of(w, struct binder_node, work);
-- 
2.22.0


