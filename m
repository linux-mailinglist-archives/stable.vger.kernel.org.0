Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C0E303B7A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392170AbhAZLWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392297AbhAZLVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:21:41 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA96C06174A
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:01 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id dj23so19267830edb.13
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M5TPvRyw0cGrL3K0zvfB1Iff9KwIVNzXAQTKSicxMQI=;
        b=D0tYRZ0t+Rj7bh7z0RNcCEqd1cQi7FnPY/vUqGJVq9sr0a6NwIymffvKgfGGJ0Wdr4
         zp4tzcF16cC10FJKuZBYC9+seQEuyuSisfIsM6a5qT8IpNyS8LvrMt3EiNID/tzrG8Bc
         08OayJY+A1y7U1LUBGD+iFAIyAtzjQw6UTEmMEHDO0YNHgHuxdIkh5XtO5lOkUD4CSOR
         /oqQQQG7vaHLA8VfRVZR0+QZqCz4e5qkvcjIgdmnPY7PuufTOSEb5bnX/c8x75TGlgCh
         tUgF7RknCP6OAp08bescpUCDg7sWZky24zO1FuCQ80T3vAnDZFMPUhtbMhkNptBaG+0h
         JofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M5TPvRyw0cGrL3K0zvfB1Iff9KwIVNzXAQTKSicxMQI=;
        b=kG0FQQw8Hndke+X4HG6fKkoxpNwRnTxdKcSl5ppkXyMKL0eVLSkBIileePB7QcY7Bu
         8Lf8VQpKQyr8CRzCep1Rv9EBNu7Qwiw5ivkIHX8DRwsXDy1tkQ+DOmQsVxE8YDow+y7R
         NB/nVOac8QUTrta1Zug1QnlBcpxpGalpAhi45GPL8SS9x6r8REI+ttON3odCEiT/dh6T
         W1T7y6KgBNxUkSb0+hBEzGNlnFisvH6csIrxgNfm0dExcravyXT3S+J+iYKEp9YncqXC
         HHaOD6b9Z43231G8Xi+Dr2P8Kg7gcm+vLzjAg4O8p2JJJxhot95QLy46qWMERe6Buan1
         mMhA==
X-Gm-Message-State: AOAM530fDjH0OjPMOfe5uQ4HCLP9OK6LOW2FEb0WqdX+mjgUFr+PAOi3
        E7oWwHtpKXuUyjSfHj/2CiwMtH2KdGfGtw==
X-Google-Smtp-Source: ABdhPJyRn11bhk3W/k3x195QcHM5YPHZ1dF1qXDJ+KCmLUBsn76an91kmxXzL5S5ewNNIfWUhsapng==
X-Received: by 2002:a05:6402:1a2a:: with SMTP id be10mr4144669edb.185.1611660059554;
        Tue, 26 Jan 2021 03:20:59 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:20:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable 01/11] kernel/io_uring: cancel io_uring before task works
Date:   Tue, 26 Jan 2021 11:17:00 +0000
Message-Id: <96a68f8f062a7bc6e267fef65e01a665ab232a29.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b1b6b5a30dce872f500dc43f067cba8e7f86fc7d ]

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
---
 fs/file.c     | 2 --
 kernel/exit.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4559b5fec3bd..21c0893f2f1d 100644
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
diff --git a/kernel/exit.c b/kernel/exit.c
index 1f236ed375f8..d13d67fc5f4e 100644
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
-- 
2.24.0

