Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7185A2E9A10
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbhADQCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbhADQCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B97722583;
        Mon,  4 Jan 2021 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776100;
        bh=Xpl1Q/NMIvh0M97GEHMAJJY/CIV7rz9d9p7YjW4eqkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IiF6/bOTeQKi+RhcyQbYu1rH0qeZPR/vAtn7lDt4eHablgL1HFOh98KgEE9CUXW5
         ZXDdMtwJlLG5VWVc77I16L5QKLRkrYN1oVQGbb5vRzcEQMYeq8H3Tys3GcZUDuD+dX
         ITFOl0CQoM/k9eo130fMdrGD4HleJrdhyAQNB21U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 21/63] kernel/io_uring: cancel io_uring before task works
Date:   Mon,  4 Jan 2021 16:57:14 +0100
Message-Id: <20210104155709.846535201@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit b1b6b5a30dce872f500dc43f067cba8e7f86fc7d upstream.

For cancelling io_uring requests it needs either to be able to run
currently enqueued task_works or having it shut down by that moment.
Otherwise io_uring_cancel_files() may be waiting for requests that won't
ever complete.

Go with the first way and do cancellations before setting PF_EXITING and
so before putting the task_work infrastructure into a transition state
where task_work_run() would better not be called.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/file.c     |    2 --
 kernel/exit.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -21,7 +21,6 @@
 #include <linux/rcupdate.h>
 #include <linux/close_range.h>
 #include <net/sock.h>
-#include <linux/io_uring.h>
 
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
@@ -453,7 +452,6 @@ void exit_files(struct task_struct *tsk)
 	struct files_struct * files = tsk->files;
 
 	if (files) {
-		io_uring_files_cancel(files);
 		task_lock(tsk);
 		tsk->files = NULL;
 		task_unlock(tsk);
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -63,6 +63,7 @@
 #include <linux/random.h>
 #include <linux/rcuwait.h>
 #include <linux/compat.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -762,6 +763,7 @@ void __noreturn do_exit(long code)
 		schedule();
 	}
 
+	io_uring_files_cancel(tsk->files);
 	exit_signals(tsk);  /* sets PF_EXITING */
 
 	/* sync mm's RSS info before statistics gathering */


