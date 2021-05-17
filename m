Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8813833DE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbhEQPDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241618AbhEQPBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0F1B6128A;
        Mon, 17 May 2021 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261625;
        bh=R5VmslT3UOGfeBJXpykDorgcZCJ9Tn+iuIVacZJCy0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTWXRLVW4YoXNK0D8BLAB3G+Mgs7GcoZFLoqIPKA/d8W6OeH828jssnEUMRZ3e3MT
         sgVGe5j5W/Qn81JDxwK1a+miY5mlB3sQik9MtuMeKm+NT9rAItR30PgJi0g872pjgw
         Fg9K04xkOTWM5lo56RzLBdGhzO+WQ/J2Y1wqRvEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 137/329] NFS: nfs4_bitmask_adjust() must not change the server global bitmasks
Date:   Mon, 17 May 2021 16:00:48 +0200
Message-Id: <20210517140306.751055304@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 332d1a0373be32a3a3c152756bca45ff4f4e11b5 ]

As currently set, the calls to nfs4_bitmask_adjust() will end up
overwriting the contents of the nfs_server cache_consistency_bitmask
field.
The intention here should be to modify a private copy of that mask in
the close/delegreturn/write arguments.

Fixes: 76bd5c016ef4 ("NFSv4: make cache consistency bitmask dynamic")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c       | 56 +++++++++++++++++++++++++----------------
 include/linux/nfs_xdr.h | 11 +++++---
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 95d3b8540f8e..8b4d2fc0cb01 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -112,9 +112,10 @@ static int nfs41_test_stateid(struct nfs_server *, nfs4_stateid *,
 static int nfs41_free_stateid(struct nfs_server *, const nfs4_stateid *,
 		const struct cred *, bool);
 #endif
-static void nfs4_bitmask_adjust(__u32 *bitmask, struct inode *inode,
-		struct nfs_server *server,
-		struct nfs4_label *label);
+static void nfs4_bitmask_set(__u32 bitmask[NFS4_BITMASK_SZ],
+			     const __u32 *src, struct inode *inode,
+			     struct nfs_server *server,
+			     struct nfs4_label *label);
 
 #ifdef CONFIG_NFS_V4_SECURITY_LABEL
 static inline struct nfs4_label *
@@ -3598,6 +3599,7 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state *state = calldata->state;
 	struct inode *inode = calldata->inode;
+	struct nfs_server *server = NFS_SERVER(inode);
 	struct pnfs_layout_hdr *lo;
 	bool is_rdonly, is_wronly, is_rdwr;
 	int call_close = 0;
@@ -3654,8 +3656,10 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 	if (calldata->arg.fmode == 0 || calldata->arg.fmode == FMODE_READ) {
 		/* Close-to-open cache consistency revalidation */
 		if (!nfs4_have_delegation(inode, FMODE_READ)) {
-			calldata->arg.bitmask = NFS_SERVER(inode)->cache_consistency_bitmask;
-			nfs4_bitmask_adjust(calldata->arg.bitmask, inode, NFS_SERVER(inode), NULL);
+			nfs4_bitmask_set(calldata->arg.bitmask_store,
+					 server->cache_consistency_bitmask,
+					 inode, server, NULL);
+			calldata->arg.bitmask = calldata->arg.bitmask_store;
 		} else
 			calldata->arg.bitmask = NULL;
 	}
@@ -5423,19 +5427,17 @@ bool nfs4_write_need_cache_consistency_data(struct nfs_pgio_header *hdr)
 	return nfs4_have_delegation(hdr->inode, FMODE_READ) == 0;
 }
 
-static void nfs4_bitmask_adjust(__u32 *bitmask, struct inode *inode,
-				struct nfs_server *server,
-				struct nfs4_label *label)
+static void nfs4_bitmask_set(__u32 bitmask[NFS4_BITMASK_SZ], const __u32 *src,
+			     struct inode *inode, struct nfs_server *server,
+			     struct nfs4_label *label)
 {
-
 	unsigned long cache_validity = READ_ONCE(NFS_I(inode)->cache_validity);
+	unsigned int i;
 
-	if ((cache_validity & NFS_INO_INVALID_DATA) ||
-		(cache_validity & NFS_INO_REVAL_PAGECACHE) ||
-		(cache_validity & NFS_INO_REVAL_FORCED) ||
-		(cache_validity & NFS_INO_INVALID_OTHER))
-		nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, label), inode);
+	memcpy(bitmask, src, sizeof(*bitmask) * NFS4_BITMASK_SZ);
 
+	if (cache_validity & (NFS_INO_INVALID_CHANGE | NFS_INO_REVAL_PAGECACHE))
+		bitmask[0] |= FATTR4_WORD0_CHANGE;
 	if (cache_validity & NFS_INO_INVALID_ATIME)
 		bitmask[1] |= FATTR4_WORD1_TIME_ACCESS;
 	if (cache_validity & NFS_INO_INVALID_OTHER)
