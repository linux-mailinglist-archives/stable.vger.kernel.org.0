Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E33ED610
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhHPNQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240299AbhHPNPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16AD3632D8;
        Mon, 16 Aug 2021 13:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119544;
        bh=wIIjKmFH0euQgXstQ8ky9Kw/RhFBEoQ27fKrn1QOueE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfrAMFeVwXKMVE5m6vJVndS10oHi8RyRazeEhGuyVenrZtHb7g2a+Pi/nOcBlgghp
         qbqLPTmEGxiIufEOUTfykRPkp6ArZNKcpv9t6ibmeQebLdCeN/0puQDD4tcDBRTGK6
         7OjXh08p0hkBnirrus0KxjcnRN0T0S6UsxCmd1+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Nadav Amit <namit@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 068/151] io_uring: clear TIF_NOTIFY_SIGNAL when running task work
Date:   Mon, 16 Aug 2021 15:01:38 +0200
Message-Id: <20210816125446.308819084@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

[ Upstream commit ef98eb0409c31c39ab55ff46b2721c3b4f84c122 ]

When using SQPOLL, the submission queue polling thread calls
task_work_run() to run queued work. However, when work is added with
TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
set afterwards and is never cleared.

Consequently, when the submission queue polling thread checks whether
signal_pending(), it may always find a pending signal, if
task_work_add() was ever called before.

The impact of this bug might be different on different kernel versions.
It appears that on 5.14 it would only cause unnecessary calculation and
prevent the polling thread from sleeping. On 5.13, where the bug was
found, it stops the polling thread from finding newly submitted work.

Instead of task_work_run(), use tracehook_notify_signal() that clears
TIF_NOTIFY_SIGNAL. Test for TIF_NOTIFY_SIGNAL in addition to
current->task_works to avoid a race in which task_works is cleared but
the TIF_NOTIFY_SIGNAL is set.

Fixes: 685fe7feedb96 ("io-wq: eliminate the need for a manager thread")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
Link: https://lore.kernel.org/r/20210808001342.964634-2-namit@vmware.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 32f3df13a812..8a8507cab580 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -78,6 +78,7 @@
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
+#include <linux/tracehook.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -2250,9 +2251,9 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
-	if (current->task_works) {
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
-		task_work_run();
+		tracehook_notify_signal();
 		return true;
 	}
 
-- 
2.30.2



