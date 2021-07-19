Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52143CE43E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347186AbhGSPmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346192AbhGSPik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83B5C61205;
        Mon, 19 Jul 2021 16:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711517;
        bh=puAnekTf2hAJhWf0A+GK1B8W5QV6MXoZdBG7iavATEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSHQl4o1Qt8w1sSoumsXtKN2d70DSPPzg2r02VAhQ1+cIbXd66SN8Kv3eZREPk8Vl
         rxS5LQC4JjhY8RuAkIuvb8X+1EhSCrfS/w0gvHbplMlk+W26sEPQtus97ZhyihgLpO
         kz7yMXBInDrS2ByD7oj2t++IjL9xW6EZrR30kMk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 031/292] io_uring: fix link timeout refs
Date:   Mon, 19 Jul 2021 16:51:33 +0200
Message-Id: <20210719144943.553226991@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6307,7 +6307,6 @@ static enum hrtimer_restart io_link_time
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
 	}
-	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 


