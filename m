Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC3020E6E7
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgF2Vvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B476B2473F;
        Mon, 29 Jun 2020 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444061;
        bh=jMfwoJdsKP0RmTBoO2cdnVTnTbpVcsC+aElQbPfJfsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTYwJZhAnd4zvERCovYAsEbS5lLlHeLe8yx4sf1ByLQRLpgC11wBAPiev2GEBFIgc
         1UeSz68kcjifuMGPLk70T/SFNeHoWR8n+tfbYOqekZ+Zc5qHIK7xnyOPbWlq9lH5Na
         oj0iFb41474PdJ4Cr779ldyaHt7vpab7KtBG/tHg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 169/265] io_uring: fix hanging iopoll in case of -EAGAIN
Date:   Mon, 29 Jun 2020 11:16:42 -0400
Message-Id: <20200629151818.2493727-170-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit cd664b0e35cb1202f40c259a1a5ea791d18c879d ]

io_do_iopoll() won't do anything with a request unless
req->iopoll_completed is set. So io_complete_rw_iopoll() has to set
it, otherwise io_do_iopoll() will poll a file again and again even
though the request of interest was completed long time ago.

Also, remove -EAGAIN check from io_issue_sqe() as it races with
the changed lines. The request will take the long way and be
resubmitted from io_iopoll*().

io_kiocb's result and iopoll_completed")

Fixes: bbde017a32b3 ("io_uring: add memory barrier to synchronize
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1829be7f63a35..4ab1728de247c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1942,10 +1942,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	WRITE_ONCE(req->result, res);
 	/* order with io_poll_complete() checking ->result */
-	if (res != -EAGAIN) {
-		smp_wmb();
-		WRITE_ONCE(req->iopoll_completed, 1);
-	}
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
 }
 
 /*
@@ -5425,9 +5423,6 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file) {
 		const bool in_async = io_wq_current_is_worker();
 
-		if (req->result == -EAGAIN)
-			return -EAGAIN;
-
 		/* workqueue context doesn't hold uring_lock, grab it now */
 		if (in_async)
 			mutex_lock(&ctx->uring_lock);
-- 
2.25.1

