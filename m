Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30E02E3FCA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392069AbgL1Ool (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:44:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503162AbgL1OY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A387422AEC;
        Mon, 28 Dec 2020 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165457;
        bh=pMvmUkbPIgx+8nGnsq2F0E4jxQfgWmKkiJllS1egw94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lriEL4bP3RTKKZfCh4aRBHoZRECLZ3g+La2y2Mde9h/gyW2tnxo5In37wnjPjAJlz
         q4qgVzXF7CLdfuieew36MvkMWGVIY2H8oRN9XsOJGhs12PztJsgkpIvAMIW3EBaLzA
         YhP2/mdPiw7qdWuIZ5Tj7CJpYgVxMDBWs8QjRJa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 511/717] io_uring: fix racy IOPOLL completions
Date:   Mon, 28 Dec 2020 13:48:29 +0100
Message-Id: <20201228125045.447543868@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 31bff9a51b264df6d144931a6a5f1d6cc815ed4b upstream.

IOPOLL allows buffer remove/provide requests, but they doesn't
synchronise by rules of IOPOLL, namely it have to hold uring_lock.

Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3944,11 +3944,17 @@ static int io_remove_buffers(struct io_k
 	head = idr_find(&ctx->io_buffer_idr, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
-
-	io_ring_submit_lock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+
+	/* need to hold the lock to complete IOPOLL requests */
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		__io_req_complete(req, ret, 0, cs);
+		io_ring_submit_unlock(ctx, !force_nonblock);
+	} else {
+		io_ring_submit_unlock(ctx, !force_nonblock);
+		__io_req_complete(req, ret, 0, cs);
+	}
 	return 0;
 }
 
@@ -4033,10 +4039,17 @@ static int io_provide_buffers(struct io_
 		}
 	}
 out:
-	io_ring_submit_unlock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+
+	/* need to hold the lock to complete IOPOLL requests */
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		__io_req_complete(req, ret, 0, cs);
+		io_ring_submit_unlock(ctx, !force_nonblock);
+	} else {
+		io_ring_submit_unlock(ctx, !force_nonblock);
+		__io_req_complete(req, ret, 0, cs);
+	}
 	return 0;
 }
 


