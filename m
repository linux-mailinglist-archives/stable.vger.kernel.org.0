Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F7E54A2DF
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 01:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiFMXnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 19:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343523AbiFMXns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 19:43:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B69E32053
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 16:43:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 184so6949941pga.12
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 16:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lxj1qqSCARnUzChh5n04EMITAZHIERov4a0tv+pl+zI=;
        b=pQQ4YUhzuBvLVxjYOjejRxog03vBsUz8X3ddXdVox5P4jNm00YSvlhEveBYuEzh7ag
         CsjQFH6Ktwu/d2MIF5Ykxz/CKQA5NLgHaTyqHaVo120Z7KVslwny8gjTdNcYJ56888DB
         abcUTH+9jmzOMl23NbQ/0kBEhgRHJSIParmll9S6PtpCQGfDsPTPNAaWORT7vKxFMJ1q
         9c2bxeZ86HDbf/zVvQPnZm5KvRV9jrLetUmU0UdVOVQOcePO6Z1ByFrYZ9xezhpZSRIE
         kOxkrQNSJ4lJ57cZU43LU+2T2Y+mQ+0hbCKL3CQDqbRm+Ww1eybXpjvFfeVtrg10cJAr
         6iRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lxj1qqSCARnUzChh5n04EMITAZHIERov4a0tv+pl+zI=;
        b=o9LYxxqZLusA9LK9Q3/3405yoHtf7WvDE0fIJyrLbUPNCLffIvpNRyYc4LUvbBopXx
         rp5DhqUGijw8fGcdfQ8ClxG5yk0S63oApPmI7Kx96xJ+cwU+/GQP7NRuGzTi8rowsatc
         NY6PhaOUUBNrJ8y56efUcFgqDjsrWFGrcjoyT/7Tq02dyGiYgt/cCQtkmMvxxpPZOUUf
         rbcO6IPzSaVws8ToNwq8DF52hU1K+IFGsOlsRLeTa3AoK3aQzQCXAqyn3ilnIvK71st1
         jEENZYTbHVHwAkxCyzr90wXxLex8EHuAYwPo6PeZ15rNbTqMHEJZ14VLwF3V09VYXpf7
         w5vg==
X-Gm-Message-State: AOAM533mWy1Gy64f6xQORyYhteqNKA/P6FJsgko8MQHMDXx4D10lPfnV
        oHNGhuF1M2qKiUPugr0G3XtmX6aOQ1xdsA==
X-Google-Smtp-Source: ABdhPJyXPzpq1JYxYKGWhDIrhWRStfXWbJUUYQ9s7y092iqG5qEJaQQ2PJcCVki3kogG8znGqn4aEw==
X-Received: by 2002:a05:6a00:1a47:b0:522:93a6:4751 with SMTP id h7-20020a056a001a4700b0052293a64751mr1788863pfv.78.1655163825323;
        Mon, 13 Jun 2022 16:43:45 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:a528:1c1:719a:3775])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b001637529493esm5698220plm.66.2022.06.13.16.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:43:44 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15] nfsd: Replace use of rwsem with errseq_t
Date:   Mon, 13 Jun 2022 16:43:23 -0700
Message-Id: <20220613234323.343938-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 555dbf1a9aac6d3150c8b52fa35f768a692f4eeb ]

The nfsd_file nf_rwsem is currently being used to separate file write
and commit instances to ensure that we catch errors and apply them to
the correct write/commit.
We can improve scalability at the expense of a little accuracy (some
extra false positives) by replacing the nf_rwsem with more careful
use of the errseq_t mechanism to track errors across the different
operations.

[Leah: This patch helps restore performance from the 75%
parallel random write regression introduced by
5011af4c698a ("nfsd: Fix stable writes").]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
[ cel: rebased on zero-verifier fix ]
---
 fs/nfsd/filecache.c |  1 -
 fs/nfsd/filecache.h |  1 -
 fs/nfsd/nfs4proc.c  | 16 +++++++++-------
 fs/nfsd/vfs.c       | 40 +++++++++++++++-------------------------
 4 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7e23c588f484..87d984e0cdc0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -194,7 +194,6 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 				__set_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
 		}
 		nf->nf_mark = NULL;
-		init_rwsem(&nf->nf_rwsem);
 		trace_nfsd_file_alloc(nf);
 	}
 	return nf;
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 7872df5a0fe3..435ceab27897 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -46,7 +46,6 @@ struct nfsd_file {
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
-	struct rw_semaphore	nf_rwsem;
 };
 
 int nfsd_file_cache_init(void);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 65200910107f..f7584787dab2 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1515,6 +1515,9 @@ static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
 
 static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 {
+	struct file *dst = copy->nf_dst->nf_file;
+	struct file *src = copy->nf_src->nf_file;
+	errseq_t since;
 	ssize_t bytes_copied = 0;
 	u64 bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
@@ -1527,9 +1530,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
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
@@ -1539,11 +1541,11 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	} while (bytes_total > 0 && !copy->cp_synchronous);
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (!copy->cp_synchronous && copy->cp_res.wr_bytes_written > 0) {
-		down_write(&copy->nf_dst->nf_rwsem);
-		status = vfs_fsync_range(copy->nf_dst->nf_file,
-					 copy->cp_dst_pos,
+		since = READ_ONCE(dst->f_wb_err);
+		status = vfs_fsync_range(dst, copy->cp_dst_pos,
 					 copy->cp_res.wr_bytes_written, 0);
-		up_write(&copy->nf_dst->nf_rwsem);
+		if (!status)
+			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
 			copy->committed = true;
 	}
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 271f7c15d6e5..7bfb68583154 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -525,10 +525,11 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
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
@@ -542,6 +543,8 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 		loff_t dst_end = count ? dst_pos + count - 1 : LLONG_MAX;
 		int status = vfs_fsync_range(dst, dst_pos, dst_end, 0);
 
+		if (!status)
+			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
 			status = commit_inode_metadata(file_inode(src));
 		if (status < 0) {
@@ -551,7 +554,6 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 		}
 	}
 out_err:
-	up_write(&nf_dst->nf_rwsem);
 	return ret;
 }
 
@@ -954,6 +956,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	struct super_block	*sb = file_inode(file)->i_sb;
 	struct svc_export	*exp;
 	struct iov_iter		iter;
+	errseq_t		since;
 	__be32			nfserr;
 	int			host_err;
 	int			use_wgather;
@@ -991,8 +994,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 		flags |= RWF_SYNC;
 
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
+	since = READ_ONCE(file->f_wb_err);
 	if (flags & RWF_SYNC) {
-		down_write(&nf->nf_rwsem);
 		if (verf)
 			nfsd_copy_boot_verifier(verf,
 					net_generic(SVC_NET(rqstp),
@@ -1001,15 +1004,12 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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
@@ -1019,6 +1019,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	*cnt = host_err;
 	nfsd_stats_io_write_add(exp, *cnt);
 	fsnotify_modify(file);
+	host_err = filemap_check_wb_err(file->f_mapping, since);
+	if (host_err < 0)
+		goto out_nfserr;
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
@@ -1099,19 +1102,6 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
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
@@ -1142,25 +1132,25 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
-- 
2.36.1.476.g0c4daa206d-goog

