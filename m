Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702E2333DA6
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhCJNYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232755AbhCJNYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC71D64FE0;
        Wed, 10 Mar 2021 13:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382648;
        bh=FFVGLhhFfNqFSUrAdDb6I8fObhO2P1oynEj06Nyc6r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9a8nHj4KYdyppHIus/sOlNu7Kv1GRU4xPYZf77idkLSx7sIE7Sz1AYJFh8bCGY1E
         EuYSrWpGqMN0IpYSu7fSFDH8DXiJEs2WpUow+jm7aIo4op4fqt1n/rZ2pMW/6F5Oo1
         q/DnReJ4qX84y718TKJxb8SLln6gVETul6MGoIb8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.11 08/36] io_uring/io-wq: kill off now unused IO_WQ_WORK_NO_CANCEL
Date:   Wed, 10 Mar 2021 14:23:21 +0100
Message-Id: <20210310132320.782520570@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jens Axboe <axboe@kernel.dk>

commit 4014d943cb62db892eb023d385a966a3fce5ee4c upstream

It's no longer used as IORING_OP_CLOSE got rid for the need of flagging
it as uncancelable, kill it of.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c    |    1 -
 fs/io-wq.h    |    1 -
 fs/io_uring.c |    5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -944,7 +944,6 @@ static bool io_wq_worker_cancel(struct i
 	 */
 	spin_lock_irqsave(&worker->lock, flags);
 	if (worker->cur_work &&
-	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL) &&
 	    match->fn(worker->cur_work, match->data)) {
 		send_sig(SIGINT, worker->task, 1);
 		match->nr_running++;
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -9,7 +9,6 @@ enum {
 	IO_WQ_WORK_CANCEL	= 1,
 	IO_WQ_WORK_HASHED	= 2,
 	IO_WQ_WORK_UNBOUND	= 4,
-	IO_WQ_WORK_NO_CANCEL	= 8,
 	IO_WQ_WORK_CONCURRENT	= 16,
 
 	IO_WQ_WORK_FILES	= 32,
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6388,11 +6388,8 @@ static struct io_wq_work *io_wq_submit_w
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	/* if NO_CANCEL is set, we must still run the work */
-	if ((work->flags & (IO_WQ_WORK_CANCEL|IO_WQ_WORK_NO_CANCEL)) ==
-				IO_WQ_WORK_CANCEL) {
+	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
-	}
 
 	if (!ret) {
 		do {


