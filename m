Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467151C4491
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732192AbgEDSHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732176AbgEDSHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034E6206B8;
        Mon,  4 May 2020 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615666;
        bh=r3c1iXelmmBrzj0DTZL4IUaoj5TuLR7/oHUZShSDMrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3pK66oL+V2je3XUHuHIqIzfTqdANHvJT34CvSWIFbkk5k+ZUgjBT+fRuPXmLFE76
         IWwO0ZZXp2MaA6KjbsfconSk4G5kFoqeetI8b1qpCgxhJJt/tnPQmqIiWm4iSE09pt
         UyO9ZBDvd1lRR1PZ+EFM06HpdpTK0JHcEtn/UJDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clay Harris <bugs@claycon.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 73/73] io_uring: statx must grab the file table for valid fd
Date:   Mon,  4 May 2020 19:58:16 +0200
Message-Id: <20200504165510.640529034@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 5b0bbee4732cbd58aa98213d4c11a366356bba3d upstream.

Clay reports that OP_STATX fails for a test case with a valid fd
and empty path:

 -- Test 0: statx:fd 3: SUCCEED, file mode 100755
 -- Test 1: statx:path ./uring_statx: SUCCEED, file mode 100755
 -- Test 2: io_uring_statx:fd 3: FAIL, errno 9: Bad file descriptor
 -- Test 3: io_uring_statx:path ./uring_statx: SUCCEED, file mode 100755

This is due to statx not grabbing the process file table, hence we can't
lookup the fd in async context. If the fd is valid, ensure that we grab
the file table so we can grab the file from async context.

Cc: stable@vger.kernel.org # v5.6
Reported-by: Clay Harris <bugs@claycon.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -479,6 +479,7 @@ enum {
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
+	REQ_F_NO_FILE_TABLE_BIT,
 };
 
 enum {
@@ -521,6 +522,8 @@ enum {
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 	/* in overflow list */
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
+	/* doesn't need file table for this request */
+	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 };
 
 /*
@@ -711,6 +714,7 @@ static const struct io_op_def io_op_defs
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.needs_fs		= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
@@ -2843,8 +2847,12 @@ static int io_statx(struct io_kiocb *req
 	struct kstat stat;
 	int ret;
 
-	if (force_nonblock)
+	if (force_nonblock) {
+		/* only need file table for an actual valid fd */
+		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
+			req->flags |= REQ_F_NO_FILE_TABLE;
 		return -EAGAIN;
+	}
 
 	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->how.flags))
 		return -EINVAL;
@@ -4632,7 +4640,7 @@ static int io_grab_files(struct io_kiocb
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->work.files)
+	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
 	if (!ctx->ring_file)
 		return -EBADF;


