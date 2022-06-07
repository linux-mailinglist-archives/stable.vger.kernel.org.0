Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC115424ED
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiFHBzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358720AbiFHBtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 21:49:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E8339B8D;
        Tue,  7 Jun 2022 12:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41594B8237B;
        Tue,  7 Jun 2022 19:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4F4C385A2;
        Tue,  7 Jun 2022 19:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629483;
        bh=Csp2I1zQnXxibFFydZTSP8SxG7Y68Iy4CSd19K5lV9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LoK69xUfE4IYIBhrRu7k1eyUPgj1bsduezHEqG02qAHue1QoyZ/c5Fid0DtOxF7QN
         5bw4LdVserZb7KmlneRo1iyaxNTOBl4rgFa47j2/sWAaJDfkVh++ePiJwc43iF2jZH
         S1AnoSvdWxX1XlgYrKYog8u+nuD7uMdwNjl7jwjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trond Myklebust <trondmy@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 706/879] NFSv4: Fix free of uninitialized nfs4_label on referral lookup.
Date:   Tue,  7 Jun 2022 19:03:44 +0200
Message-Id: <20220607165023.339266243@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit c3ed222745d9ad7b69299b349a64ba533c64a34f ]

Send along the already-allocated fattr along with nfs4_fs_locations, and
drop the memcpy of fattr.  We end up growing two more allocations, but this
fixes up a crash as:

PID: 790    TASK: ffff88811b43c000  CPU: 0   COMMAND: "ls"
 #0 [ffffc90000857920] panic at ffffffff81b9bfde
 #1 [ffffc900008579c0] do_trap at ffffffff81023a9b
 #2 [ffffc90000857a10] do_error_trap at ffffffff81023b78
 #3 [ffffc90000857a58] exc_stack_segment at ffffffff81be1f45
 #4 [ffffc90000857a80] asm_exc_stack_segment at ffffffff81c009de
 #5 [ffffc90000857b08] nfs_lookup at ffffffffa0302322 [nfs]
 #6 [ffffc90000857b70] __lookup_slow at ffffffff813a4a5f
 #7 [ffffc90000857c60] walk_component at ffffffff813a86c4
 #8 [ffffc90000857cb8] path_lookupat at ffffffff813a9553
 #9 [ffffc90000857cf0] filename_lookup at ffffffff813ab86b

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 9558a007dbc3 ("NFS: Remove the label from the nfs4_lookup_res struct")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4namespace.c  |  9 +++++++--
 fs/nfs/nfs4proc.c       | 15 +++++++--------
 fs/nfs/nfs4state.c      |  9 ++++++++-
 fs/nfs/nfs4xdr.c        |  4 ++--
 include/linux/nfs_xdr.h |  2 +-
 5 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 3680c8da510c..f2dbf904c598 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -417,6 +417,9 @@ static int nfs_do_refmount(struct fs_context *fc, struct rpc_clnt *client)
 	fs_locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
 	if (!fs_locations)
 		goto out_free;
+	fs_locations->fattr = nfs_alloc_fattr();
+	if (!fs_locations->fattr)
+		goto out_free_2;
 
 	/* Get locations */
 	dentry = ctx->clone_data.dentry;
@@ -427,14 +430,16 @@ static int nfs_do_refmount(struct fs_context *fc, struct rpc_clnt *client)
 	err = nfs4_proc_fs_locations(client, d_inode(parent), &dentry->d_name, fs_locations, page);
 	dput(parent);
 	if (err != 0)
-		goto out_free_2;
+		goto out_free_3;
 
 	err = -ENOENT;
 	if (fs_locations->nlocations <= 0 ||
 	    fs_locations->fs_path.ncomponents <= 0)
-		goto out_free_2;
+		goto out_free_3;
 
 	err = nfs_follow_referral(fc, fs_locations);
