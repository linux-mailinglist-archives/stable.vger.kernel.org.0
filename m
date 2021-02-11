Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1E6318E8B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBKP3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhBKPZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A33D264EAA;
        Thu, 11 Feb 2021 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055807;
        bh=V1cGGQRVwnMxGoASW1ReOzrD9iGH4FBinLv7pYIAjKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NqhjOOwHc1TmO2hTxbHlvb6pnE7xKsccMNQxgUF962wwq5nak576ntz2brhhm6IK
         YBZ86B7ZvSnjHiwmeTdgGyUAxME5Mecpy4ZpHA9eXz/sStYNwRuS9l/e+k0C/C9k4R
         zX4xT57YFi0Qrxk9dpzFdXsH4HdpxC6VotE2QYhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 15/54] io_uring: reinforce cancel on flush during exit
Date:   Thu, 11 Feb 2021 16:01:59 +0100
Message-Id: <20210211150153.538316844@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 3a7efd1ad269ccaf9c1423364d97c9661ba6dafa ]

What 84965ff8a84f0 ("io_uring: if we see flush on exit, cancel related tasks")
really wants is to cancel all relevant REQ_F_INFLIGHT requests reliably.
That can be achieved by io_uring_cancel_files(), but we'll miss it
calling io_uring_cancel_task_requests(files=NULL) from io_uring_flush(),
because it will go through __io_uring_cancel_task_requests().

Just always call io_uring_cancel_files() during cancel, it's good enough
for now.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8692,10 +8692,9 @@ static void io_uring_cancel_task_request
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
 
+	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
-	else
-		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);


