Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757A93CE366
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243179AbhGSPhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347718AbhGSPfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E8696148E;
        Mon, 19 Jul 2021 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711175;
        bh=Q2CqGbyu8ayDO0fwGEQmAL1OPjcwtTpHFnL0yPyIq2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikAAXoWiSQgwS9ojFdCt3nLty7YncT77Z6lGIwQy93xZU2bLMnyiesQ48J3jWPeJ9
         FasSOJcLZ7Cuxd2LRYDGpkce+1+IDOhQYR/MQWkXYNp22Qy0wx0IRYvdoUoJQwv5D7
         NlowBTq2rwBl4qHqExm8OLTihnEjXG7v33Y+FBvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 238/351] nfs: update has_sec_mnt_opts after cloning lsm options from parent
Date:   Mon, 19 Jul 2021 16:53:04 +0200
Message-Id: <20210719144952.817170771@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit eae00c5d6e48ccb2d78ae5873743d7d1a572951b ]

After calling security_sb_clone_mnt_opts() in nfs_get_root(), it's
necessary to copy the value of has_sec_mnt_opts from the cloned
super_block's nfs_server.  Otherwise, calls to nfs_compare_super()
using this super_block may not return the correct result, leading to
mount failures.

For example, mounting an nfs server with the following in /etc/exports:
/export *(rw,insecure,crossmnt,no_root_squash,security_label)
and having /export/scratch on a separate block device.

mount -o v4.2,context=system_u:object_r:root_t:s0 server:/export/test /mnt/test
mount -o v4.2,context=system_u:object_r:swapfile_t:s0 server:/export/scratch /mnt/scratch

The second mount would fail with "mount.nfs: /mnt/scratch is busy or
already mounted or sharecache fail" and "SELinux: mount invalid.  Same
superblock, different security settings for..." would appear in the
syslog.

Also while we're in there, replace several instances of "NFS_SB(s)"
with "server", which was already declared at the top of the
nfs_get_root().

Fixes: ec1ade6a0448 ("nfs: account for selinux security context when deciding to share superblock")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/getroot.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index aaeeb4659bff..59355c106ece 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -67,7 +67,7 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
 int nfs_get_root(struct super_block *s, struct fs_context *fc)
 {
 	struct nfs_fs_context *ctx = nfs_fc2context(fc);
-	struct nfs_server *server = NFS_SB(s);
+	struct nfs_server *server = NFS_SB(s), *clone_server;
 	struct nfs_fsinfo fsinfo;
 	struct dentry *root;
 	struct inode *inode;
@@ -127,7 +127,7 @@ int nfs_get_root(struct super_block *s, struct fs_context *fc)
 	}
 	spin_unlock(&root->d_lock);
 	fc->root = root;
-	if (NFS_SB(s)->caps & NFS_CAP_SECURITY_LABEL)
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
 		kflags |= SECURITY_LSM_NATIVE_LABELS;
 	if (ctx->clone_data.sb) {
 		if (d_inode(fc->root)->i_fop != &nfs_dir_operations) {
@@ -137,15 +137,19 @@ int nfs_get_root(struct super_block *s, struct fs_context *fc)
 		/* clone lsm security options from the parent to the new sb */
 		error = security_sb_clone_mnt_opts(ctx->clone_data.sb,
 						   s, kflags, &kflags_out);
+		if (error)
+			goto error_splat_root;
+		clone_server = NFS_SB(ctx->clone_data.sb);
+		server->has_sec_mnt_opts = clone_server->has_sec_mnt_opts;
 	} else {
 		error = security_sb_set_mnt_opts(s, fc->security,
 							kflags, &kflags_out);
 	}
 	if (error)
 		goto error_splat_root;
-	if (NFS_SB(s)->caps & NFS_CAP_SECURITY_LABEL &&
+	if (server->caps & NFS_CAP_SECURITY_LABEL &&
 		!(kflags_out & SECURITY_LSM_NATIVE_LABELS))
-		NFS_SB(s)->caps &= ~NFS_CAP_SECURITY_LABEL;
+		server->caps &= ~NFS_CAP_SECURITY_LABEL;
 
 	nfs_setsecurity(inode, fsinfo.fattr, fsinfo.fattr->label);
 	error = 0;
-- 
2.30.2



