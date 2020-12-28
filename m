Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031812E3E2A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503159AbgL1OY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503157AbgL1OYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9163229C4;
        Mon, 28 Dec 2020 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165480;
        bh=vqdLYbClBal+Jud/e7Od8n3nHS7UoXrCHd/ag/RUQxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2Yx0v3NOH7iP7JE/Pi2qcUqxoNkHKwsWnQ+SiuPcvOrxqKl29lKf7sMqjF2v0e2i
         g+yo1zcEBZMjaThrbfetTHbSDqj9qbBbOZ0ntzj4b6ShezYRriFVnjdLkHaOMtkPwJ
         EOHpOeflRKkwH5I6jTtrYQHXNLvBz/mIhX9OrUdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 516/717] io_uring: fix io_wqe->work_list corruption
Date:   Mon, 28 Dec 2020 13:48:34 +0100
Message-Id: <20201228125045.676509466@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

commit 0020ef04e48571a88d4f482ad08f71052c5c5a08 upstream.

For the first time a req punted to io-wq, we'll initialize io_wq_work's
list to be NULL, then insert req to io_wqe->work_list. If this req is not
inserted into tail of io_wqe->work_list, this req's io_wq_work list will
point to another req's io_wq_work. For splitted bio case, this req maybe
inserted to io_wqe->work_list repeatedly, once we insert it to tail of
io_wqe->work_list for the second time, now io_wq_work->list->next will be
invalid pointer, which then result in many strang error, panic, kernel
soft-lockup, rcu stall, etc.

In my vm, kernel doest not have commit cc29e1bf0d63f7 ("block: disable
iopoll for split bio"), below fio job can reproduce this bug steadily:
[global]
name=iouring-sqpoll-iopoll-1
ioengine=io_uring
iodepth=128
numjobs=1
thread
rw=randread
direct=1
registerfiles=1
hipri=1
bs=4m
size=100M
runtime=120
time_based
group_reporting
randrepeat=0

[device]
directory=/home/feiman.wxg/mntpoint/  # an ext4 mount point

If we have commit cc29e1bf0d63f7 ("block: disable iopoll for split bio"),
there will no splitted bio case for polled io, but I think we still to need
to fix this list corruption, it also should maybe go to stable branchs.

To fix this corruption, if a req is inserted into tail of io_wqe->work_list,
initialize req->io_wq_work->list->next to bu NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io-wq.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -59,6 +59,7 @@ static inline void wq_list_add_tail(stru
 		list->last->next = node;
 		list->last = node;
 	}
+	node->next = NULL;
 }
 
 static inline void wq_list_cut(struct io_wq_work_list *list,


