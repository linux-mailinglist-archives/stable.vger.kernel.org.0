Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413DB4FD3B3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiDLHoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352654AbiDLHY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:24:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E46A49918;
        Tue, 12 Apr 2022 00:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8B6E615B4;
        Tue, 12 Apr 2022 07:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FEEC385A1;
        Tue, 12 Apr 2022 07:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746801;
        bh=+d4bTQ/I8oTaiY+mLxPJzu+aamdzeG1+n0tq1uBERPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqn8plP4TJwNxajBeoA/twf6GedmvbUb4omQYWm+/vzJ1tk2SfWZEGOwCz/6tVme8
         dYuZQDt9lrMK81JGvrOG96/jhKlr3hLTz/T/aJnAJcZgo57eszxeGVtY8ONT9sYIaS
         N8SjCrqIv0DryByV26mRU9l9n7L8fInIABNSGPEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 135/285] NFS: swap IO handling is slightly different for O_DIRECT IO
Date:   Tue, 12 Apr 2022 08:29:52 +0200
Message-Id: <20220412062947.563349789@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 64158668ac8b31626a8ce48db4cad08496eb8340 ]

1/ Taking the i_rwsem for swap IO triggers lockdep warnings regarding
   possible deadlocks with "fs_reclaim".  These deadlocks could, I believe,
   eventuate if a buffered read on the swapfile was attempted.

   We don't need coherence with the page cache for a swap file, and
   buffered writes are forbidden anyway.  There is no other need for
   i_rwsem during direct IO.  So never take it for swap_rw()

2/ generic_write_checks() explicitly forbids writes to swap, and
   performs checks that are not needed for swap.  So bypass it
   for swap_rw().

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c        | 42 ++++++++++++++++++++++++++++--------------
 fs/nfs/file.c          |  4 ++--
 include/linux/nfs_fs.h |  8 ++++----
 3 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 9cff8709c80a..e6f104b6f065 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -172,8 +172,8 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
 
 	if (iov_iter_rw(iter) == READ)
-		return nfs_file_direct_read(iocb, iter);
-	return nfs_file_direct_write(iocb, iter);
+		return nfs_file_direct_read(iocb, iter, true);
+	return nfs_file_direct_write(iocb, iter, true);
 }
 
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
@@ -424,6 +424,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_read - file direct read operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers into which to read data
+ * @swap: flag indicating this is swap IO, not O_DIRECT IO
  *
  * We use this function for direct reads instead of calling
  * generic_file_aio_read() in order to avoid gfar's check to see if
@@ -439,7 +440,8 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * client must read the updated atime from the server back into its
  * cache.
  */
-ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter)
+ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
+			     bool swap)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -481,12 +483,14 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter)
 	if (iter_is_iovec(iter))
 		dreq->flags = NFS_ODIRECT_SHOULD_DIRTY;
 
-	nfs_start_io_direct(inode);
+	if (!swap)
+		nfs_start_io_direct(inode);
 
 	NFS_I(inode)->read_io += count;
 	requested = nfs_direct_read_schedule_iovec(dreq, iter, iocb->ki_pos);
 
-	nfs_end_io_direct(inode);
+	if (!swap)
+		nfs_end_io_direct(inode);
 
 	if (requested > 0) {
 		result = nfs_direct_wait(dreq);
@@ -875,6 +879,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_write - file direct write operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers from which to write data
+ * @swap: flag indicating this is swap IO, not O_DIRECT IO
  *
  * We use this function for direct writes instead of calling
  * generic_file_aio_write() in order to avoid taking the inode
@@ -891,7 +896,8 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
  * Note that O_APPEND is not supported for NFS direct writes, as there
  * is no atomic O_APPEND write facility in the NFS protocol.
  */
-ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
+ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter,
+			      bool swap)
 {
 	ssize_t result, requested;
 	size_t count;
@@ -905,7 +911,11 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 	dfprintk(FILE, "NFS: direct write(%pD2, %zd@%Ld)\n",
 		file, iov_iter_count(iter), (long long) iocb->ki_pos);
 
-	result = generic_write_checks(iocb, iter);
+	if (swap)
+		/* bypass generic checks */
+		result =  iov_iter_count(iter);
+	else
+		result = generic_write_checks(iocb, iter);
 	if (result <= 0)
 		return result;
 	count = result;
@@ -936,16 +946,20 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 		dreq->iocb = iocb;
 	pnfs_init_ds_commit_info_ops(&dreq->ds_cinfo, inode);
 
-	nfs_start_io_direct(inode);
+	if (swap) {
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos);
+	} else {
+		nfs_start_io_direct(inode);
 
-	requested = nfs_direct_write_schedule_iovec(dreq, iter, pos);
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos);
 
-	if (mapping->nrpages) {
-		invalidate_inode_pages2_range(mapping,
-					      pos >> PAGE_SHIFT, end);
-	}
+		if (mapping->nrpages) {
+			invalidate_inode_pages2_range(mapping,
+						      pos >> PAGE_SHIFT, end);
+		}
 
-	nfs_end_io_direct(inode);
+		nfs_end_io_direct(inode);
+	}
 
 	if (requested > 0) {
 		result = nfs_direct_wait(dreq);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 24e7dccce355..510541665219 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -161,7 +161,7 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t result;
 
 	if (iocb->ki_flags & IOCB_DIRECT)
-		return nfs_file_direct_read(iocb, to);
+		return nfs_file_direct_read(iocb, to, false);
 
 	dprintk("NFS: read(%pD2, %zu@%lu)\n",
 		iocb->ki_filp,
@@ -616,7 +616,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 		return result;
 
 	if (iocb->ki_flags & IOCB_DIRECT)
-		return nfs_file_direct_write(iocb, from);
+		return nfs_file_direct_write(iocb, from, false);
 
 	dprintk("NFS: write(%pD2, %zu@%Ld)\n",
 		file, iov_iter_count(from), (long long) iocb->ki_pos);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 29a2ab5de1da..92525222abfd 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -512,10 +512,10 @@ static inline const struct cred *nfs_file_cred(struct file *file)
  * linux/fs/nfs/direct.c
  */
 extern ssize_t nfs_direct_IO(struct kiocb *, struct iov_iter *);
-extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
-			struct iov_iter *iter);
-extern ssize_t nfs_file_direct_write(struct kiocb *iocb,
-			struct iov_iter *iter);
+ssize_t nfs_file_direct_read(struct kiocb *iocb,
+			     struct iov_iter *iter, bool swap);
+ssize_t nfs_file_direct_write(struct kiocb *iocb,
+			      struct iov_iter *iter, bool swap);
 
 /*
  * linux/fs/nfs/dir.c
-- 
2.35.1



