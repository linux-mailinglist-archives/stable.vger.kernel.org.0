Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745F140E0DD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhIPQZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241921AbhIPQXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:23:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A5F61501;
        Thu, 16 Sep 2021 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808942;
        bh=bkT8Ib29D0PmBO6CIcRjFAwjuMQvPjyTaYdr8R8O6is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3A1okUusnrLleCIt6iChhOxoWcodkk0ca8CNxyctrNuyRMSISAKnYKCw+tbdD/93
         tKkxTGhuOTX1kD7rPFGWRl1wX/RdsA1k0ll22w+rei8P5rC8uXIANPnqo6dc0v8TuH
         4tB7m3QPVC2L2goU2AUo9xIsNiN74L1FFpK+n1hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Laight <david.laight@aculab.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/306] fs/io_uring Dont use the return value from import_iovec().
Date:   Thu, 16 Sep 2021 18:00:23 +0200
Message-Id: <20210916155803.557131514@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 10fc72e43352753a08f9cf83aa5c40baec00d212 ]

This is the only code that relies on import_iovec() returning
iter.count on success.
This allows a better interface to import_iovec().

Signed-off-by: David Laight <david.laight@aculab.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6978a42fa39b..8de0f52fd29d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3128,7 +3128,7 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
 		*iovec = NULL;
-		return ret < 0 ? ret : sqe_len;
+		return ret;
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
@@ -3154,7 +3154,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (!iorw)
 		return __io_import_iovec(rw, req, iovec, iter, needs_lock);
 	*iovec = NULL;
-	return iov_iter_count(&iorw->iter);
+	return 0;
 }
 
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
@@ -3423,7 +3423,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (ret < 0)
 		return ret;
 	iov_count = iov_iter_count(iter);
-	io_size = ret;
+	io_size = iov_count;
 	req->result = io_size;
 	ret = 0;
 
@@ -3552,7 +3552,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (ret < 0)
 		return ret;
 	iov_count = iov_iter_count(iter);
-	io_size = ret;
+	io_size = iov_count;
 	req->result = io_size;
 
 	/* Ensure we clear previously set non-block flag */
-- 
2.30.2



