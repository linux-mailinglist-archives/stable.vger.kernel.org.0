Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1DC551AE7
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245149AbiFTNKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343523AbiFTNJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F217E19286;
        Mon, 20 Jun 2022 06:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 189B26154E;
        Mon, 20 Jun 2022 13:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054A9C3411B;
        Mon, 20 Jun 2022 13:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730056;
        bh=nRfTL5ZkQ+5mZ9EPEQF64YRRBhpq8ICgD3DAt2Fm7es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQ4JFhrDu+NEHHQSOFKRzvlZIVgqFYflLQcC0jXUJUbuLA5kbos5iWBW0hVcQW0sT
         J3wX00JZ2eqFoZivkyR/0iixOh3qf4emZLPEc6T8mJllv8VGIl1LWhNNHc9dJKylJe
         2VVxSihQd1iAcRfCAQOz8LgXpAzv7hJXNxKhbMtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.10 02/84] nfsd: Replace use of rwsem with errseq_t
Date:   Mon, 20 Jun 2022 14:50:25 +0200
Message-Id: <20220620124720.957926070@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 555dbf1a9aac6d3150c8b52fa35f768a692f4eeb upstream.

The nfsd_file nf_rwsem is currently being used to separate file write
and commit instances to ensure that we catch errors and apply them to
the correct write/commit.
We can improve scalability at the expense of a little accuracy (some
extra false positives) by replacing the nf_rwsem with more careful
use of the errseq_t mechanism to track errors across the different
operations.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ cel: rebased on zero-verifier fix ]
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/filecache.c |    1 -
 fs/nfsd/filecache.h |    1 -
 fs/nfsd/nfs4proc.c  |    7 ++++---
 fs/nfsd/vfs.c       |   40 +++++++++++++++-------------------------
 4 files changed, 19 insertions(+), 30 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -194,7 +194,6 @@ nfsd_file_alloc(struct inode *inode, uns
 				__set_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
 		}
 		nf->nf_mark = NULL;
-		init_rwsem(&nf->nf_rwsem);
 		trace_nfsd_file_alloc(nf);
 	}
 	return nf;
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -46,7 +46,6 @@ struct nfsd_file {
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
-	struct rw_semaphore	nf_rwsem;
 };
 
 int nfsd_file_cache_init(void);
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1380,6 +1380,8 @@ static void nfsd4_init_copy_res(struct n
 
 static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 {
+	struct file *dst = copy->nf_dst->nf_file;
+	struct file *src = copy->nf_src->nf_file;
 	ssize_t bytes_copied = 0;
 	size_t bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
@@ -1388,9 +1390,8 @@ static ssize_t _nfsd_copy_file_range(str
 	do {
 		if (kthread_should_stop())
 			break;
-		bytes_copied = nfsd_copy_file_range(copy->nf_src->nf_file,
-				src_pos, copy->nf_dst->nf_file, dst_pos,
-				bytes_total);
+		bytes_copied = nfsd_copy_file_range(src, src_pos, dst, dst_pos,
+						    bytes_total);
 		if (bytes_copied <= 0)
 			break;
 		bytes_total -= bytes_copied;
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -535,10 +535,11 @@ __be32 nfsd4_clone_file_range(struct nfs
 {
 	struct file *src = nf_src->nf_file;
 	struct file *dst = nf_dst->nf_file;
+	errseq_t since;
 	loff_t cloned;
 	__be32 ret = 0;
 
-	down_write(&nf_dst->nf_rwsem);
+	since = READ_ONCE(dst->f_wb_err);
 	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count, 0);
 	if (cloned < 0) {
 		ret = nfserrno(cloned);
@@ -553,6 +554,8 @@ __be32 nfsd4_clone_file_range(struct nfs
 		int status = vfs_fsync_range(dst, dst_pos, dst_end, 0);
 
 		if (!status)
+			status = filemap_check_wb_err(dst->f_mapping, since);
+		if (!status)
 			status = commit_inode_metadata(file_inode(src));
 		if (status < 0) {
 			nfsd_reset_boot_verifier(net_generic(nf_dst->nf_net,
@@ -561,7 +564,6 @@ __be32 nfsd4_clone_file_range(struct nfs
 		}
 	}
 out_err:
-	up_write(&nf_dst->nf_rwsem);
 	return ret;
 }
 
@@ -980,6 +982,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	struct file		*file = nf->nf_file;
 	struct svc_export	*exp;
 	struct iov_iter		iter;
+	errseq_t		since;
 	__be32			nfserr;
 	int			host_err;
 	int			use_wgather;
@@ -1009,21 +1012,18 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 		flags |= RWF_SYNC;
 
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
+	since = READ_ONCE(file->f_wb_err);
 	if (flags & RWF_SYNC) {
-		down_write(&nf->nf_rwsem);
 		host_err = vfs_iter_write(file, &iter, &pos, flags);
 		if (host_err < 0)
 			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
 						 nfsd_net_id));
-		up_write(&nf->nf_rwsem);
 	} else {
-		down_read(&nf->nf_rwsem);
 		if (verf)
 			nfsd_copy_boot_verifier(verf,
 					net_generic(SVC_NET(rqstp),
 					nfsd_net_id));
 		host_err = vfs_iter_write(file, &iter, &pos, flags);
-		up_read(&nf->nf_rwsem);
 	}
 	if (host_err < 0) {
 		nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
@@ -1033,6 +1033,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	*cnt = host_err;
 	nfsdstats.io_write += *cnt;
 	fsnotify_modify(file);
+	host_err = filemap_check_wb_err(file->f_mapping, since);
+	if (host_err < 0)
+		goto out_nfserr;
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
@@ -1113,19 +1116,6 @@ out:
 }
 
 #ifdef CONFIG_NFSD_V3
-static int
-nfsd_filemap_write_and_wait_range(struct nfsd_file *nf, loff_t offset,
-				  loff_t end)
-{
-	struct address_space *mapping = nf->nf_file->f_mapping;
-	int ret = filemap_fdatawrite_range(mapping, offset, end);
-
-	if (ret)
-		return ret;
-	filemap_fdatawait_range_keep_errors(mapping, offset, end);
-	return 0;
-}
-
 /*
  * Commit all pending writes to stable storage.
  *
@@ -1156,25 +1146,25 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 	if (err)
 		goto out;
 	if (EX_ISSYNC(fhp->fh_export)) {
-		int err2 = nfsd_filemap_write_and_wait_range(nf, offset, end);
+		errseq_t since = READ_ONCE(nf->nf_file->f_wb_err);
+		int err2;
 
-		down_write(&nf->nf_rwsem);
-		if (!err2)
-			err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
+		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
 		switch (err2) {
 		case 0:
 			nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
 						nfsd_net_id));
+			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
+						    since);
 			break;
 		case -EINVAL:
 			err = nfserr_notsupp;
 			break;
 		default:
-			err = nfserrno(err2);
 			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
 						 nfsd_net_id));
 		}
-		up_write(&nf->nf_rwsem);
+		err = nfserrno(err2);
 	} else
 		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
 					nfsd_net_id));


