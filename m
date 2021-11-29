Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15F34625BC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhK2WnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhK2Wmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:42:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080E5C12BCF5;
        Mon, 29 Nov 2021 10:35:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1165B815C3;
        Mon, 29 Nov 2021 18:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5284C53FC7;
        Mon, 29 Nov 2021 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210913;
        bh=zm3wn2dUwBFga6vhvPA+ONH62W+DSJ6uWyihp3uBgLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maAMSvESBIBaxEbWvLbf0wHtjCMcPQG3IwymeVowARkqGdUZTyh+T5TTUr1m6htt0
         JZ9xn6P6UCPyD/RGK/tFFydCBkCXcgRjNd0kTgKBrGSm4umgQZIIrNY+UARaukM9rd
         uIWkamGsePDLf4GYMAkIpB4nlHZa8WJoOzpYgnyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ab0cfe96c2b3cd1c1153@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable@kernel.org
Subject: [PATCH 5.15 039/179] io_uring: fail cancellation for EXITING tasks
Date:   Mon, 29 Nov 2021 19:17:13 +0100
Message-Id: <20211129181720.246574998@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 617a89484debcd4e7999796d693cf0b77d2519de upstream.

WARNING: CPU: 1 PID: 20 at fs/io_uring.c:6269 io_try_cancel_userdata+0x3c5/0x640 fs/io_uring.c:6269
CPU: 1 PID: 20 Comm: kworker/1:0 Not tainted 5.16.0-rc1-syzkaller #0
Workqueue: events io_fallback_req_func
RIP: 0010:io_try_cancel_userdata+0x3c5/0x640 fs/io_uring.c:6269
Call Trace:
 <TASK>
 io_req_task_link_timeout+0x6b/0x1e0 fs/io_uring.c:6886
 io_fallback_req_func+0xf9/0x1ae fs/io_uring.c:1334
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

We need original task's context to do cancellations, so if it's dying
and the callback is executed in a fallback mode, fail the cancellation
attempt.

Fixes: 89b263f6d56e6 ("io_uring: run linked timeouts from task_work")
Cc: stable@kernel.org # 5.15+
Reported-by: syzbot+ab0cfe96c2b3cd1c1153@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/4c41c5f379c6941ad5a07cd48cb66ed62199cf7e.1637937097.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6886,10 +6886,11 @@ static inline struct file *io_file_get(s
 static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 {
 	struct io_kiocb *prev = req->timeout.prev;
-	int ret;
+	int ret = -ENOENT;
 
 	if (prev) {
-		ret = io_try_cancel_userdata(req, prev->user_data);
+		if (!(req->task->flags & PF_EXITING))
+			ret = io_try_cancel_userdata(req, prev->user_data);
 		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
 	} else {


