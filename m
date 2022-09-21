Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481365C021C
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiIUPsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiIUPrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:47:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ABE80F5C;
        Wed, 21 Sep 2022 08:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F130B830A3;
        Wed, 21 Sep 2022 15:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4461FC433B5;
        Wed, 21 Sep 2022 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775236;
        bh=yNHMkSLrb9vN/yMd9ISBZTSflWXS1fggNsB3gjeKxJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDwao/qTEIkc3ToyMIcRjINEjHTLFBN6iUFihHBOEyTIpRkO/aEv7c9if9AWIhOM4
         uyogsabjUCdJK/54HO5IYIi3acAREoiUMqYeaANTYM0hmQ02u4k0YySHHQKAahE1qK
         piHxqfFmueJU4fVkMzp7Xb85/NdBmefJRPzK0J4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Cui <cuiyue-fnst@fujitsu.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 09/38] NFSv4.2: Update mode bits after ALLOCATE and DEALLOCATE
Date:   Wed, 21 Sep 2022 17:45:53 +0200
Message-Id: <20220921153646.597985540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit d7a5118635e725d195843bda80cc5c964d93ef31 ]

The fallocate call invalidates suid and sgid bits as part of normal
operation. We need to mark the mode bits as invalid when using fallocate
with an suid so these will be updated the next time the user looks at them.

This fixes xfstests generic/683 and generic/684.

Reported-by: Yue Cui <cuiyue-fnst@fujitsu.com>
Fixes: 913eca1aea87 ("NFS: Fallocate should use the nfs4_fattr_bitmap")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h  | 25 +++++++++++++++++++++++++
 fs/nfs/nfs42proc.c |  9 +++++++--
 fs/nfs/write.c     | 25 -------------------------
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 8f8cd6e2d4db..597e3ce3f148 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -604,6 +604,31 @@ static inline gfp_t nfs_io_gfp_mask(void)
 	return GFP_KERNEL;
 }
 
+/*
+ * Special version of should_remove_suid() that ignores capabilities.
+ */
+static inline int nfs_should_remove_suid(const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+
 /* unlink.c */
 extern struct rpc_task *
 nfs_async_rename(struct inode *old_dir, struct inode *new_dir,
diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 068c45b3bc1a..6dab9e408372 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -78,10 +78,15 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 
 	status = nfs4_call_sync(server->client, server, msg,
 				&args.seq_args, &res.seq_res, 0);
-	if (status == 0)
+	if (status == 0) {
+		if (nfs_should_remove_suid(inode)) {
+			spin_lock(&inode->i_lock);
+			nfs_set_cache_invalid(inode, NFS_INO_INVALID_MODE);
+			spin_unlock(&inode->i_lock);
+		}
 		status = nfs_post_op_update_inode_force_wcc(inode,
 							    res.falloc_fattr);
-
+	}
 	if (msg->rpc_proc == &nfs4_procedures[NFSPROC4_CLNT_ALLOCATE])
 		trace_nfs4_fallocate(inode, &args, status);
 	else
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 5d7e1c206184..4212473c69ee 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1497,31 +1497,6 @@ void nfs_commit_prepare(struct rpc_task *task, void *calldata)
 	NFS_PROTO(data->inode)->commit_rpc_prepare(task, data);
 }
 
-/*
- * Special version of should_remove_suid() that ignores capabilities.
- */
-static int nfs_should_remove_suid(const struct inode *inode)
-{
-	umode_t mode = inode->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-
 static void nfs_writeback_check_extend(struct nfs_pgio_header *hdr,
 		struct nfs_fattr *fattr)
 {
-- 
2.35.1



