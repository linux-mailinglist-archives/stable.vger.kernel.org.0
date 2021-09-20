Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37AA41263B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386510AbhITS4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384621AbhITSsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C72663376;
        Mon, 20 Sep 2021 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159250;
        bh=68CSBNoOkQxtmzCjZxQEbBNMeVx3W16PkVILzt8smsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIHGKDEvS0QSYCZu2ctUARvHz6mwQQVDJUIGcLlR+Cf0iCWCUnRshVgw466nmcZ5F
         1j6Xz7x2ywSLKKzGumV6EgewZSqw5mgHKR4hZdW+AXVf1GNPpDzSABYqdF8Z8qgPpf
         qpbqglpIP9m2sC7E5jjm4M3tNTh8ZdRj/a9WptTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 146/168] io_uring: retry in case of short read on block device
Date:   Mon, 20 Sep 2021 18:44:44 +0200
Message-Id: <20210920163926.455947511@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 7db304375e11741e5940f9bc549155035bfb4dc1 ]

In case of buffered reading from block device, when short read happens,
we should retry to read more, otherwise the IO will be completed
partially, for example, the following fio expects to read 2MB, but it
can only read 1M or less bytes:

    fio --name=onessd --filename=/dev/nvme0n1 --filesize=2M \
	--rw=randread --bs=2M --direct=0 --overwrite=0 --numjobs=1 \
	--iodepth=1 --time_based=0 --runtime=2 --ioengine=io_uring \
	--registerfiles --fixedbufs --gtod_reduce=1 --group_reporting

Fix the issue by allowing short read retry for block device, which sets
FMODE_BUF_RASYNC really.

Fixes: 9a173346bd9e ("io_uring: fix short read retries for non-reg files")
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/20210821150751.1290434-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0361c48c9cb0..43aaa3566431 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3286,6 +3286,12 @@ static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 		return -EINVAL;
 }
 
+static bool need_read_all(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_ISREG ||
+		S_ISBLK(file_inode(req->file)->i_mode);
+}
+
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -3340,7 +3346,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} else if (ret == -EIOCBQUEUED) {
 		goto out_free;
 	} else if (ret <= 0 || ret == io_size || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !(req->flags & REQ_F_ISREG)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
-- 
2.30.2



