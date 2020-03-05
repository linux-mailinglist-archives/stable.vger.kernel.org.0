Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4445617ACB1
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgCEROI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbgCEROH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A6F32146E;
        Thu,  5 Mar 2020 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428446;
        bh=Fd5mXYSIkdYOZviVLVfQIG/AbZvQecDxCTGdLIxVWH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJSup7gQwVkhjRiSWeH1J9Z1W7EpfjdmlddKsQFaev1Bfj7LauEFJ3bH1tERiQoK6
         KCuAiWvPfyU/LzH6IdAIfpKggGNfJdhJPvxNGsyxHx+T5+pNE0jICHyxqYDgXqpDBV
         YjKjaUpjDixEkuWdBApTkJy4/tfokBHERbE6UWmQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 42/67] io_uring: pick up link work on submit reference drop
Date:   Thu,  5 Mar 2020 12:12:43 -0500
Message-Id: <20200305171309.29118-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 2a44f46781617c5040372b59da33553a02b1f46d ]

If work completes inline, then we should pick up a dependent link item
in __io_queue_sqe() as well. If we don't do so, we're forced to go async
with that item, which is suboptimal.

This also fixes an issue with io_put_req_find_next(), which always looks
up the next work item. That should only be done if we're dropping the
last reference to the request, to prevent multiple lookups of the same
work item.

Outside of being a fix, this also enables a good cleanup series for 5.7,
where we never have to pass 'nxt' around or into the work handlers.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95df7026ac5aa..39b18ab928210 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1099,10 +1099,10 @@ static void io_free_req(struct io_kiocb *req)
 __attribute__((nonnull))
 static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 {
-	io_req_find_next(req, nxtptr);
-
-	if (refcount_dec_and_test(&req->refs))
+	if (refcount_dec_and_test(&req->refs)) {
+		io_req_find_next(req, nxtptr);
 		__io_free_req(req);
+	}
 }
 
 static void io_put_req(struct io_kiocb *req)
@@ -3559,7 +3559,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 err:
 	/* drop submission reference */
-	io_put_req(req);
+	io_put_req_find_next(req, &nxt);
 
 	if (linked_timeout) {
 		if (!ret)
-- 
2.20.1

