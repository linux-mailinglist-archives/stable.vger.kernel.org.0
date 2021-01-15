Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C0F2F7A4A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbhAOMgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732050AbhAOMgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3FF2235F8;
        Fri, 15 Jan 2021 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714180;
        bh=HKyslfh0p2rSIqbErrumB0XVGC2Ukt9Mz/5K5RbrVjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHeyjPhmyRNByHWhpoHQhSQVPWdc433liKlcoPaZFY+BGTBcHVyyTHk2nWobTvrHg
         DxXcpV2HSMFRcML0GsVC62iKsP1MLn470k3ePuievzltiENGECGT3cbl2oR3oip+C3
         XQ8PXWZVS9HyLZ2Zu15VPzGE5/QMv43v1zss3Gus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/103] io_uring: synchronise IOPOLL on task_submit fail
Date:   Fri, 15 Jan 2021 13:26:55 +0100
Message-Id: <20210115122006.168949408@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 81b6d05ccad4f3d8a9dfb091fb46ad6978ee40e4 upstream

io_req_task_submit() might be called for IOPOLL, do the fail path under
uring_lock to comply with IOPOLL synchronisation based solely on it.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f798c5c4213e..3974b4f124b6a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2047,14 +2047,15 @@ static void io_req_task_cancel(struct callback_head *cb)
 static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool fail;
 
-	if (!__io_sq_thread_acquire_mm(ctx)) {
-		mutex_lock(&ctx->uring_lock);
+	fail = __io_sq_thread_acquire_mm(ctx);
+	mutex_lock(&ctx->uring_lock);
+	if (!fail)
 		__io_queue_sqe(req, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	} else {
+	else
 		__io_req_task_cancel(req, -EFAULT);
-	}
+	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_req_task_submit(struct callback_head *cb)
-- 
2.27.0



