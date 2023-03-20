Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24636C1994
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjCTPfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbjCTPem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1F92E814
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFA2E614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7F0C433D2;
        Mon, 20 Mar 2023 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326044;
        bh=R169yCGc1/xa7EkigUBiCu0PO0c+VH5hmyqfigFUq0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAhfuWOhSfaq3Wo2SQHo6kpoyUIvpMvr/KGPASV/HZ4Zv9P8cVaYh1PmSWCklFcjb
         3tT2N30t9UyPuYSmYRwHc/8W4bEZ8qi1gMVx3p5jUPnZ/lzOvAYoCt5KekWHH1V+1+
         XvKbvhvWlhk79NmMsnHGkWiGMjtixKjuKMTxqgYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 149/211] cifs: set DFS root session in cifs_get_smb_ses()
Date:   Mon, 20 Mar 2023 15:54:44 +0100
Message-Id: <20230320145519.675529152@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit b56bce502f55505a97e381d546ee881928183126 upstream.

Set the DFS root session pointer earlier when creating a new SMB
session to prevent racing with smb2_reconnect(), cifs_reconnect_tcon()
and DFS cache refresher.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_dfs_ref.c |    1 +
 fs/cifs/cifsglob.h     |    1 -
 fs/cifs/connect.c      |    1 +
 fs/cifs/dfs.c          |   19 ++++++++-----------
 fs/cifs/dfs.h          |    3 ++-
 fs/cifs/fs_context.h   |    1 +
 6 files changed, 13 insertions(+), 13 deletions(-)

--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -179,6 +179,7 @@ static struct vfsmount *cifs_dfs_do_auto
 	tmp.source = full_path;
 	tmp.leaf_fullpath = NULL;
 	tmp.UNC = tmp.prepath = NULL;
+	tmp.dfs_root_ses = NULL;
 
 	rc = smb3_fs_context_dup(ctx, &tmp);
 	if (rc) {
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1767,7 +1767,6 @@ struct cifs_mount_ctx {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	struct cifs_ses *root_ses;
 	uuid_t mount_id;
 	char *origin_fullpath, *leaf_fullpath;
 };
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2278,6 +2278,7 @@ cifs_get_smb_ses(struct TCP_Server_Info
 	 * need to lock before changing something in the session.
 	 */
 	spin_lock(&cifs_tcp_ses_lock);
+	ses->dfs_root_ses = ctx->dfs_root_ses;
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -95,25 +95,22 @@ static int get_session(struct cifs_mount
 	ctx->leaf_fullpath = (char *)full_path;
 	rc = cifs_mount_get_session(mnt_ctx);
 	ctx->leaf_fullpath = NULL;
-	if (!rc) {
-		struct cifs_ses *ses = mnt_ctx->ses;
 
-		mutex_lock(&ses->session_mutex);
-		ses->dfs_root_ses = mnt_ctx->root_ses;
-		mutex_unlock(&ses->session_mutex);
-	}
 	return rc;
 }
 
 static void set_root_ses(struct cifs_mount_ctx *mnt_ctx)
 {
-	if (mnt_ctx->ses) {
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	struct cifs_ses *ses = mnt_ctx->ses;
+
+	if (ses) {
 		spin_lock(&cifs_tcp_ses_lock);
-		mnt_ctx->ses->ses_count++;
+		ses->ses_count++;
 		spin_unlock(&cifs_tcp_ses_lock);
-		dfs_cache_add_refsrv_session(&mnt_ctx->mount_id, mnt_ctx->ses);
+		dfs_cache_add_refsrv_session(&mnt_ctx->mount_id, ses);
 	}
-	mnt_ctx->root_ses = mnt_ctx->ses;
+	ctx->dfs_root_ses = mnt_ctx->ses;
 }
 
 static int get_dfs_conn(struct cifs_mount_ctx *mnt_ctx, const char *ref_path, const char *full_path,
@@ -260,7 +257,7 @@ int dfs_mount_share(struct cifs_mount_ct
 	rc = get_session(mnt_ctx, NULL);
 	if (rc)
 		return rc;
-	mnt_ctx->root_ses = mnt_ctx->ses;
+	ctx->dfs_root_ses = mnt_ctx->ses;
 	/*
 	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
 	 * try to get an DFS referral (even cached) to determine whether it is an DFS mount.
--- a/fs/cifs/dfs.h
+++ b/fs/cifs/dfs.h
@@ -22,9 +22,10 @@ static inline char *dfs_get_path(struct
 static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *path,
 				   struct dfs_info3_param *ref, struct dfs_cache_tgt_list *tl)
 {
+	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 
-	return dfs_cache_find(mnt_ctx->xid, mnt_ctx->root_ses, cifs_sb->local_nls,
+	return dfs_cache_find(mnt_ctx->xid, ctx->dfs_root_ses, cifs_sb->local_nls,
 			      cifs_remap(cifs_sb), path, ref, tl);
 }
 
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -265,6 +265,7 @@ struct smb3_fs_context {
 	bool rootfs:1; /* if it's a SMB root file system */
 	bool witness:1; /* use witness protocol */
 	char *leaf_fullpath;
+	struct cifs_ses *dfs_root_ses;
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];


