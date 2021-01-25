Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE5D302AD2
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbhAYSxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbhAYSxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC5142083E;
        Mon, 25 Jan 2021 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600806;
        bh=l5e/OBhJKWBp+zfB8BHydShTswhpBsBh/hdupU55dVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsmESEFfP4X/xygGH49n+sJWrFjd0QQlfDc/kQTgdaEvHQViGkFanJh1PHpUBPkyv
         ULr6HsoJganvb8hGPZUHmDKGIBegMZsZx4AR38bDBVGhnbxKz6/3r9492tkPs1bfqs
         3CRMkk0gbmms/EMHM+11y4bEbDaIP/+qHemuqDNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 128/199] io_uring: fix short read retries for non-reg files
Date:   Mon, 25 Jan 2021 19:39:10 +0100
Message-Id: <20210125183221.617294291@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9a173346bd9e16ab19c7addb8862d95a5cea9feb upstream.

Sockets and other non-regular files may actually expect short reads to
happen, don't retry reads for them. Because non-reg files don't set
FMODE_BUF_RASYNC and so it won't do second/retry do_read, we can filter
out those cases after first do_read() attempt with ret>0.

Cc: stable@vger.kernel.org # 5.9+
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3461,7 +3461,7 @@ static int io_read(struct io_kiocb *req,
 
 	/* read it all, or we did blocking attempt. no retry. */
 	if (!iov_iter_count(iter) || !force_nonblock ||
-	    (req->file->f_flags & O_NONBLOCK))
+	    (req->file->f_flags & O_NONBLOCK) || !(req->flags & REQ_F_ISREG))
 		goto done;
 
 	io_size -= ret;


