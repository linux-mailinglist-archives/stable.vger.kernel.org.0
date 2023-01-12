Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840A766724F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjALMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjALMgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5621F6444
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D1960A69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF587C433EF;
        Thu, 12 Jan 2023 12:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673527005;
        bh=snnzhRbFyFuzVv6RJ57coTLYMPhoISfB+4yqROe/WN0=;
        h=Subject:To:Cc:From:Date:From;
        b=nbiEnGLmdWvaj1dIURaeOAzoJEmgIVq0z6xg3xLVL6pe6yfwoPLtlXjA1z5qakKhA
         bkNp0vtMy2JjA5h8D5+UKuUO6f2KegxSwKbv94iieX0QLD0EXcevDBXW7QIfIsRlB4
         OTiCmOnWCKH+ndP9tGrxYmfbYTSLw43zDDZ5ZDbQ=
Subject: FAILED: patch "[PATCH] nfsd: fix handling of cached open files in nfsd4_open" failed to apply to 6.1-stable tree
To:     jlayton@kernel.org, chuck.lever@oracle.com, rubenv@drcmr.dk,
        ssaner@redhat.com, torkil@drcmr.dk, trondmy@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Jan 2023 13:36:42 +0100
Message-ID: <167352700281120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0b3a551fa58b ("nfsd: fix handling of cached open files in nfsd4_open codepath")
ac3a2585f018 ("nfsd: rework refcounting in filecache")
d7064eaf688c ("NFSD: Add an nfsd_file_fsync tracepoint")
821411858988 ("nfsd: reorganize filecache.c")
1f696e230ea5 ("nfsd: remove the pages_flushed statistic from filecache")
4d1ea8455716 ("NFSD: Add an NFSD_FILE_GC flag to enable nfsd_file garbage collection")
dcf3f80965ca ("NFSD: Revert "NFSD: NFSv4 CLOSE should release an nfsd_file immediately"")
c252849082ff ("NFSD: Pass the target nfsd_file to nfsd_commit()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b3a551fa58b4da941efeb209b3770868e2eddd7 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 5 Jan 2023 14:55:56 -0500
Subject: [PATCH] nfsd: fix handling of cached open files in nfsd4_open
 codepath

Commit fb70bf124b05 ("NFSD: Instantiate a struct file when creating a
regular NFSv4 file") added the ability to cache an open fd over a
compound. There are a couple of problems with the way this currently
works:

It's racy, as a newly-created nfsd_file can end up with its PENDING bit
cleared while the nf is hashed, and the nf_file pointer is still zeroed
out. Other tasks can find it in this state and they expect to see a
valid nf_file, and can oops if nf_file is NULL.

Also, there is no guarantee that we'll end up creating a new nfsd_file
if one is already in the hash. If an extant entry is in the hash with a
valid nf_file, nfs4_get_vfs_file will clobber its nf_file pointer with
the value of op_file and the old nf_file will leak.

Fix both issues by making a new nfsd_file_acquirei_opened variant that
takes an optional file pointer. If one is present when this is called,
we'll take a new reference to it instead of trying to open the file. If
the nfsd_file already has a valid nf_file, we'll just ignore the
optional file and pass the nfsd_file back as-is.

Also rework the tracepoints a bit to allow for an "opened" variant and
don't try to avoid counting acquisitions in the case where we already
have a cached open file.

Fixes: fb70bf124b05 ("NFSD: Instantiate a struct file when creating a regular NFSv4 file")
Cc: Trond Myklebust <trondmy@hammerspace.com>
Reported-by: Stanislav Saner <ssaner@redhat.com>
Reported-and-Tested-by: Ruben Vestergaard <rubenv@drcmr.dk>
Reported-and-Tested-by: Torkil Svensgaard <torkil@drcmr.dk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 45b2c9e3f636..0ef070349014 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1071,8 +1071,8 @@ nfsd_file_is_cached(struct inode *inode)
 
 static __be32
 nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		     unsigned int may_flags, struct nfsd_file **pnf,
-		     bool open, bool want_gc)
+		     unsigned int may_flags, struct file *file,
+		     struct nfsd_file **pnf, bool want_gc)
 {
 	struct nfsd_file_lookup_key key = {
 		.type	= NFSD_FILE_KEY_FULL,
@@ -1147,8 +1147,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	status = nfserrno(nfsd_open_break_lease(file_inode(nf->nf_file), may_flags));
 out:
 	if (status == nfs_ok) {
-		if (open)
-			this_cpu_inc(nfsd_file_acquisitions);
+		this_cpu_inc(nfsd_file_acquisitions);
 		*pnf = nf;
 	} else {
 		if (refcount_dec_and_test(&nf->nf_ref))
@@ -1158,20 +1157,23 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 out_status:
 	put_cred(key.cred);
-	if (open)
-		trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
+	trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
 	return status;
 
 open_file:
 	trace_nfsd_file_alloc(nf);
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf, key.inode);
 	if (nf->nf_mark) {
-		if (open) {
+		if (file) {
+			get_file(file);
+			nf->nf_file = file;
+			status = nfs_ok;
+			trace_nfsd_file_opened(nf, status);
+		} else {
 			status = nfsd_open_verified(rqstp, fhp, may_flags,
 						    &nf->nf_file);
 			trace_nfsd_file_open(nf, status);
-		} else
-			status = nfs_ok;
+		}
 	} else
 		status = nfserr_jukebox;
 	/*
@@ -1207,7 +1209,7 @@ __be32
 nfsd_file_acquire_gc(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		     unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true, true);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, NULL, pnf, true);
 }
 
 /**
@@ -1228,28 +1230,30 @@ __be32
 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true, false);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, NULL, pnf, false);
 }
 
 /**
- * nfsd_file_create - Get a struct nfsd_file, do not open
+ * nfsd_file_acquire_opened - Get a struct nfsd_file using existing open file
  * @rqstp: the RPC transaction being executed
  * @fhp: the NFS filehandle of the file just created
  * @may_flags: NFSD_MAY_ settings for the file
+ * @file: cached, already-open file (may be NULL)
  * @pnf: OUT: new or found "struct nfsd_file" object
  *
- * The nfsd_file_object returned by this API is reference-counted
- * but not garbage-collected. The object is released immediately
- * one RCU grace period after the final nfsd_file_put().
+ * Acquire a nfsd_file object that is not GC'ed. If one doesn't already exist,
+ * and @file is non-NULL, use it to instantiate a new nfsd_file instead of
+ * opening a new one.
  *
  * Returns nfs_ok and sets @pnf on success; otherwise an nfsstat in
  * network byte order is returned.
  */
 __be32
-nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		 unsigned int may_flags, struct nfsd_file **pnf)
+nfsd_file_acquire_opened(struct svc_rqst *rqstp, struct svc_fh *fhp,
+			 unsigned int may_flags, struct file *file,
+			 struct nfsd_file **pnf)
 {
-	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, false, false);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, file, pnf, false);
 }
 
 /*
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index b7efb2c3ddb1..41516a4263ea 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -60,7 +60,8 @@ __be32 nfsd_file_acquire_gc(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **nfp);
 __be32 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **nfp);
-__be32 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		  unsigned int may_flags, struct nfsd_file **nfp);
+__be32 nfsd_file_acquire_opened(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		  unsigned int may_flags, struct file *file,
+		  struct nfsd_file **nfp);
 int nfsd_file_cache_stats_show(struct seq_file *m, void *v);
 #endif /* _FS_NFSD_FILECACHE_H */
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e1e85c21f12b..313f666d5357 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5262,18 +5262,10 @@ static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *fp,
 	if (!fp->fi_fds[oflag]) {
 		spin_unlock(&fp->fi_lock);
 
-		if (!open->op_filp) {
-			status = nfsd_file_acquire(rqstp, cur_fh, access, &nf);
-			if (status != nfs_ok)
-				goto out_put_access;
-		} else {
-			status = nfsd_file_create(rqstp, cur_fh, access, &nf);
-			if (status != nfs_ok)
-				goto out_put_access;
-			nf->nf_file = open->op_filp;
-			open->op_filp = NULL;
-			trace_nfsd_file_create(rqstp, access, nf);
-		}
+		status = nfsd_file_acquire_opened(rqstp, cur_fh, access,
+						  open->op_filp, &nf);
+		if (status != nfs_ok)
+			goto out_put_access;
 
 		spin_lock(&fp->fi_lock);
 		if (!fp->fi_fds[oflag]) {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c852ae8eaf37..8f9c82d9e075 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -981,43 +981,6 @@ TRACE_EVENT(nfsd_file_acquire,
 	)
 );
 
-TRACE_EVENT(nfsd_file_create,
-	TP_PROTO(
-		const struct svc_rqst *rqstp,
-		unsigned int may_flags,
-		const struct nfsd_file *nf
-	),
-
-	TP_ARGS(rqstp, may_flags, nf),
-
-	TP_STRUCT__entry(
-		__field(const void *, nf_inode)
-		__field(const void *, nf_file)
-		__field(unsigned long, may_flags)
-		__field(unsigned long, nf_flags)
-		__field(unsigned long, nf_may)
-		__field(unsigned int, nf_ref)
-		__field(u32, xid)
-	),
-
-	TP_fast_assign(
-		__entry->nf_inode = nf->nf_inode;
-		__entry->nf_file = nf->nf_file;
-		__entry->may_flags = may_flags;
-		__entry->nf_flags = nf->nf_flags;
-		__entry->nf_may = nf->nf_may;
-		__entry->nf_ref = refcount_read(&nf->nf_ref);
-		__entry->xid = be32_to_cpu(rqstp->rq_xid);
-	),
-
-	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%u nf_flags=%s nf_may=%s nf_file=%p",
-		__entry->xid, __entry->nf_inode,
-		show_nfsd_may_flags(__entry->may_flags),
-		__entry->nf_ref, show_nf_flags(__entry->nf_flags),
-		show_nfsd_may_flags(__entry->nf_may), __entry->nf_file
-	)
-);
-
 TRACE_EVENT(nfsd_file_insert_err,
 	TP_PROTO(
 		const struct svc_rqst *rqstp,
@@ -1079,8 +1042,8 @@ TRACE_EVENT(nfsd_file_cons_err,
 	)
 );
 
-TRACE_EVENT(nfsd_file_open,
-	TP_PROTO(struct nfsd_file *nf, __be32 status),
+DECLARE_EVENT_CLASS(nfsd_file_open_class,
+	TP_PROTO(const struct nfsd_file *nf, __be32 status),
 	TP_ARGS(nf, status),
 	TP_STRUCT__entry(
 		__field(void *, nf_inode)	/* cannot be dereferenced */
@@ -1104,6 +1067,17 @@ TRACE_EVENT(nfsd_file_open,
 		__entry->nf_file)
 )
 
+#define DEFINE_NFSD_FILE_OPEN_EVENT(name)					\
+DEFINE_EVENT(nfsd_file_open_class, name,					\
+	TP_PROTO(							\
+		const struct nfsd_file *nf,				\
+		__be32 status						\
+	),								\
+	TP_ARGS(nf, status))
+
+DEFINE_NFSD_FILE_OPEN_EVENT(nfsd_file_open);
+DEFINE_NFSD_FILE_OPEN_EVENT(nfsd_file_opened);
+
 TRACE_EVENT(nfsd_file_is_cached,
 	TP_PROTO(
 		const struct inode *inode,

