Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A491466C4D7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjAPP6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbjAPP6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFD51CAFE
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5532961031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65169C433F0;
        Mon, 16 Jan 2023 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884722;
        bh=bLIixCXO5aHTRjNFkmuTWZ47NICS/E/FMvIu2Qso/Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykMeO5WIMx1oy77Ztzn/jhJzlW3jdjc0uilobdqG3WjguoihgGXZawakLnLsnHHhG
         qFeJWuRCwkW4vFZS2X3SUFeE2Qq2FNFwgsHPz+PGCMbnNSEtpwJ9qTLf0N+4C8sg6v
         aiLfSL0+cCtV28rAboOKVa6KXg37jZXE7GL+jVf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, NeilBrown <neilb@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/183] NFSD: Add an NFSD_FILE_GC flag to enable nfsd_file garbage collection
Date:   Mon, 16 Jan 2023 16:50:38 +0100
Message-Id: <20230116154808.248292003@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4d1ea8455716ca070e3cd85767e6f6a562a58b1b ]

NFSv4 operations manage the lifetime of nfsd_file items they use by
means of NFSv4 OPEN and CLOSE. Hence there's no need for them to be
garbage collected.

Introduce a mechanism to enable garbage collection for nfsd_file
items used only by NFSv2/3 callers.

Note that the change in nfsd_file_put() ensures that both CLOSE and
DELEGRETURN will actually close out and free an nfsd_file on last
reference of a non-garbage-collected file.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=394
Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 0b3a551fa58b ("nfsd: fix handling of cached open files in nfsd4_open codepath")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 63 +++++++++++++++++++++++++++++++++++++++------
 fs/nfsd/filecache.h |  3 +++
 fs/nfsd/nfs3proc.c  |  4 +--
 fs/nfsd/trace.h     |  3 ++-
 fs/nfsd/vfs.c       |  4 +--
 5 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index babea79d3f6f..cee44405cf7d 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -63,6 +63,7 @@ struct nfsd_file_lookup_key {
 	struct net			*net;
 	const struct cred		*cred;
 	unsigned char			need;
+	bool				gc;
 	enum nfsd_file_lookup_type	type;
 };
 
@@ -162,6 +163,8 @@ static int nfsd_file_obj_cmpfn(struct rhashtable_compare_arg *arg,
 			return 1;
 		if (!nfsd_match_cred(nf->nf_cred, key->cred))
 			return 1;
+		if (!!test_bit(NFSD_FILE_GC, &nf->nf_flags) != key->gc)
+			return 1;
 		if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0)
 			return 1;
 		break;
@@ -297,6 +300,8 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 		nf->nf_flags = 0;
 		__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
 		__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
+		if (key->gc)
+			__set_bit(NFSD_FILE_GC, &nf->nf_flags);
 		nf->nf_inode = key->inode;
 		/* nf_ref is pre-incremented for hash table */
 		refcount_set(&nf->nf_ref, 2);
@@ -428,16 +433,27 @@ nfsd_file_put_noref(struct nfsd_file *nf)
 	}
 }
 
+static void
+nfsd_file_unhash_and_put(struct nfsd_file *nf)
+{
+	if (nfsd_file_unhash(nf))
+		nfsd_file_put_noref(nf);
+}
+
 void
 nfsd_file_put(struct nfsd_file *nf)
 {
 	might_sleep();
 
-	nfsd_file_lru_add(nf);
-	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
+	if (test_bit(NFSD_FILE_GC, &nf->nf_flags))
+		nfsd_file_lru_add(nf);
+	else if (refcount_read(&nf->nf_ref) == 2)
+		nfsd_file_unhash_and_put(nf);
+
+	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
-	} else if (nf->nf_file) {
+	} else if (nf->nf_file && test_bit(NFSD_FILE_GC, &nf->nf_flags)) {
 		nfsd_file_put_noref(nf);
 		nfsd_file_schedule_laundrette();
 	} else
@@ -1016,12 +1032,14 @@ nfsd_file_is_cached(struct inode *inode)
 
 static __be32
 nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		     unsigned int may_flags, struct nfsd_file **pnf, bool open)
+		     unsigned int may_flags, struct nfsd_file **pnf,
+		     bool open, bool want_gc)
 {
 	struct nfsd_file_lookup_key key = {
 		.type	= NFSD_FILE_KEY_FULL,
 		.need	= may_flags & NFSD_FILE_MAY_MASK,
 		.net	= SVC_NET(rqstp),
+		.gc	= want_gc,
 	};
 	bool open_retry = true;
 	struct nfsd_file *nf;
@@ -1117,14 +1135,35 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 * then unhash.
 	 */
 	if (status != nfs_ok || key.inode->i_nlink == 0)
-		if (nfsd_file_unhash(nf))
-			nfsd_file_put_noref(nf);
+		nfsd_file_unhash_and_put(nf);
 	clear_bit_unlock(NFSD_FILE_PENDING, &nf->nf_flags);
 	smp_mb__after_atomic();
 	wake_up_bit(&nf->nf_flags, NFSD_FILE_PENDING);
 	goto out;
 }
 
