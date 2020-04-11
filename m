Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C2C1A50DE
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgDKMVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728753AbgDKMVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:21:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E89820787;
        Sat, 11 Apr 2020 12:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607709;
        bh=ElJsnMUL0Khr6Wza5lm53pGJ2Tiz6oBqjvuuA8eOtGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddr/k9zed27OTO/j6OZQCJogIP52WIyJT8cUbu/GiAfJJ2j//aUtJGxgOeSwJ9lFk
         3pAoGWXAOZKFggMWJpmpHBCAOdTyebdRZu2KOOVjfwPic1ipUBSB5lscdBDBs4Qp1u
         +II4Exa7h7A6uQhY8uqLN+iMD/VQ08J6BE48vD5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+538d1957ce178382a394@syzkaller.appspotmail.com>
Subject: [PATCH 5.6 37/38] io-uring: drop completion when removing file
Date:   Sat, 11 Apr 2020 14:10:14 +0200
Message-Id: <20200411115503.466914576@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115459.324496182@linuxfoundation.org>
References: <20200411115459.324496182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

commit 4afdb733b1606c6cb86e7833f9335f4870cf7ddd upstream.

A case of task hung was reported by syzbot,

INFO: task syz-executor975:9880 blocked for more than 143 seconds.
      Not tainted 5.6.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor975 D27576  9880   9878 0x80004000
Call Trace:
 schedule+0xd0/0x2a0 kernel/sched/core.c:4154
 schedule_timeout+0x6db/0xba0 kernel/time/timer.c:1871
 do_wait_for_common kernel/sched/completion.c:83 [inline]
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x26a/0x3c0 kernel/sched/completion.c:136
 io_queue_file_removal+0x1af/0x1e0 fs/io_uring.c:5826
 __io_sqe_files_update.isra.0+0x3a1/0xb00 fs/io_uring.c:5867
 io_sqe_files_update fs/io_uring.c:5918 [inline]
 __io_uring_register+0x377/0x2c00 fs/io_uring.c:7131
 __do_sys_io_uring_register fs/io_uring.c:7202 [inline]
 __se_sys_io_uring_register fs/io_uring.c:7184 [inline]
 __x64_sys_io_uring_register+0x192/0x560 fs/io_uring.c:7184
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

and bisect pointed to 05f3fb3c5397 ("io_uring: avoid ring quiesce for
fixed file set unregister and update").

It is down to the order that we wait for work done before flushing it
while nobody is likely going to wake us up.

We can drop that completion on stack as flushing work itself is a sync
operation we need and no more is left behind it.

To that end, io_file_put::done is re-used for indicating if it can be
freed in the workqueue worker context.

Reported-and-Inspired-by: syzbot <syzbot+538d1957ce178382a394@syzkaller.appspotmail.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Rename ->done to ->free_pfile

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---
 fs/io_uring.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5607,7 +5607,7 @@ static void io_ring_file_put(struct io_r
 struct io_file_put {
 	struct llist_node llist;
 	struct file *file;
-	struct completion *done;
+	bool free_pfile;
 };
 
 static void io_ring_file_ref_flush(struct fixed_file_data *data)
@@ -5618,9 +5618,7 @@ static void io_ring_file_ref_flush(struc
 	while ((node = llist_del_all(&data->put_llist)) != NULL) {
 		llist_for_each_entry_safe(pfile, tmp, node, llist) {
 			io_ring_file_put(data->ctx, pfile->file);
-			if (pfile->done)
-				complete(pfile->done);
-			else
+			if (pfile->free_pfile)
 				kfree(pfile);
 		}
 	}
@@ -5820,7 +5818,6 @@ static bool io_queue_file_removal(struct
 				  struct file *file)
 {
 	struct io_file_put *pfile, pfile_stack;
-	DECLARE_COMPLETION_ONSTACK(done);
 
 	/*
 	 * If we fail allocating the struct we need for doing async reomval
@@ -5829,15 +5826,15 @@ static bool io_queue_file_removal(struct
 	pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
 	if (!pfile) {
 		pfile = &pfile_stack;
-		pfile->done = &done;
-	}
+		pfile->free_pfile = false;
+	} else
+		pfile->free_pfile = true;
 
 	pfile->file = file;
 	llist_add(&pfile->llist, &data->put_llist);
 
 	if (pfile == &pfile_stack) {
 		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
-		wait_for_completion(&done);
 		flush_work(&data->ref_work);
 		return false;
 	}


