Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A500D246972
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgHQPWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729411AbgHQPWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:22:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A09C5208C7;
        Mon, 17 Aug 2020 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677722;
        bh=i02g/80+xU9ubA8gjbp4xU1NME5Fnda4eKEjvCeN7yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWyWxsb11bny1MHOKNO6RUFCjJGtYH70ZNXVV85k94ZUytryRGbCcOlEZKb13Jdnf
         J0f6YJ71xfGx8cIcY10Wn06SlOHCG2TxbPiz6PkzuLu5McZxC+XSSx1bzhWpWMG6nu
         2f3RwqtzTFh/jyJdJR8M86B4n5SVB4XT98VXHfIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 083/464] io_uring: fix req->work corruption
Date:   Mon, 17 Aug 2020 17:10:36 +0200
Message-Id: <20200817143837.760573337@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 8ef77766ba8694968ed4ba24311b4bacee14f235 ]

req->work and req->task_work are in a union, so io_req_task_queue() screws
everything that was in work. De-union them for now.

[  704.367253] BUG: unable to handle page fault for address:
	ffffffffaf7330d0
[  704.367256] #PF: supervisor write access in kernel mode
[  704.367256] #PF: error_code(0x0003) - permissions violation
[  704.367261] CPU: 6 PID: 1654 Comm: io_wqe_worker-0 Tainted: G
I       5.8.0-rc2-00038-ge28d0bdc4863-dirty #498
[  704.367265] RIP: 0010:_raw_spin_lock+0x1e/0x36
...
[  704.367276]  __alloc_fd+0x35/0x150
[  704.367279]  __get_unused_fd_flags+0x25/0x30
[  704.367280]  io_openat2+0xcb/0x1b0
[  704.367283]  io_issue_sqe+0x36a/0x1320
[  704.367294]  io_wq_submit_work+0x58/0x160
[  704.367295]  io_worker_handle_work+0x2a3/0x430
[  704.367296]  io_wqe_worker+0x2a0/0x350
[  704.367301]  kthread+0x136/0x180
[  704.367304]  ret_from_fork+0x22/0x30

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8503aec7ea295..d732566955d37 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -669,12 +669,12 @@ struct io_kiocb {
 		 * restore the work, if needed.
 		 */
 		struct {
-			struct callback_head	task_work;
 			struct hlist_node	hash_node;
 			struct async_poll	*apoll;
 		};
 		struct io_wq_work	work;
 	};
+	struct callback_head	task_work;
 };
 
 #define IO_PLUG_THRESHOLD		2
-- 
2.25.1



