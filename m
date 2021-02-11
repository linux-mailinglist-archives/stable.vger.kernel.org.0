Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF056318E77
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhBKP1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230523AbhBKPWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D19664E9C;
        Thu, 11 Feb 2021 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055801;
        bh=+QeUu6DYkAlcHkl6V3EhzcJxwr9efzX8Q53SK1aTAWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkeKYdJYNomPAO8IqU7FeRdWHohoKXvMa/0sRAu2mx0a7SjU9e7WEgJf/6iPewdOG
         7XlmG4B5li9p4rdC66SzrIYZiu+xeJ9Ga2pCqXg1WxuO+XFNRlSF+3oqkVySgtCzK0
         stSrWAm0XurIfyCdyXNEhGYiJeengHOlnaeSwXNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+6879187cf57845801267@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 13/54] io_uring: fix list corruption for splice file_get
Date:   Thu, 11 Feb 2021 16:01:57 +0100
Message-Id: <20210211150153.456426866@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f609cbb8911e40e15f9055e8f945f926ac906924 ]

kernel BUG at lib/list_debug.c:29!
Call Trace:
 __list_add include/linux/list.h:67 [inline]
 list_add include/linux/list.h:86 [inline]
 io_file_get+0x8cc/0xdb0 fs/io_uring.c:6466
 __io_splice_prep+0x1bc/0x530 fs/io_uring.c:3866
 io_splice_prep fs/io_uring.c:3920 [inline]
 io_req_prep+0x3546/0x4e80 fs/io_uring.c:6081
 io_queue_sqe+0x609/0x10d0 fs/io_uring.c:6628
 io_submit_sqe fs/io_uring.c:6705 [inline]
 io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6953
 __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9353
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_file_get() may be called from splice, and so REQ_F_INFLIGHT may
already be set.

Fixes: 02a13674fa0e8 ("io_uring: account io_uring internal files as REQ_F_INFLIGHT")
Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+6879187cf57845801267@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6170,7 +6170,8 @@ static struct file *io_file_get(struct i
 		file = __io_file_get(state, fd);
 	}
 
-	if (file && file->f_op == &io_uring_fops) {
+	if (file && file->f_op == &io_uring_fops &&
+	    !(req->flags & REQ_F_INFLIGHT)) {
 		io_req_init_async(req);
 		req->flags |= REQ_F_INFLIGHT;
 