+out_free_3:
+	kfree(fs_locations->fattr);
 out_free_2:
 	kfree(fs_locations);
 out_free:
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a79f66432bd3..0600f85b6016 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4243,6 +4243,8 @@ static int nfs4_get_referral(struct rpc_clnt *client, struct inode *dir,
 	if (locations == NULL)
 		goto out;
 
+	locations->fattr = fattr;
+
 	status = nfs4_proc_fs_locations(client, dir, name, locations, page);
 	if (status != 0)
 		goto out;
@@ -4252,17 +4254,14 @@ static int nfs4_get_referral(struct rpc_clnt *client, struct inode *dir,
 	 * referral.  Cause us to drop into the exception handler, which
 	 * will kick off migration recovery.
 	 */
-	if (nfs_fsid_equal(&NFS_SERVER(dir)->fsid, &locations->fattr.fsid)) {
+	if (nfs_fsid_equal(&NFS_SERVER(dir)->fsid, &fattr->fsid)) {
 		dprintk("%s: server did not return a different fsid for"
 			" a referral at %s\n", __func__, name->name);
 		status = -NFS4ERR_MOVED;
 		goto out;
 	}
 	/* Fixup attributes for the nfs_lookup() call to nfs_fhget() */
-	nfs_fixup_referral_attributes(&locations->fattr);
-
-	/* replace the lookup nfs_fattr with the locations nfs_fattr */
-	memcpy(fattr, &locations->fattr, sizeof(struct nfs_fattr));
+	nfs_fixup_referral_attributes(fattr);
 	memset(fhandle, 0, sizeof(struct nfs_fh));
 out:
 	if (page)
@@ -7902,7 +7901,7 @@ static int _nfs4_proc_fs_locations(struct rpc_clnt *client, struct inode *dir,
 	else
 		bitmask[1] &= ~FATTR4_WORD1_MOUNTED_ON_FILEID;
 
-	nfs_fattr_init(&fs_locations->fattr);
+	nfs_fattr_init(fs_locations->fattr);
 	fs_locations->server = server;
 	fs_locations->nlocations = 0;
 	status = nfs4_call_sync(client, server, &msg, &args.seq_args, &res.seq_res, 0);
@@ -7967,7 +7966,7 @@ static int _nfs40_proc_get_locations(struct nfs_server *server,
 	unsigned long now = jiffies;
 	int status;
 
-	nfs_fattr_init(&locations->fattr);
+	nfs_fattr_init(locations->fattr);
 	locations->server = server;
 	locations->nlocations = 0;
 
@@ -8032,7 +8031,7 @@ static int _nfs41_proc_get_locations(struct nfs_server *server,
 	};
 	int status;
 
-	nfs_fattr_init(&locations->fattr);
+	nfs_fattr_init(locations->fattr);
 	locations->server = server;
 	locations->nlocations = 0;
 
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 9e1c987c81e7..9656d40bb488 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2106,6 +2106,11 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 		dprintk("<-- %s: no memory\n", __func__);
 		goto out;
 	}
+	locations->fattr = nfs_alloc_fattr();
+	if (locations->fattr == NULL) {
+		dprintk("<-- %s: no memory\n", __func__);
+		goto out;
+	}
 
 	inode = d_inode(server->super->s_root);
 	result = nfs4_proc_get_locations(server, NFS_FH(inode), locations,
@@ -2120,7 +2125,7 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 	if (!locations->nlocations)
 		goto out;
 
-	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
+	if (!(locations->fattr->valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
 		goto out;
@@ -2145,6 +2150,8 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 out:
 	if (page != NULL)
 		__free_page(page);
+	if (locations != NULL)
+		kfree(locations->fattr);
 	kfree(locations);
 	if (result) {
 		pr_err("NFS: migration recovery failed (server %s)\n",
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 86a5f6516928..5d822594336d 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -7051,7 +7051,7 @@ static int nfs4_xdr_dec_fs_locations(struct rpc_rqst *req,
 	if (res->migration) {
 		xdr_enter_page(xdr, PAGE_SIZE);
 		status = decode_getfattr_generic(xdr,
-					&res->fs_locations->fattr,
+					res->fs_locations->fattr,
 					 NULL, res->fs_locations,
 					 res->fs_locations->server);
 		if (status)
@@ -7064,7 +7064,7 @@ static int nfs4_xdr_dec_fs_locations(struct rpc_rqst *req,
 			goto out;
 		xdr_enter_page(xdr, PAGE_SIZE);
 		status = decode_getfattr_generic(xdr,
-					&res->fs_locations->fattr,
+					res->fs_locations->fattr,
 					 NULL, res->fs_locations,
 					 res->fs_locations->server);
 	}
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 2863e5a69c6a..20e97329fe46 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1212,7 +1212,7 @@ struct nfs4_fs_location {
 
 #define NFS4_FS_LOCATIONS_MAXENTRIES 10
 struct nfs4_fs_locations {
-	struct nfs_fattr fattr;
+	struct nfs_fattr *fattr;
 	const struct nfs_server *server;
 	struct nfs4_pathname fs_path;
 	int nlocations;
-- 
2.35.1



