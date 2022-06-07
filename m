Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDEF540DFE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348270AbiFGSvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354628AbiFGSrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C919C38DBB;
        Tue,  7 Jun 2022 11:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10888617A7;
        Tue,  7 Jun 2022 18:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163CBC34119;
        Tue,  7 Jun 2022 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624958;
        bh=2iCH7DdNKpEIzEXOe8z7RbDzlvDDGaqLVLQDVjbL1dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=go9tQR5TbW2p2U1Xxp//MCp8titlUQH9D3JOfcj1L/N0gRfdQibBnfhZQSxeJKKYH
         YmDEaHRSrmx+TDuZoBug39LrtuH6C44c9PSUk1A9hLyUiY661T3pqDmzFZOGetEXyQ
         lOHLE6sUjE8PqGH0p1awFl4A74nBAACw7Th81XXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/667] NFS: Convert GFP_NOFS to GFP_KERNEL
Date:   Tue,  7 Jun 2022 19:02:59 +0200
Message-Id: <20220607164950.119852406@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit da48f267f90d9dc9f930fd9a67753643657b404f ]

Assume that sections that should not re-enter the filesystem are already
protected with memalloc_nofs_save/restore call, so relax those GFP_NOFS
instances which might be used by other contexts.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c     |  6 +++---
 fs/nfs/nfs4proc.c  | 15 +++++++--------
 fs/nfs/nfs4state.c |  2 +-
 fs/nfs/pnfs.c      |  4 ++--
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index b60c57f6f723..cb407af9e9e9 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1580,7 +1580,7 @@ struct nfs_fattr *nfs_alloc_fattr(void)
 {
 	struct nfs_fattr *fattr;
 
-	fattr = kmalloc(sizeof(*fattr), GFP_NOFS);
+	fattr = kmalloc(sizeof(*fattr), GFP_KERNEL);
 	if (fattr != NULL) {
 		nfs_fattr_init(fattr);
 		fattr->label = NULL;
@@ -1596,7 +1596,7 @@ struct nfs_fattr *nfs_alloc_fattr_with_label(struct nfs_server *server)
 	if (!fattr)
 		return NULL;
 
-	fattr->label = nfs4_label_alloc(server, GFP_NOFS);
+	fattr->label = nfs4_label_alloc(server, GFP_KERNEL);
 	if (IS_ERR(fattr->label)) {
 		kfree(fattr);
 		return NULL;
@@ -1610,7 +1610,7 @@ struct nfs_fh *nfs_alloc_fhandle(void)
 {
 	struct nfs_fh *fh;
 
-	fh = kmalloc(sizeof(struct nfs_fh), GFP_NOFS);
+	fh = kmalloc(sizeof(struct nfs_fh), GFP_KERNEL);
 	if (fh != NULL)
 		fh->size = 0;
 	return fh;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ae6b3600ed11..7ca469833065 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5900,7 +5900,7 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 		buflen = server->rsize;
 
 	npages = DIV_ROUND_UP(buflen, PAGE_SIZE) + 1;
-	pages = kmalloc_array(npages, sizeof(struct page *), GFP_NOFS);
+	pages = kmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		return -ENOMEM;
 
@@ -6621,7 +6621,7 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 	};
 	int status = 0;
 
-	data = kzalloc(sizeof(*data), GFP_NOFS);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -6810,7 +6810,7 @@ static struct nfs4_unlockdata *nfs4_alloc_unlockdata(struct file_lock *fl,
 	struct nfs4_state *state = lsp->ls_state;
 	struct inode *inode = state->inode;
 
-	p = kzalloc(sizeof(*p), GFP_NOFS);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (p == NULL)
 		return NULL;
 	p->arg.fh = NFS_FH(inode);
@@ -7221,8 +7221,7 @@ static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *f
 
 	dprintk("%s: begin!\n", __func__);
 	data = nfs4_alloc_lockdata(fl, nfs_file_open_context(fl->fl_file),
-			fl->fl_u.nfs4_fl.owner,
-			recovery_type == NFS_LOCK_NEW ? GFP_KERNEL : GFP_NOFS);
+				   fl->fl_u.nfs4_fl.owner, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	if (IS_SETLKW(cmd))
@@ -7645,7 +7644,7 @@ nfs4_release_lockowner(struct nfs_server *server, struct nfs4_lock_state *lsp)
 	if (server->nfs_client->cl_mvops->minor_version != 0)
 		return;
 
-	data = kmalloc(sizeof(*data), GFP_NOFS);
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return;
 	data->lsp = lsp;
@@ -9322,7 +9321,7 @@ static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp,
 		goto out_err;
 
 	ret = ERR_PTR(-ENOMEM);
-	calldata = kzalloc(sizeof(*calldata), GFP_NOFS);
+	calldata = kzalloc(sizeof(*calldata), GFP_KERNEL);
 	if (calldata == NULL)
 		goto out_put_clp;
 	nfs4_init_sequence(&calldata->args, &calldata->res, 0, is_privileged);
@@ -10266,7 +10265,7 @@ static int nfs41_free_stateid(struct nfs_server *server,
 		&task_setup.rpc_client, &msg);
 
 	dprintk("NFS call  free_stateid %p\n", stateid);
-	data = kmalloc(sizeof(*data), GFP_NOFS);
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 	data->server = server;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 57ea63e2cdb4..83c88b54d712 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -821,7 +821,7 @@ static void __nfs4_close(struct nfs4_state *state,
 
 void nfs4_close_state(struct nfs4_state *state, fmode_t fmode)
 {
-	__nfs4_close(state, fmode, GFP_NOFS, 0);
+	__nfs4_close(state, fmode, GFP_KERNEL, 0);
 }
 
 void nfs4_close_sync(struct nfs4_state *state, fmode_t fmode)
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 9203a17b3f09..1b4dd8b828de 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1244,7 +1244,7 @@ pnfs_send_layoutreturn(struct pnfs_layout_hdr *lo,
 	int status = 0;
 
 	*pcred = NULL;
-	lrp = kzalloc(sizeof(*lrp), GFP_NOFS);
+	lrp = kzalloc(sizeof(*lrp), GFP_KERNEL);
 	if (unlikely(lrp == NULL)) {
 		status = -ENOMEM;
 		spin_lock(&ino->i_lock);
@@ -3263,7 +3263,7 @@ struct nfs4_threshold *pnfs_mdsthreshold_alloc(void)
 {
 	struct nfs4_threshold *thp;
 
-	thp = kzalloc(sizeof(*thp), GFP_NOFS);
+	thp = kzalloc(sizeof(*thp), GFP_KERNEL);
 	if (!thp) {
 		dprintk("%s mdsthreshold allocation failed\n", __func__);
 		return NULL;
-- 
2.35.1



