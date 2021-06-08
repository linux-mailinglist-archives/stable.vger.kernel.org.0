Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EAB3A0200
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhFHS7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234957AbhFHS4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:56:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9C58613CB;
        Tue,  8 Jun 2021 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177719;
        bh=sYxK+/vy8Vr8G9MP6hr0q7cht+k6XJ3CPzCBSsjZd9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWSVrD3BDewlKbPMs+cDmfBG2mR7hQtloxXmh7RzxCjMf3XshEXylIiqaw5A7LmQY
         SgyzHBh6IL2BZ5KxUnagVtOlS6gmjfVX9PQA/9e2XC9eyKBulqQFGythkLh3fLakrt
         OKbFqvRW0mfeHFqe2eTJ/9qUr46WxbwCwkqkPGuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/137] io_uring: fix link timeout refs
Date:   Tue,  8 Jun 2021 20:26:53 +0200
Message-Id: <20210608175944.829057777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 ]

WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 io_put_req fs/io_uring.c:2140 [inline]
 io_queue_linked_timeout fs/io_uring.c:6300 [inline]
 __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
 io_submit_sqe fs/io_uring.c:6534 [inline]
 io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
 __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
 __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182

io_link_timeout_fn() should put only one reference of the linked timeout
request, however in case of racing with the master request's completion
first io_req_complete() puts one and then io_put_req_deferred() is
called.

Cc: stable@vger.kernel.org # 5.12+
Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 369ec81033d6..958c463c11eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6266,6 +6266,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (prev) {
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req_deferred(prev, 1);
+		io_put_req_deferred(req, 1);
 	} else {
 		io_cqring_add_event(req, -ETIME, 0);
 		io_put_req_deferred(req, 1);
-- 
2.30.2



