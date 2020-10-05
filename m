Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220B8283B48
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgJEPky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbgJEP3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CDA621481;
        Mon,  5 Oct 2020 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911747;
        bh=KnfAmQCDLWxrgUP4TjvPtfODWHnIpaoEfhe3KY3zoWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pddKAzbG2mzUjJJQtdJHOAYkGSAdfQfBDrNShX6CdQZLfv2M4iulQwqn14Hv7Bw/Y
         Kn9xysfoRGvvU8WEX7DydQ8Pdx6CVBSlJGqh/LhEJ2AfSX4CfnAGHTXvy8mtNNqGeV
         qrMhpfuqQv+y1FRh+EXJRPIREz4BVReTFcNIurh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/57] fuse: fix the ->direct_IO() treatment of iov_iter
Date:   Mon,  5 Oct 2020 17:26:35 +0200
Message-Id: <20201005142110.910869859@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 933a3752babcf6513117d5773d2b70782d6ad149 ]

the callers rely upon having any iov_iter_truncate() done inside
->direct_IO() countered by iov_iter_reexpand().

Reported-by: Qian Cai <cai@redhat.com>
Tested-by: Qian Cai <cai@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f8d8a8e34b808..ab4fc1255aca8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3074,11 +3074,10 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret = 0;
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
-	bool async_dio = ff->fc->async_dio;
 	loff_t pos = 0;
 	struct inode *inode;
 	loff_t i_size;
-	size_t count = iov_iter_count(iter);
+	size_t count = iov_iter_count(iter), shortened = 0;
 	loff_t offset = iocb->ki_pos;
 	struct fuse_io_priv *io;
 
@@ -3086,17 +3085,9 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	inode = file->f_mapping->host;
 	i_size = i_size_read(inode);
 
-	if ((iov_iter_rw(iter) == READ) && (offset > i_size))
+	if ((iov_iter_rw(iter) == READ) && (offset >= i_size))
 		return 0;
 
-	/* optimization for short read */
-	if (async_dio && iov_iter_rw(iter) != WRITE && offset + count > i_size) {
-		if (offset >= i_size)
-			return 0;
-		iov_iter_truncate(iter, fuse_round_up(ff->fc, i_size - offset));
-		count = iov_iter_count(iter);
-	}
-
 	io = kmalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
 	if (!io)
 		return -ENOMEM;
@@ -3112,15 +3103,22 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	 * By default, we want to optimize all I/Os with async request
 	 * submission to the client filesystem if supported.
 	 */
-	io->async = async_dio;
+	io->async = ff->fc->async_dio;
 	io->iocb = iocb;
 	io->blocking = is_sync_kiocb(iocb);
 
+	/* optimization for short read */
+	if (io->async && !io->write && offset + count > i_size) {
+		iov_iter_truncate(iter, fuse_round_up(ff->fc, i_size - offset));
+		shortened = count - iov_iter_count(iter);
+		count -= shortened;
+	}
+
 	/*
 	 * We cannot asynchronously extend the size of a file.
 	 * In such case the aio will behave exactly like sync io.
 	 */
-	if ((offset + count > i_size) && iov_iter_rw(iter) == WRITE)
+	if ((offset + count > i_size) && io->write)
 		io->blocking = true;
 
 	if (io->async && io->blocking) {
@@ -3138,6 +3136,7 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	} else {
 		ret = __fuse_direct_read(io, iter, &pos);
 	}
+	iov_iter_reexpand(iter, iov_iter_count(iter) + shortened);
 
 	if (io->async) {
 		bool blocking = io->blocking;
-- 
2.25.1