@@ -5444,16 +5446,22 @@ static void nfs4_bitmask_adjust(__u32 *bitmask, struct inode *inode,
 				FATTR4_WORD1_NUMLINKS;
 	if (label && label->len && cache_validity & NFS_INO_INVALID_LABEL)
 		bitmask[2] |= FATTR4_WORD2_SECURITY_LABEL;
-	if (cache_validity & NFS_INO_INVALID_CHANGE)
-		bitmask[0] |= FATTR4_WORD0_CHANGE;
 	if (cache_validity & NFS_INO_INVALID_CTIME)
 		bitmask[1] |= FATTR4_WORD1_TIME_METADATA;
 	if (cache_validity & NFS_INO_INVALID_MTIME)
 		bitmask[1] |= FATTR4_WORD1_TIME_MODIFY;
-	if (cache_validity & NFS_INO_INVALID_SIZE)
-		bitmask[0] |= FATTR4_WORD0_SIZE;
 	if (cache_validity & NFS_INO_INVALID_BLOCKS)
 		bitmask[1] |= FATTR4_WORD1_SPACE_USED;
+
+	if (nfs4_have_delegation(inode, FMODE_READ) &&
+	    !(cache_validity & NFS_INO_REVAL_FORCED))
+		bitmask[0] &= ~FATTR4_WORD0_SIZE;
+	else if (cache_validity &
+		 (NFS_INO_INVALID_SIZE | NFS_INO_REVAL_PAGECACHE))
+		bitmask[0] |= FATTR4_WORD0_SIZE;
+
+	for (i = 0; i < NFS4_BITMASK_SZ; i++)
+		bitmask[i] &= server->attr_bitmask[i];
 }
 
 static void nfs4_proc_write_setup(struct nfs_pgio_header *hdr,
@@ -5466,8 +5474,10 @@ static void nfs4_proc_write_setup(struct nfs_pgio_header *hdr,
 		hdr->args.bitmask = NULL;
 		hdr->res.fattr = NULL;
 	} else {
-		hdr->args.bitmask = server->cache_consistency_bitmask;
-		nfs4_bitmask_adjust(hdr->args.bitmask, hdr->inode, server, NULL);
+		nfs4_bitmask_set(hdr->args.bitmask_store,
+				 server->cache_consistency_bitmask,
+				 hdr->inode, server, NULL);
+		hdr->args.bitmask = hdr->args.bitmask_store;
 	}
 
 	if (!hdr->pgio_done_cb)
@@ -6509,8 +6519,10 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 
 	data->args.fhandle = &data->fh;
 	data->args.stateid = &data->stateid;
-	data->args.bitmask = server->cache_consistency_bitmask;
-	nfs4_bitmask_adjust(data->args.bitmask, inode, server, NULL);
+	nfs4_bitmask_set(data->args.bitmask_store,
+			 server->cache_consistency_bitmask, inode, server,
+			 NULL);
+	data->args.bitmask = data->args.bitmask_store;
 	nfs_copy_fh(&data->fh, NFS_FH(inode));
 	nfs4_stateid_copy(&data->stateid, stateid);
 	data->res.fattr = &data->fattr;
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 3327239fa2f9..cc29dee508f7 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -15,6 +15,8 @@
 #define NFS_DEF_FILE_IO_SIZE	(4096U)
 #define NFS_MIN_FILE_IO_SIZE	(1024U)
 
+#define NFS_BITMASK_SZ		3
+
 struct nfs4_string {
 	unsigned int len;
 	char *data;
@@ -525,7 +527,8 @@ struct nfs_closeargs {
 	struct nfs_seqid *	seqid;
 	fmode_t			fmode;
 	u32			share_access;
-	u32 *			bitmask;
+	const u32 *		bitmask;
+	u32			bitmask_store[NFS_BITMASK_SZ];
 	struct nfs4_layoutreturn_args *lr_args;
 };
 
@@ -608,7 +611,8 @@ struct nfs4_delegreturnargs {
 	struct nfs4_sequence_args	seq_args;
 	const struct nfs_fh *fhandle;
 	const nfs4_stateid *stateid;
-	u32 * bitmask;
+	const u32 *bitmask;
+	u32 bitmask_store[NFS_BITMASK_SZ];
 	struct nfs4_layoutreturn_args *lr_args;
 };
 
@@ -648,7 +652,8 @@ struct nfs_pgio_args {
 	union {
 		unsigned int		replen;			/* used by read */
 		struct {
-			u32 *			bitmask;	/* used by write */
+			const u32 *		bitmask;	/* used by write */
+			u32 bitmask_store[NFS_BITMASK_SZ];	/* used by write */
 			enum nfs3_stable_how	stable;		/* used by write */
 		};
 	};
-- 
2.30.2



