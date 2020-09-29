Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F05427BA32
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725272AbgI2BgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbgI2Baw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA8721D43;
        Tue, 29 Sep 2020 01:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343047;
        bh=mQw6OM3u2KV7FtkFQ65Z0Bp1vJ5Xuw66f17h80F5flE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zl9b9IaOHL+Hp1rBbP6ES7g3/DD+BAiyIQeSvKU3I68i+TDr3iua0ewZ9NQ9v6MQA
         B/xs7MRiW/J1yX5QLdlPTVeofMdlXYYPh48wQ6okhR6Pcc11B4TFW+Oogssl2hgqYw
         4aGpWrGhg3J4q9s10A/SNQRQwhUS/EpnI7RvmaYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Qian Cai <cai@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 15/29] fuse: fix the ->direct_IO() treatment of iov_iter
Date:   Mon, 28 Sep 2020 21:30:12 -0400
Message-Id: <20200929013027.2406344-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 83d917f7e5425..98e170cc0b932 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3091,11 +3091,10 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
 
@@ -3103,17 +3102,9 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
@@ -3129,15 +3120,22 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
@@ -3155,6 +3153,7 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	} else {
 		ret = __fuse_direct_read(io, iter, &pos);
 	}
+	iov_iter_reexpand(iter, iov_iter_count(iter) + shortened);
 
 	if (io->async) {
 		bool blocking = io->blocking;
-- 
2.25.1

