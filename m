Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B92341C6C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhCSMUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhCSMUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 637D964F6C;
        Fri, 19 Mar 2021 12:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156429;
        bh=sCMkvCqPmTJ24Ic4kxeLx+gcO9ngMfso4B3PQOYl3KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOaC55kayGrLNYLZXD4s2zrOgv0EdDHKnqFHAF5IAhZy4KbuE2m22USNzpFyK+EJF
         qFQYgNzv62WVJIUJ32PQwdV5g/ElfjLZPi+IqxHB+0jO4zOUmYWcmXznQcGXFo2XFJ
         iol+otX/nqKiJVcykKq7bDFUrS46AVumBntM098E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 10/31] io_uring: simplify do_read return parsing
Date:   Fri, 19 Mar 2021 13:19:04 +0100
Message-Id: <20210319121747.534509392@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 57cd657b8272a66277c139e7bbdc8b86057cb415 ]

do_read() returning 0 bytes read (not -EAGAIN/etc.) is not an important
enough of a case to prioritise it. Fold it into ret < 0 check, so we get
rid of an extra if and make it a bit more readable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cab380a337e4..c18e4a334614 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3518,7 +3518,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	else
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
-
 	/* If the file doesn't support async, just async punt */
 	no_async = force_nonblock && !io_file_supports_async(req->file, READ);
 	if (no_async)
@@ -3530,9 +3529,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 
 	ret = io_iter_do_read(req, iter);
 
-	if (!ret) {
-		goto done;
-	} else if (ret == -EIOCBQUEUED) {
+	if (ret == -EIOCBQUEUED) {
 		ret = 0;
 		goto out_free;
 	} else if (ret == -EAGAIN) {
@@ -3546,7 +3543,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
 		goto copy_iov;
-	} else if (ret < 0) {
+	} else if (ret <= 0) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;
 	}
-- 
2.30.1



