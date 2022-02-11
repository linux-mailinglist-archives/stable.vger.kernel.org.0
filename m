Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A18D4B216C
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348435AbiBKJSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:18:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245049AbiBKJSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:18:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC228333
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BD47B828BE
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB09FC340E9;
        Fri, 11 Feb 2022 09:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644571090;
        bh=SC5jk4v9pHJ5pvOcrcLZ+LoquVZkVLpw9tUAIE4q9c8=;
        h=Subject:To:Cc:From:Date:From;
        b=gTIyEUVrSpM47PTGAN7QCaTg7klOOhbONTCAjJRU1RiGxM9vlKQY2TUmEBUR8nQdh
         8IrgBN56kerSZdGbRB8EQOL2vpkO9TKklZdxvI1TY/XMWmcm0D11imRFQ8rlAb1U5g
         BT0PM2Zgi39bHLViKBmy2adp+4hupEsBIZ/5oVH4=
Subject: FAILED: patch "[PATCH] NFSD: COMMIT operations must not return NFS?ERR_INVAL" failed to apply to 4.9-stable tree
To:     chuck.lever@oracle.com, bfields@fieldses.org,
        dan.aloni@vastdata.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:17:56 +0100
Message-ID: <1644571076161126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3f965021c8bc38965ecb1924f570c4842b33d408 Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Mon, 24 Jan 2022 15:50:31 -0500
Subject: [PATCH] NFSD: COMMIT operations must not return NFS?ERR_INVAL

Since, well, forever, the Linux NFS server's nfsd_commit() function
has returned nfserr_inval when the passed-in byte range arguments
were non-sensical.

However, according to RFC 1813 section 3.3.21, NFSv3 COMMIT requests
are permitted to return only the following non-zero status codes:

      NFS3ERR_IO
      NFS3ERR_STALE
      NFS3ERR_BADHANDLE
      NFS3ERR_SERVERFAULT

NFS3ERR_INVAL is not included in that list. Likewise, NFS4ERR_INVAL
is not listed in the COMMIT row of Table 6 in RFC 8881.

RFC 7530 does permit COMMIT to return NFS4ERR_INVAL, but does not
specify when it can or should be used.

Instead of dropping or failing a COMMIT request in a byte range that
is not supported, turn it into a valid request by treating one or
both arguments as zero. Offset zero means start-of-file, count zero
means until-end-of-file, so we only ever extend the commit range.
NFS servers are always allowed to commit more and sooner than
requested.

The range check is no longer bounded by NFS_OFFSET_MAX, but rather
by the value that is returned in the maxfilesize field of the NFSv3
FSINFO procedure or the NFSv4 maxfilesize file attribute.

Note that this change results in a new pynfs failure:

CMT4     st_commit.testCommitOverflow                             : RUNNING
CMT4     st_commit.testCommitOverflow                             : FAILURE
           COMMIT with offset + count overflow should return
           NFS4ERR_INVAL, instead got NFS4_OK

IMO the test is not correct as written: RFC 8881 does not allow the
COMMIT operation to return NFS4ERR_INVAL.

Reported-by: Dan Aloni <dan.aloni@vastdata.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Bruce Fields <bfields@fieldses.org>

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index aca38ed1526e..52ad1972cc33 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -663,15 +663,9 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 				argp->count,
 				(unsigned long long) argp->offset);
 
-	if (argp->offset > NFS_OFFSET_MAX) {
-		resp->status = nfserr_inval;
-		goto out;
-	}
-
 	fh_copy(&resp->fh, &argp->fh);
 	resp->status = nfsd_commit(rqstp, &resp->fh, argp->offset,
 				   argp->count, resp->verf);
-out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 0cccceb105e7..91600e71be19 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1114,42 +1114,61 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
 }
 
 #ifdef CONFIG_NFSD_V3
-/*
- * Commit all pending writes to stable storage.
+/**
+ * nfsd_commit - Commit pending writes to stable storage
+ * @rqstp: RPC request being processed
+ * @fhp: NFS filehandle
+ * @offset: raw offset from beginning of file
+ * @count: raw count of bytes to sync
+ * @verf: filled in with the server's current write verifier
  *
- * Note: we only guarantee that data that lies within the range specified
- * by the 'offset' and 'count' parameters will be synced.
+ * Note: we guarantee that data that lies within the range specified
+ * by the 'offset' and 'count' parameters will be synced. The server
+ * is permitted to sync data that lies outside this range at the
+ * same time.
  *
  * Unfortunately we cannot lock the file to make sure we return full WCC
  * data to the client, as locking happens lower down in the filesystem.
+ *
+ * Return values:
+ *   An nfsstat value in network byte order.
  */
 __be32
-nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
-               loff_t offset, unsigned long count, __be32 *verf)
+nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
+	    u32 count, __be32 *verf)
 {
+	u64			maxbytes;
+	loff_t			start, end;
 	struct nfsd_net		*nn;
 	struct nfsd_file	*nf;
-	loff_t			end = LLONG_MAX;
-	__be32			err = nfserr_inval;
-
-	if (offset < 0)
-		goto out;
-	if (count != 0) {
-		end = offset + (loff_t)count - 1;
-		if (end < offset)
-			goto out;
-	}
+	__be32			err;
 
 	err = nfsd_file_acquire(rqstp, fhp,
 			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &nf);
 	if (err)
 		goto out;
+
+	/*
+	 * Convert the client-provided (offset, count) range to a
+	 * (start, end) range. If the client-provided range falls
+	 * outside the maximum file size of the underlying FS,
+	 * clamp the sync range appropriately.
+	 */
+	start = 0;
+	end = LLONG_MAX;
+	maxbytes = (u64)fhp->fh_dentry->d_sb->s_maxbytes;
+	if (offset < maxbytes) {
+		start = offset;
+		if (count && (offset + count - 1 < maxbytes))
+			end = offset + count - 1;
+	}
+
 	nn = net_generic(nf->nf_net, nfsd_net_id);
 	if (EX_ISSYNC(fhp->fh_export)) {
 		errseq_t since = READ_ONCE(nf->nf_file->f_wb_err);
 		int err2;
 
-		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
+		err2 = vfs_fsync_range(nf->nf_file, start, end, 0);
 		switch (err2) {
 		case 0:
 			nfsd_copy_write_verifier(verf, nn);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 9f56dcb22ff7..2c43d10e3cab 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -74,8 +74,8 @@ __be32		do_nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
 				struct svc_fh *res, int createmode,
 				u32 *verifier, bool *truncp, bool *created);
-__be32		nfsd_commit(struct svc_rqst *, struct svc_fh *,
-				loff_t, unsigned long, __be32 *verf);
+__be32		nfsd_commit(struct svc_rqst *rqst, struct svc_fh *fhp,
+				u64 offset, u32 count, __be32 *verf);
 #endif /* CONFIG_NFSD_V3 */
 #ifdef CONFIG_NFSD_V4
 __be32		nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp,

