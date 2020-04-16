Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7FF1AC90C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442373AbgDPPSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898746AbgDPNsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:48:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D39208E4;
        Thu, 16 Apr 2020 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044911;
        bh=BAqaTz0T9ZLSoESWHVpY+5zttuwGC2+hAE3UYDhFKOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7N0m5RjiP42FcbsZpIXulchpjICSYjtT6eIO27o5fHfCkCPFvznaTmEH4Qs1QQtI
         HdyQ+wW9iJiwpZhGL5/U7QmbylLXoT4oxGqlsBWmswt+t3Q6/KLuiFGOLiNPPMwV06
         eOrmlD9cKY9c9fEOXVniFQcABPwnse8W7tD7uWgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 152/232] io_uring: honor original task RLIMIT_FSIZE
Date:   Thu, 16 Apr 2020 15:24:06 +0200
Message-Id: <20200416131334.008677152@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 4ed734b0d0913e566a9d871e15d24eb240f269f7 upstream.

With the previous fixes for number of files open checking, I added some
debug code to see if we had other spots where we're checking rlimit()
against the async io-wq workers. The only one I found was file size
checking, which we should also honor.

During write and fallocate prep, store the max file size and override
that for the current ask if we're in io-wq worker context.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/io_uring.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -331,6 +331,7 @@ struct io_kiocb {
 #define REQ_F_ISREG		2048	/* regular file */
 #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
 #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
+	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1085,6 +1086,9 @@ static int io_prep_rw(struct io_kiocb *r
 	if (S_ISREG(file_inode(req->file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
+	if (force_nonblock)
+		req->fsize = rlimit(RLIMIT_FSIZE);
+
 	/*
 	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
 	 * we know to async punt it even if it was opened O_NONBLOCK
@@ -1504,10 +1508,17 @@ static int io_write(struct io_kiocb *req
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (file->f_op->write_iter)
 			ret2 = call_write_iter(file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			io_rw_done(kiocb, ret2);
 		} else {


