Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2603118B672
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgCSN1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730598AbgCSN07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8602208C3;
        Thu, 19 Mar 2020 13:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624419;
        bh=b3bOkk7ZC4+C3aa6UbVcLXBKkb5po7Ss9Qec2vR6Up0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFT1SgD6b4R8ct+vcdRaEx/O3CarG/OOozlQHKp+6CW/IREBt7TpcKiQmlLbLg4Jq
         q+qOuLnG0avd7yqkJfem1Wm+5n3AiMYfmn93b7gcUpqOHK2aXlvPOdXT0khhHuOjEP
         QQUnSitFjKHJUz5/8FaObGdMBgtI1tvk9YGOkC4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 36/65] io_uring: pick up link work on submit reference drop
Date:   Thu, 19 Mar 2020 14:04:18 +0100
Message-Id: <20200319123937.881530419@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c8f8cc2463986..2547c6395d5e4 100644
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
@@ -3569,7 +3569,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 err:
 	/* drop submission reference */
-	io_put_req(req);
+	io_put_req_find_next(req, &nxt);
 
 	if (linked_timeout) {
 		if (!ret)
-- 
2.20.1



