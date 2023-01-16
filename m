Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFE666C4D5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjAPP6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjAPP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28582E386
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5EABB8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB68C433EF;
        Mon, 16 Jan 2023 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884717;
        bh=Oj74gTAKhW5lNCbAziir7YxcO7AItb/aIDK+b8PKRRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oU+gTs23N4bs0GroqwIhks2cF6kRR8PLW3qK2HM7bFHpsqjn3BgXrX6yK6GnjYMB1
         zAGE2NoalbyH+qgMsQuqpmhGR+8r+z9bICSxOczK/WKkOwksxd4cjNN84+ovr5lcgx
         cALHXUdJ+gHZJav47wzqso/IDJydzeewVa9Do/sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, NeilBrown <neilb@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/183] NFSD: Pass the target nfsd_file to nfsd_commit()
Date:   Mon, 16 Jan 2023 16:50:36 +0100
Message-Id: <20230116154808.157772753@linuxfoundation.org>
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

[ Upstream commit c252849082ff525af18b4f253b3c9ece94e951ed ]

In a moment I'm going to introduce separate nfsd_file types, one of
which is garbage-collected; the other, not. The garbage-collected
variety is to be used by NFSv2 and v3, and the non-garbage-collected
variety is to be used by NFSv4.

nfsd_commit() is invoked by both NFSv3 and NFSv4 consumers. We want
nfsd_commit() to find and use the correct variety of cached
nfsd_file object for the NFS version that is in use.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Stable-dep-of: 0b3a551fa58b ("nfsd: fix handling of cached open files in nfsd4_open codepath")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 10 +++++++++-
 fs/nfsd/nfs4proc.c | 11 ++++++++++-
 fs/nfsd/vfs.c      | 15 ++++-----------
 fs/nfsd/vfs.h      |  3 ++-
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 923d9a80df92..ff2920546333 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -13,6 +13,7 @@
 #include "cache.h"
 #include "xdr3.h"
 #include "vfs.h"
+#include "filecache.h"
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
@@ -763,6 +764,7 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 {
 	struct nfsd3_commitargs *argp = rqstp->rq_argp;
 	struct nfsd3_commitres *resp = rqstp->rq_resp;
+	struct nfsd_file *nf;
 
 	dprintk("nfsd: COMMIT(3)   %s %u@%Lu\n",
 				SVCFH_fmt(&argp->fh),
@@ -770,8 +772,14 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 				(unsigned long long) argp->offset);
 
 	fh_copy(&resp->fh, &argp->fh);
-	resp->status = nfsd_commit(rqstp, &resp->fh, argp->offset,
+	resp->status = nfsd_file_acquire(rqstp, &resp->fh, NFSD_MAY_WRITE |
+					 NFSD_MAY_NOT_BREAK_LEASE, &nf);
+	if (resp->status)
+		goto out;
+	resp->status = nfsd_commit(rqstp, &resp->fh, nf, argp->offset,
 				   argp->count, resp->verf);
+	nfsd_file_put(nf);
+out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c7329523a10f..30a08ec31a70 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -731,10 +731,19 @@ nfsd4_commit(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     union nfsd4_op_u *u)
 {
 	struct nfsd4_commit *commit = &u->commit;
+	struct nfsd_file *nf;
+	__be32 status;
 
-	return nfsd_commit(rqstp, &cstate->current_fh, commit->co_offset,
+	status = nfsd_file_acquire(rqstp, &cstate->current_fh, NFSD_MAY_WRITE |
+				   NFSD_MAY_NOT_BREAK_LEASE, &nf);
+	if (status != nfs_ok)
+		return status;
+
+	status = nfsd_commit(rqstp, &cstate->current_fh, nf, commit->co_offset,
 			     commit->co_count,
 			     (__be32 *)commit->co_verf.data);
+	nfsd_file_put(nf);
+	return status;
 }
 
 static __be32
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 849a720ab43f..f1919834a99d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1133,6 +1133,7 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
  * nfsd_commit - Commit pending writes to stable storage
  * @rqstp: RPC request being processed
  * @fhp: NFS filehandle
+ * @nf: target file
  * @offset: raw offset from beginning of file
  * @count: raw count of bytes to sync
  * @verf: filled in with the server's current write verifier
@@ -1149,19 +1150,13 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
  *   An nfsstat value in network byte order.
  */
 __be32
-nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
-	    u32 count, __be32 *verf)
+nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
+	    u64 offset, u32 count, __be32 *verf)
 {
+	__be32			err = nfs_ok;
 	u64			maxbytes;
 	loff_t			start, end;
 	struct nfsd_net		*nn;
-	struct nfsd_file	*nf;
-	__be32			err;
-
-	err = nfsd_file_acquire(rqstp, fhp,
-			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &nf);
-	if (err)
-		goto out;
 
 	/*
 	 * Convert the client-provided (offset, count) range to a
@@ -1202,8 +1197,6 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
 	} else
 		nfsd_copy_write_verifier(verf, nn);
 
-	nfsd_file_put(nf);
-out:
 	return err;
 }
 
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 120521bc7b24..9744b041105b 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -88,7 +88,8 @@ __be32		nfsd_access(struct svc_rqst *, struct svc_fh *, u32 *, u32 *);
 __be32		nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				struct svc_fh *resfhp, struct nfsd_attrs *iap);
 __be32		nfsd_commit(struct svc_rqst *rqst, struct svc_fh *fhp,
-				u64 offset, u32 count, __be32 *verf);
+				struct nfsd_file *nf, u64 offset, u32 count,
+				__be32 *verf);
 #ifdef CONFIG_NFSD_V4
 __be32		nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			    char *name, void **bufp, int *lenp);
-- 
2.35.1



