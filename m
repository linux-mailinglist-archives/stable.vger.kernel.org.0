Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C311541FEA
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 02:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583396AbiFGXqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 19:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444062AbiFGXBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:01:41 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F59227CD64
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 13:11:05 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i1so15742726plg.7
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 13:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iuJE0Q7DfXnlnhnw0IIXOuSAghXg0uVOqcT62LbQKmY=;
        b=NpKV9Yd6aOZrr8/iFam1dEkVPjO3lpzl91PT14yntsl1g59u1pTLLlSZowN73CyPJi
         ZyJglMANiw8igrxmofhVPO4Yf95idfw+fATUY4UEO9MiEETPfhY/SfnBNcgN4mYOo6nd
         YeCQ9Aqze6yrfKCNOs0d+kqg4Yb7C1tnpwbikRcRN3N558BP0pOFoBrHN9gyNgnupMv+
         RKz7VZcw//y1FrPz2u2E5jjyogSL7fayOrH/rBB2ESSeW4/XqSdOP4TgPuWCt6zjJW5T
         GOjUjA+kFIUy66PpYLu9TuZSF7Dxf5FErnsWAewFVrFMTwonJRTePeb5DflGerXyBHb+
         a3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iuJE0Q7DfXnlnhnw0IIXOuSAghXg0uVOqcT62LbQKmY=;
        b=ACmjTAMTbdNNWeYiGlMYkOx6ItxC6Swg/L3Ju56gytRjC/jLBrmp4E5cjErK7d9ImE
         BjK+6zH2XE0oFVeJL5AtfQaiGjmwpmYIlQhKfSmWud4KZaSLhLn2IR8n+7uGDjAIIavD
         V6DjKo6AeTL+BQaBZGQnHjr/ZKg+JdCs9QDpDZzrza24mnicBVQzM1c5wYIHnJ9K9Lyf
         DddqEqgMRmNc8wDIQU7B1oZCtl+2sFP0uLYCEnx25exiJNR4vIBdalh63ZmTPxI9wopr
         vYg7u0Iw5Se/9T2JOveh1B8MVJ2ci3EtRwkaxIDPW8qQhCGWwb7ec73gfT03N+D4vdcC
         kCVQ==
X-Gm-Message-State: AOAM531tvX17P5pO1rM2tLHaRJqP7VvKRxFvZvhKZmHRR5mAC69ifUoK
        HAUy3QcFGpv4KItN7sPlofGMMRvf2FQ=
X-Google-Smtp-Source: ABdhPJy0RWKGmf/jiYlG9OpG/P8SGJOYzqILLhvMpXzg/rJyCtT44XFNwFfLIKR0naCPKY6FiqwWog==
X-Received: by 2002:a17:90b:1a8f:b0:1e8:7dfe:c4f with SMTP id ng15-20020a17090b1a8f00b001e87dfe0c4fmr13709869pjb.17.1654632664432;
        Tue, 07 Jun 2022 13:11:04 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:9454:edb9:ddbb:8c27])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b00163c6ac211fsm12921110plb.111.2022.06.07.13.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 13:11:03 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
X-Google-Original-From: Leah Rumancik <lrumancik@google.com>
To:     stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.10] nfsd: Replace use of rwsem with errseq_t
Date:   Tue,  7 Jun 2022 13:10:36 -0700
Message-Id: <20220607201036.4018806-1-lrumancik@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
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

[Leah: This patch is for 5.10. 5011af4c698a ("nfsd: Fix stable writes")
introduced a 75% performance regression on parallel random write
workloads. With this commit, the performance is restored to 90% of what
it was prior to 5011af4c698a. The changes to the fsync for asynchronous
copies were not included in this backport version as the fsync was not
added until 5.14 (eac0b17a77fb).]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
[ cel: rebased on zero-verifier fix ]
---
 fs/nfsd/filecache.c |  1 -
 fs/nfsd/filecache.h |  1 -
 fs/nfsd/nfs4proc.c  |  7 ++++---
 fs/nfsd/vfs.c       | 40 +++++++++++++++-------------------------
 4 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index acd0898e3866..e30e1ddc1ace 100644
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
index 7850d141c762..735ee8a79870 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1380,6 +1380,8 @@ static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
 
 static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 {
+	struct file *dst = copy->nf_dst->nf_file;
+	struct file *src = copy->nf_src->nf_file;
 	ssize_t bytes_copied = 0;
 	size_t bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
@@ -1388,9 +1390,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
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
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 011cd570b50d..548ebc913f92 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -535,10 +535,11 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
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
@@ -552,6 +553,8 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 		loff_t dst_end = count ? dst_pos + count - 1 : LLONG_MAX;
 		int status = vfs_fsync_range(dst, dst_pos, dst_end, 0);
 
+		if (!status)
+			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
 			status = commit_inode_metadata(file_inode(src));
 		if (status < 0) {
@@ -561,7 +564,6 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 		}
 	}
 out_err:
-	up_write(&nf_dst->nf_rwsem);
 	return ret;
 }
 
@@ -980,6 +982,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	struct file		*file = nf->nf_file;
 	struct svc_export	*exp;
 	struct iov_iter		iter;
+	errseq_t		since;
 	__be32			nfserr;
 	int			host_err;
 	int			use_wgather;
@@ -1009,21 +1012,18 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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
@@ -1033,6 +1033,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	*cnt = host_err;
 	nfsdstats.io_write += *cnt;
 	fsnotify_modify(file);
+	host_err = filemap_check_wb_err(file->f_mapping, since);
+	if (host_err < 0)
+		goto out_nfserr;
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
@@ -1113,19 +1116,6 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
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
@@ -1156,25 +1146,25 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
2.36.1.255.ge46751e96f-goog