+/**
+ * nfsd_file_acquire_gc - Get a struct nfsd_file with an open file
+ * @rqstp: the RPC transaction being executed
+ * @fhp: the NFS filehandle of the file to be opened
+ * @may_flags: NFSD_MAY_ settings for the file
+ * @pnf: OUT: new or found "struct nfsd_file" object
+ *
+ * The nfsd_file object returned by this API is reference-counted
+ * and garbage-collected. The object is retained for a few
+ * seconds after the final nfsd_file_put() in case the caller
+ * wants to re-use it.
+ *
+ * Returns nfs_ok and sets @pnf on success; otherwise an nfsstat in
+ * network byte order is returned.
+ */
+__be32
+nfsd_file_acquire_gc(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		     unsigned int may_flags, struct nfsd_file **pnf)
+{
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true, true);
+}
+
 /**
  * nfsd_file_acquire - Get a struct nfsd_file with an open file
  * @rqstp: the RPC transaction being executed
@@ -1132,6 +1171,10 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * @may_flags: NFSD_MAY_ settings for the file
  * @pnf: OUT: new or found "struct nfsd_file" object
  *
+ * The nfsd_file_object returned by this API is reference-counted
+ * but not garbage-collected. The object is unhashed after the
+ * final nfsd_file_put().
+ *
  * Returns nfs_ok and sets @pnf on success; otherwise an nfsstat in
  * network byte order is returned.
  */
@@ -1139,7 +1182,7 @@ __be32
 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true, false);
 }
 
 /**
@@ -1149,6 +1192,10 @@ nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * @may_flags: NFSD_MAY_ settings for the file
  * @pnf: OUT: new or found "struct nfsd_file" object
  *
+ * The nfsd_file_object returned by this API is reference-counted
+ * but not garbage-collected. The object is released immediately
+ * one RCU grace period after the final nfsd_file_put().
+ *
  * Returns nfs_ok and sets @pnf on success; otherwise an nfsstat in
  * network byte order is returned.
  */
@@ -1156,7 +1203,7 @@ __be32
 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		 unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, false);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, false, false);
 }
 
 /*
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 6b012ea4bd9d..b7efb2c3ddb1 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -38,6 +38,7 @@ struct nfsd_file {
 #define NFSD_FILE_HASHED	(0)
 #define NFSD_FILE_PENDING	(1)
 #define NFSD_FILE_REFERENCED	(2)
+#define NFSD_FILE_GC		(3)
 	unsigned long		nf_flags;
 	struct inode		*nf_inode;	/* don't deref */
 	refcount_t		nf_ref;
@@ -55,6 +56,8 @@ void nfsd_file_put(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
 bool nfsd_file_is_cached(struct inode *inode);
+__be32 nfsd_file_acquire_gc(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		  unsigned int may_flags, struct nfsd_file **nfp);
 __be32 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **nfp);
 __be32 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index ff2920546333..d01b29aba662 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -772,8 +772,8 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 				(unsigned long long) argp->offset);
 
 	fh_copy(&resp->fh, &argp->fh);
-	resp->status = nfsd_file_acquire(rqstp, &resp->fh, NFSD_MAY_WRITE |
-					 NFSD_MAY_NOT_BREAK_LEASE, &nf);
+	resp->status = nfsd_file_acquire_gc(rqstp, &resp->fh, NFSD_MAY_WRITE |
+					    NFSD_MAY_NOT_BREAK_LEASE, &nf);
 	if (resp->status)
 		goto out;
 	resp->status = nfsd_commit(rqstp, &resp->fh, nf, argp->offset,
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index d4b6839bb459..3fcfeb7b560f 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -817,7 +817,8 @@ DEFINE_CLID_EVENT(confirmed_r);
 	__print_flags(val, "|",						\
 		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\
 		{ 1 << NFSD_FILE_PENDING,	"PENDING" },		\
-		{ 1 << NFSD_FILE_REFERENCED,	"REFERENCED"})
+		{ 1 << NFSD_FILE_REFERENCED,	"REFERENCED"},		\
+		{ 1 << NFSD_FILE_GC,		"GC"})
 
 DECLARE_EVENT_CLASS(nfsd_file_class,
 	TP_PROTO(struct nfsd_file *nf),
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index f1919834a99d..2934ab1d9862 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1085,7 +1085,7 @@ __be32 nfsd_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	__be32 err;
 
 	trace_nfsd_read_start(rqstp, fhp, offset, *count);
-	err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_READ, &nf);
+	err = nfsd_file_acquire_gc(rqstp, fhp, NFSD_MAY_READ, &nf);
 	if (err)
 		return err;
 
@@ -1117,7 +1117,7 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
 
 	trace_nfsd_write_start(rqstp, fhp, offset, *cnt);
 
-	err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_WRITE, &nf);
+	err = nfsd_file_acquire_gc(rqstp, fhp, NFSD_MAY_WRITE, &nf);
 	if (err)
 		goto out;
 
-- 
2.35.1



