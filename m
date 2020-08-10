Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C16241061
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgHJT3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbgHJTKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:10:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D500C22B49;
        Mon, 10 Aug 2020 19:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086638;
        bh=PqPBTT2fG/DuUSpiOgz2ao9bupW5VYNpUK7UYUo/+B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFGrAPzvOIRJuoqTOeM86q/j+rPIP+2N4VL1s+2rrHrT4S5n9d43FoaIox3WrwEy+
         hADmA05WuO/de6tzimMTufoUZlGav+OC0Oug5Noog2XIa6DNSVNRWNwMQs/uwmxoO3
         WtuGPAZ7Kf/zZwV8d/9VQOb5F3cFKF04azsZfSYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 07/60] io_uring: fix req->work corruption
Date:   Mon, 10 Aug 2020 15:09:35 -0400
Message-Id: <20200810191028.3793884-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4e09af1d5d223..80a612d1e12bb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -645,12 +645,12 @@ struct io_kiocb {
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

