Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622927F283
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405736AbfHBJru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405732AbfHBJru (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:47:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2B1E216C8;
        Fri,  2 Aug 2019 09:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739269;
        bh=/V/bS1x8kokfHbkBz4bKpmxwmkhk75JhZ17rhkivQTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWDp0+8x0NqzrCfvtsV/gAAAvlwK5PFVlFNzvnaUwQpT6K/9hxszB+mzRAKJHopAw
         4S1uV0xyw5cy3tulMaej+QvHQ/0NUMf7NiPpbf8FRhWAJ5zB2EpXbQK8Yt5FBVUtm+
         yQiubFDfiIkXMKuexXLIj3hNk7xHuBZu1xJ/vOms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 154/223] NFSv4: Fix open create exclusive when the server reboots
Date:   Fri,  2 Aug 2019 11:36:19 +0200
Message-Id: <20190802092248.362399703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
index 6d0d94fc243d..ea29c608be89 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1121,6 +1121,12 @@ struct nfs4_opendata {
 	int cancelled;
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
@@ -1190,8 +1196,7 @@ static void nfs4_init_opendata_res(struct nfs4_opendata *p)
 
 static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 		struct nfs4_state_owner *sp, fmode_t fmode, int flags,
-		const struct iattr *attrs,
-		struct nfs4_label *label,
+		const struct nfs4_open_createattrs *c,
 		enum open_claim_type4 claim,
 		gfp_t gfp_mask)
 {
@@ -1199,6 +1204,7 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	struct inode *dir = d_inode(parent);
 	struct nfs_server *server = NFS_SERVER(dir);
 	struct nfs_seqid *(*alloc_seqid)(struct nfs_seqid_counter *, gfp_t);
+	struct nfs4_label *label = (c != NULL) ? c->label : NULL;
 	struct nfs4_opendata *p;
 
 	p = kzalloc(sizeof(*p), gfp_mask);
@@ -1255,15 +1261,11 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
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
@@ -1814,7 +1816,7 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 	struct nfs4_opendata *opendata;
 
 	opendata = nfs4_opendata_alloc(ctx->dentry, state->owner, 0, 0,
-			NULL, NULL, claim, GFP_NOFS);
+			NULL, claim, GFP_NOFS);
 	if (opendata == NULL)
 		return ERR_PTR(-ENOMEM);
 	opendata->state = state;
@@ -2759,8 +2761,7 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 static int _nfs4_do_open(struct inode *dir,
 			struct nfs_open_context *ctx,
 			int flags,
-			struct iattr *sattr,
-			struct nfs4_label *label,
+			const struct nfs4_open_createattrs *c,
 			int *opened)
 {
 	struct nfs4_state_owner  *sp;
@@ -2772,6 +2773,8 @@ static int _nfs4_do_open(struct inode *dir,
 	struct nfs4_threshold **ctx_th = &ctx->mdsthreshold;
 	fmode_t fmode = ctx->mode & (FMODE_READ|FMODE_WRITE|FMODE_EXEC);
 	enum open_claim_type4 claim = NFS4_OPEN_CLAIM_NULL;
+	struct iattr *sattr = c->sattr;
+	struct nfs4_label *label = c->label;
 	struct nfs4_label *olabel = NULL;
 	int status;
 
@@ -2790,8 +2793,8 @@ static int _nfs4_do_open(struct inode *dir,
 	status = -ENOMEM;
 	if (d_really_is_positive(dentry))
 		claim = NFS4_OPEN_CLAIM_FH;
-	opendata = nfs4_opendata_alloc(dentry, sp, fmode, flags, sattr,
-			label, claim, GFP_KERNEL);
+	opendata = nfs4_opendata_alloc(dentry, sp, fmode, flags,
+			c, claim, GFP_KERNEL);
 	if (opendata == NULL)
 		goto err_put_state_owner;
 
@@ -2872,10 +2875,18 @@ static struct nfs4_state *nfs4_do_open(struct inode *dir,
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



