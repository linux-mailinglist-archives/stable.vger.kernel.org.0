Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCADC3CE457
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344044AbhGSPnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241405AbhGSPhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:37:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15D0D613E3;
        Mon, 19 Jul 2021 16:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711489;
        bh=GkhnKjP4/NzD4qLmF6fq2/zr7fW8u9zUsEgUZ0kKac0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbY2s1fZvETyZop8R6XvWPqR1+lIfPJ96IGRgdeJjXc7ixsmbEHkI4D+hU9zap/Fx
         wBXgl1ZOEr4WmaKMslBFgh4eEHq/tjjMkFrw4cGfRuDHS83WleMJc9rTR37ugbk9fH
         fs7c8+vGKlyzzvfy86YNhamXNWEw83sPrPombWgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 022/292] io_uring: use right task for exiting checks
Date:   Mon, 19 Jul 2021 16:51:24 +0200
Message-Id: <20210719144943.263734414@linuxfoundation.org>
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

commit 9c6882608bce249a8918744ecdb65748534e3f17 upstream.

When we use delayed_work for fallback execution of requests, current
will be not of the submitter task, and so checks in io_req_task_submit()
may not behave as expected. Currently, it leaves inline completions not
flushed, so making io_ring_exit_work() to hang. Use the submitter task
for all those checks.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/cb413c715bed0bc9c98b169059ea9c8a2c770715.1625881431.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2023,7 +2023,7 @@ static void __io_req_task_submit(struct
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!(current->flags & PF_EXITING) && !current->in_execve)
+	if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
 		__io_queue_sqe(req);
 	else
 		__io_req_task_cancel(req, -EFAULT);


