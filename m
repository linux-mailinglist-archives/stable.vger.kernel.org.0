Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA543033C4
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbhAZFE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbhAYSyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E015F2075B;
        Mon, 25 Jan 2021 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600801;
        bh=DHhBEhZM+tSThgz4owHDP+gCKhPGhj76oHeiXkbn3ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cCh4EgnPTER6hiT3+Fn7siWl98urz51DWKe4v6OHRechcYX1L5fjXtoTSiN8Drjq
         zKWeVNNSOWz8vJpQ7RvWj+Oax3fJgOkCCLNhxn033JnCk9NUfoAcylGbaJJgnPtNE1
         50SPUL6TtBrY4Pj/CeII6jzIDDVHpTsvmgGofoEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 126/199] io_uring: iopoll requests should also wake task ->in_idle state
Date:   Mon, 25 Jan 2021 19:39:08 +0100
Message-Id: <20210125183221.531456067@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c93cc9e16d88e0f5ea95d2d65d58a8a4dab258bc upstream.

If we're freeing/finishing iopoll requests, ensure we check if the task
is in idling in terms of cancelation. Otherwise we could end up waiting
forever in __io_uring_task_cancel() if the task has active iopoll
requests that need cancelation.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2167,6 +2167,8 @@ static void io_req_free_batch_finish(str
 		struct io_uring_task *tctx = rb->task->io_uring;
 
 		percpu_counter_sub(&tctx->inflight, rb->task_refs);
+		if (atomic_read(&tctx->in_idle))
+			wake_up(&tctx->wait);
 		put_task_struct_many(rb->task, rb->task_refs);
 		rb->task = NULL;
 	}
@@ -2186,6 +2188,8 @@ static void io_req_free_batch(struct req
 			struct io_uring_task *tctx = rb->task->io_uring;
 
 			percpu_counter_sub(&tctx->inflight, rb->task_refs);
+			if (atomic_read(&tctx->in_idle))
+				wake_up(&tctx->wait);
 			put_task_struct_many(rb->task, rb->task_refs);
 		}
 		rb->task = req->task;


