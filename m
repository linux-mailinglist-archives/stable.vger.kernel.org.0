Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385BA382FAA
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbhEQOS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238829AbhEQOQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7506F613F4;
        Mon, 17 May 2021 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260587;
        bh=PLQN45btVF9hG27pLm4Y59CORPu1wYJbfxs747vrNtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEWymAeCdr75G/zIPkNeenUWgwqQn7dcZfL+b84aRQkO3tpY80xbNrcGiqQ64ePJV
         wMW07+wCMOjQq7lxtGoamItY0P8GIeKJ9WEqZpFniWoMVmxNoU4jZQBZ1qyhd7qgfz
         hou9IBIhMuKAoRdSuNFrkb5diTfjmZVftqnF/oyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 150/363] NFS: nfs4_bitmask_adjust() must not change the server global bitmasks
Date:   Mon, 17 May 2021 16:00:16 +0200
Message-Id: <20210517140307.680454161@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index c65c4b41e2c1..820abae88cf0 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -108,9 +108,10 @@ static int nfs41_test_stateid(struct nfs_server *, nfs4_stateid *,
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
@@ -3591,6 +3592,7 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state *state = calldata->state;
 	struct inode *inode = calldata->inode;
+	struct nfs_server *server = NFS_SERVER(inode);
 	struct pnfs_layout_hdr *lo;
 	bool is_rdonly, is_wronly, is_rdwr;
 	int call_close = 0;
@@ -3647,8 +3649,10 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
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
@@ -5416,19 +5420,17 @@ bool nfs4_write_need_cache_consistency_data(struct nfs_pgio_header *hdr)
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
@@ -5437,16 +5439,22 @@ static void nfs4_bitmask_adjust(__u32 *bitmask, struct inode *inode,
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
@@ -5459,8 +5467,10 @@ static void nfs4_proc_write_setup(struct nfs_pgio_header *hdr,
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
@@ -6502,8 +6512,10 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 
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



