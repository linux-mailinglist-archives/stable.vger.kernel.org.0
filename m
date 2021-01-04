Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DED2E9A01
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbhADQGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:06:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbhADQC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A79522473;
        Mon,  4 Jan 2021 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776136;
        bh=Ny1A5XdaJPEyUXhWYxlde/SXbDrlL4EpOPW8Cwta6Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqcRg1nN8BKruzYGWnDTvzp4ou7aPg415MP3A0csNGUwKfY2gc3mLni8SpZtvvwg5
         1SNlTW0pZ5O7hzWmz3pVNR1Qy5744vTaZg/qIhpqSyYRwHm9BqlzH0xtvzXbtOvDMA
         75BUn3aHtJxmaaQQXQWZvOEUPbxdOfXPxPjBaXPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 07/63] io_uring: close a small race gap for files cancel
Date:   Mon,  4 Jan 2021 16:57:00 +0100
Message-Id: <20210104155709.164282473@linuxfoundation.org>
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

commit dfea9fce29fda6f2f91161677e0e0d9b671bc099 upstream.

The purpose of io_uring_cancel_files() is to wait for all requests
matching ->files to go/be cancelled. We should first drop files of a
request in io_req_drop_files() and only then make it undiscoverable for
io_uring_cancel_files.

First drop, then delete from list. It's ok to leave req->id->files
dangling, because it's not dereferenced by cancellation code, only
compared against. It would potentially go to sleep and be awaken by
following in io_req_drop_files() wake_up().

Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5861,15 +5861,15 @@ static void io_req_drop_files(struct io_
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
+	put_files_struct(req->work.identity->files);
+	put_nsproxy(req->work.identity->nsproxy);
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
-	if (waitqueue_active(&ctx->inflight_wait))
-		wake_up(&ctx->inflight_wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
 	req->work.flags &= ~IO_WQ_WORK_FILES;
+	if (waitqueue_active(&ctx->inflight_wait))
+		wake_up(&ctx->inflight_wait);
 }
 
 static void __io_clean_op(struct io_kiocb *req)


