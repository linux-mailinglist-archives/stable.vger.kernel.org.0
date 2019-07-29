Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACE9798C0
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388486AbfG2Tet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388368AbfG2Ter (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C655D21655;
        Mon, 29 Jul 2019 19:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428886;
        bh=jaCopXyNxm4Wk6QrldZWioeHJnvX6+H/KQMSalveeoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4145kFaeNQAPNFFjCpExxRzSJJhRXSQEQMf4Ueg2De2m/ZYWOIsxPub+Q0XfSLmp
         n+xFkXS1SyUMhc1pmpUUndyAJ7orchobqWKUEdLpOvxoMTUJy1SUYn7jRiAKjCHrfQ
         C+sSM3t1PAyKbQQakAfdNtBXYulDNd71Gr1wxOhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 216/293] NFSv4: Fix open create exclusive when the server reboots
Date:   Mon, 29 Jul 2019 21:21:47 +0200
Message-Id: <20190729190841.053758169@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8fd1ab747d2b1ec7ec663ad0b41a32eaa35117a8 ]

If the server that does not implement NFSv4.1 persistent session
semantics reboots while we are performing an exclusive create,
then the return value of NFS4ERR_DELAY when we replay the open
during the grace period causes us to lose the verifier.
When the grace period expires, and we present a new verifier,
the server will then correctly reply NFS4ERR_EXIST.

This commit ensures that we always present the same verifier when
replaying the OPEN.

Reported-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a225f98c9903..209a21ed5f97 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1099,6 +1099,12 @@ struct nfs4_opendata {
 	int rpc_status;
 };
 
+struct nfs4_open_createattrs {
+	struct nfs4_label *label;
+	struct iattr *sattr;
+	const __u32 verf[2];
+};
+
 static bool nfs4_clear_cap_atomic_open_v1(struct nfs_server *server,
 		int err, struct nfs4_exception *exception)
 {
@@ -1168,8 +1174,7 @@ static void nfs4_init_opendata_res(struct nfs4_opendata *p)
 
 static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 		struct nfs4_state_owner *sp, fmode_t fmode, int flags,
-		const struct iattr *attrs,
-		struct nfs4_label *label,
+		const struct nfs4_open_createattrs *c,
 		enum open_claim_type4 claim,
 		gfp_t gfp_mask)
 {
@@ -1177,6 +1182,7 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	struct inode *dir = d_inode(parent);
 	struct nfs_server *server = NFS_SERVER(dir);
 	struct nfs_seqid *(*alloc_seqid)(struct nfs_seqid_counter *, gfp_t);
+	struct nfs4_label *label = (c != NULL) ? c->label : NULL;
 	struct nfs4_opendata *p;
 
 	p = kzalloc(sizeof(*p), gfp_mask);
@@ -1242,15 +1248,11 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
 		p->o_arg.fh = NFS_FH(d_inode(dentry));
 	}
-	if (attrs != NULL && attrs->ia_valid != 0) {
-		__u32 verf[2];
-
+	if (c != NULL && c->sattr != NULL && c->sattr->ia_valid != 0) {
 		p->o_arg.u.attrs = &p->attrs;
-		memcpy(&p->attrs, attrs, sizeof(p->attrs));
+		memcpy(&p->attrs, c->sattr, sizeof(p->attrs));
 
-		verf[0] = jiffies;
-		verf[1] = current->pid;
-		memcpy(p->o_arg.u.verifier.data, verf,
+		memcpy(p->o_arg.u.verifier.data, c->verf,
 				sizeof(p->o_arg.u.verifier.data));
 	}
 	p->c_arg.fh = &p->o_res.fh;
@@ -1816,7 +1818,7 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 	struct nfs4_opendata *opendata;
 
 	opendata = nfs4_opendata_alloc(ctx->dentry, state->owner, 0, 0,
-			NULL, NULL, claim, GFP_NOFS);
+			NULL, claim, GFP_NOFS);
 	if (opendata == NULL)
 		return ERR_PTR(-ENOMEM);
 	opendata->state = state;
@@ -2757,8 +2759,7 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 static int _nfs4_do_open(struct inode *dir,
 			struct nfs_open_context *ctx,
 			int flags,
-			struct iattr *sattr,
-			struct nfs4_label *label,
+			const struct nfs4_open_createattrs *c,
 			int *opened)
 {
 	struct nfs4_state_owner  *sp;
@@ -2770,6 +2771,8 @@ static int _nfs4_do_open(struct inode *dir,
 	struct nfs4_threshold **ctx_th = &ctx->mdsthreshold;
 	fmode_t fmode = ctx->mode & (FMODE_READ|FMODE_WRITE|FMODE_EXEC);
 	enum open_claim_type4 claim = NFS4_OPEN_CLAIM_NULL;
+	struct iattr *sattr = c->sattr;
+	struct nfs4_label *label = c->label;
 	struct nfs4_label *olabel = NULL;
 	int status;
 
@@ -2788,8 +2791,8 @@ static int _nfs4_do_open(struct inode *dir,
 	status = -ENOMEM;
 	if (d_really_is_positive(dentry))
 		claim = NFS4_OPEN_CLAIM_FH;
-	opendata = nfs4_opendata_alloc(dentry, sp, fmode, flags, sattr,
-			label, claim, GFP_KERNEL);
+	opendata = nfs4_opendata_alloc(dentry, sp, fmode, flags,
+			c, claim, GFP_KERNEL);
 	if (opendata == NULL)
 		goto err_put_state_owner;
 
@@ -2870,10 +2873,18 @@ static struct nfs4_state *nfs4_do_open(struct inode *dir,
 	struct nfs_server *server = NFS_SERVER(dir);
 	struct nfs4_exception exception = { };
 	struct nfs4_state *res;
+	struct nfs4_open_createattrs c = {
+		.label = label,
+		.sattr = sattr,
+		.verf = {
+			[0] = (__u32)jiffies,
+			[1] = (__u32)current->pid,
+		},
+	};
 	int status;
 
 	do {
-		status = _nfs4_do_open(dir, ctx, flags, sattr, label, opened);
+		status = _nfs4_do_open(dir, ctx, flags, &c, opened);
 		res = ctx->state;
 		trace_nfs4_open_file(ctx, flags, status);
 		if (status == 0)
-- 
2.20.1



