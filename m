Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1B266428
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgIKQc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgIKPTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF82322450;
        Fri, 11 Sep 2020 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829168;
        bh=K6y/vHVqiosI8pfx5NYVW44msU10AvAKxSSUxgqbr2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwvKjBdU6ymL2C81W+9TKUaVqsNyvX4iMZmx7eSwG6C/6hsT+NuMTnXxiw4jIoqph
         95P2KAXBBVcOtRf2UJdMZtv97qvN8dRe8WWTFyL4Z9k85YkhT2gof6LISr1ax0Zzfx
         J2/3GSoB6/BcCM+FQUoqeoSAOptm4a05n2qyOfkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 01/16] io_uring: fix cancel of deferred reqs with ->files
Date:   Fri, 11 Sep 2020 14:47:18 +0200
Message-Id: <20200911122459.664920183@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
References: <20200911122459.585735377@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit b7ddce3cbf010edbfac6c6d8cc708560a7bcd7a4 ]

While trying to cancel requests with ->files, it also should look for
requests in ->defer_list, otherwise it might end up hanging a thread.

Cancel all requests in ->defer_list up to the last request there with
matching ->files, that's needed to follow drain ordering semantics.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38f3ec15ba3b1..5f627194d0920 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7675,12 +7675,38 @@ static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	io_timeout_remove_link(ctx, req);
 }
 
+static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+				  struct files_struct *files)
+{
+	struct io_kiocb *req = NULL;
+	LIST_HEAD(list);
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry_reverse(req, &ctx->defer_list, list) {
+		if ((req->flags & REQ_F_WORK_INITIALIZED)
+			&& req->work.files == files) {
+			list_cut_position(&list, &ctx->defer_list, &req->list);
+			break;
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+
+	while (!list_empty(&list)) {
+		req = list_first_entry(&list, struct io_kiocb, list);
+		list_del_init(&req->list);
+		req_set_fail_links(req);
+		io_cqring_add_event(req, -ECANCELED);
+		io_double_put_req(req);
+	}
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	if (list_empty_careful(&ctx->inflight_list))
 		return;
 
+	io_cancel_defer_files(ctx, files);
 	/* cancel all at once, should be faster than doing it one by one*/
 	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
 
-- 
2.25.1



