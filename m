Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230B53CE223
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346457AbhGSP3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348297AbhGSPYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C39716147D;
        Mon, 19 Jul 2021 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710658;
        bh=+bHo/nZLfMVhulUzG0CpMJ7OmMMkMDQ9/j1xJuLSjNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7EUVOuBJF/GWlWyvAXeu2u360S/Zktonp3piQp+fKX8HYps3/uL9kVwHWeR54UO6
         RJq8LxPq1/K4ylTNolljQ8FOrhw0J2RrJdX6fD19trcPi+BiqdTxZjUtujHOFvOGIM
         W8e+Zc23a4Jf1SkncH9FDvhFioX0D3eZxY6awfiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 027/351] io_uring: use right task for exiting checks
Date:   Mon, 19 Jul 2021 16:49:33 +0200
Message-Id: <20210719144945.422286319@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
@@ -2040,7 +2040,7 @@ static void __io_req_task_submit(struct
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!(current->flags & PF_EXITING) && !current->in_execve)
+	if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
 		__io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);


