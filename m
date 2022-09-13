Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD72A5B7143
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiIMOgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiIMOfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608BB6B140;
        Tue, 13 Sep 2022 07:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9776EB80FA6;
        Tue, 13 Sep 2022 14:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6910C433D6;
        Tue, 13 Sep 2022 14:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078753;
        bh=Quzx7L/ufsihBUzi7lZPwtxQLazsfg/Cdrcgc/tZ68I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MO4cKYQE1Uehs5f3MYjnYrMG9lIuOoD+NwrIqdMvEertyNlecL1ozolp0gFN+meq
         jkRwm5UKFnODekQTCGFUwpBArYM5KJPsBl6T/R+5EYiIX7LPt/j07qa/q2CKokYRxt
         qhOPwJtwOCxuRw4TVxQQJ4gcSNMqV6hdub2MTCoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/121] NFS: Save some space in the inode
Date:   Tue, 13 Sep 2022 16:03:55 +0200
Message-Id: <20220913140359.260213951@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e591b298d7ecb851e200f65946e3d53fe78a3c4f ]

Save some space in the nfs_inode by setting up an anonymous union with
the fields that are peculiar to a specific type of filesystem object.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c         | 26 ++++++++++++++++++--------
 include/linux/nfs_fs.h | 42 ++++++++++++++++++++++++------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index cb407af9e9e92..dc057ab6b30d1 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -431,6 +431,22 @@ nfs_ilookup(struct super_block *sb, struct nfs_fattr *fattr, struct nfs_fh *fh)
 	return inode;
 }
 
+static void nfs_inode_init_regular(struct nfs_inode *nfsi)
+{
+	atomic_long_set(&nfsi->nrequests, 0);
+	INIT_LIST_HEAD(&nfsi->commit_info.list);
+	atomic_long_set(&nfsi->commit_info.ncommit, 0);
+	atomic_set(&nfsi->commit_info.rpcs_out, 0);
+	mutex_init(&nfsi->commit_mutex);
+}
+
+static void nfs_inode_init_dir(struct nfs_inode *nfsi)
+{
+	nfsi->cache_change_attribute = 0;
+	memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
+	init_rwsem(&nfsi->rmdir_sem);
+}
+
 /*
  * This is our front-end to iget that looks up inodes by file handle
  * instead of inode number.
@@ -485,10 +501,12 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		if (S_ISREG(inode->i_mode)) {
 			inode->i_fop = NFS_SB(sb)->nfs_client->rpc_ops->file_ops;
 			inode->i_data.a_ops = &nfs_file_aops;
+			nfs_inode_init_regular(nfsi);
 		} else if (S_ISDIR(inode->i_mode)) {
 			inode->i_op = NFS_SB(sb)->nfs_client->rpc_ops->dir_inode_ops;
 			inode->i_fop = &nfs_dir_operations;
 			inode->i_data.a_ops = &nfs_dir_aops;
+			nfs_inode_init_dir(nfsi);
 			/* Deal with crossing mountpoints */
 			if (fattr->valid & NFS_ATTR_FATTR_MOUNTPOINT ||
 					fattr->valid & NFS_ATTR_FATTR_V4_REFERRAL) {
@@ -514,7 +532,6 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		inode->i_uid = make_kuid(&init_user_ns, -2);
 		inode->i_gid = make_kgid(&init_user_ns, -2);
 		inode->i_blocks = 0;
-		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
 		nfsi->write_io = 0;
 		nfsi->read_io = 0;
 
@@ -2282,14 +2299,7 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&nfsi->open_files);
 	INIT_LIST_HEAD(&nfsi->access_cache_entry_lru);
 	INIT_LIST_HEAD(&nfsi->access_cache_inode_lru);
-	INIT_LIST_HEAD(&nfsi->commit_info.list);
-	atomic_long_set(&nfsi->nrequests, 0);
-	atomic_long_set(&nfsi->commit_info.ncommit, 0);
-	atomic_set(&nfsi->commit_info.rpcs_out, 0);
-	init_rwsem(&nfsi->rmdir_sem);
-	mutex_init(&nfsi->commit_mutex);
 	nfs4_init_once(nfsi);
-	nfsi->cache_change_attribute = 0;
 }
 
 static int __init nfs_init_inodecache(void)
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index be8625d8a10a7..d0855352cd6fc 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -155,33 +155,39 @@ struct nfs_inode {
 	unsigned long		attrtimeo_timestamp;
 
 	unsigned long		attr_gencount;
-	/* "Generation counter" for the attribute cache. This is
-	 * bumped whenever we update the metadata on the
-	 * server.
-	 */
-	unsigned long		cache_change_attribute;
 
 	struct rb_root		access_cache;
 	struct list_head	access_cache_entry_lru;
 	struct list_head	access_cache_inode_lru;
 
-	/*
-	 * This is the cookie verifier used for NFSv3 readdir
-	 * operations
-	 */
-	__be32			cookieverf[NFS_DIR_VERIFIER_SIZE];
-
-	atomic_long_t		nrequests;
-	struct nfs_mds_commit_info commit_info;
+	union {
+		/* Directory */
+		struct {
+			/* "Generation counter" for the attribute cache.
+			 * This is bumped whenever we update the metadata
+			 * on the server.
+			 */
+			unsigned long	cache_change_attribute;
+			/*
+			 * This is the cookie verifier used for NFSv3 readdir
+			 * operations
+			 */
+			__be32		cookieverf[NFS_DIR_VERIFIER_SIZE];
+			/* Readers: in-flight sillydelete RPC calls */
+			/* Writers: rmdir */
+			struct rw_semaphore	rmdir_sem;
+		};
+		/* Regular file */
+		struct {
+			atomic_long_t	nrequests;
+			struct nfs_mds_commit_info commit_info;
+			struct mutex	commit_mutex;
+		};
+	};
 
 	/* Open contexts for shared mmap writes */
 	struct list_head	open_files;
 
-	/* Readers: in-flight sillydelete RPC calls */
-	/* Writers: rmdir */
-	struct rw_semaphore	rmdir_sem;
-	struct mutex		commit_mutex;
-
 #if IS_ENABLED(CONFIG_NFS_V4)
 	struct nfs4_cached_acl	*nfs4_acl;
         /* NFSv4 state */
-- 
2.35.1



