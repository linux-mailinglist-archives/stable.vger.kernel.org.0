Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EAB3291E7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhCAUgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236559AbhCAU3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72DC96506D;
        Mon,  1 Mar 2021 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622055;
        bh=AFjDR9NsEE3B3NE7Vo2naZCWv335bcz1jPjhnJOpKoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuSyRQ0xvz/jqigw+MfCa4UbFKEKjvrRLa9R2rB2ichfWY6gA40Ge5DAR0l1A/Irx
         sBsSHI2xte5M+Y9DCHnLbz6ob7h5fBZx2OV3x+VOLrXClMC1KakuRVv6iNII1Kk/t5
         IUNCv8ZtNDUxqhC6kwEz803cWgg4f5vauIt3RD3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 741/775] cifs: check all path components in resolved dfs target
Date:   Mon,  1 Mar 2021 17:15:09 +0100
Message-Id: <20210301161237.950067195@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit ff2c54a04097dee0b8899c485360719844d923f8 upstream.

Handle the case where a resolved target share is like
//server/users/dir, and the user "foo" has no read permission to
access the parent folder "users" but has access to the final path
component "dir".

is_path_remote() already implements that, so call it directly.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   93 +++++++++++++++++++-----------------------------------
 1 file changed, 33 insertions(+), 60 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3280,73 +3280,46 @@ static void put_root_ses(struct cifs_ses
 		cifs_put_smb_ses(ses);
 }
 
-/* Check if a path component is remote and then update @dfs_path accordingly */
-static int check_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
-			     const unsigned int xid, struct TCP_Server_Info *server,
-			     struct cifs_tcon *tcon, char **dfs_path)
+/* Set up next dfs prefix path in @dfs_path */
+static int next_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
+			    const unsigned int xid, struct TCP_Server_Info *server,
+			    struct cifs_tcon *tcon, char **dfs_path)
 {
-	char *path, *s;
-	char sep = CIFS_DIR_SEP(cifs_sb), tmp;
-	char *npath;
-	int rc = 0;
-	int added_treename = tcon->Flags & SMB_SHARE_IS_IN_DFS;
-	int skip = added_treename;
+	char *path, *npath;
+	int added_treename = is_tcon_dfs(tcon);
+	int rc;
 
 	path = cifs_build_path_to_root(ctx, cifs_sb, tcon, added_treename);
 	if (!path)
 		return -ENOMEM;
 
-	/*
-	 * Walk through the path components in @path and check if they're accessible. In case any of
-	 * the components is -EREMOTE, then update @dfs_path with the next DFS referral request path
-	 * (NOT including the remaining components).
-	 */
-	s = path;
-	do {
-		/* skip separators */
-		while (*s && *s == sep)
-			s++;
-		if (!*s)
-			break;
-		/* next separator */
-		while (*s && *s != sep)
-			s++;
-		/*
-		 * if the treename is added, we then have to skip the first
-		 * part within the separators
-		 */
-		if (skip) {
-			skip = 0;
-			continue;
+	rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
+	if (rc == -EREMOTE) {
+		struct smb3_fs_context v = {NULL};
+		/* if @path contains a tree name, skip it in the prefix path */
+		if (added_treename) {
+			rc = smb3_parse_devname(path, &v);
+			if (rc)
+				goto out;
+			npath = build_unc_path_to_root(&v, cifs_sb, true);
+			smb3_cleanup_fs_context_contents(&v);
+		} else {
+			v.UNC = ctx->UNC;
+			v.prepath = path + 1;
+			npath = build_unc_path_to_root(&v, cifs_sb, true);
 		}
-		tmp = *s;
-		*s = 0;
-		rc = server->ops->is_path_accessible(xid, tcon, cifs_sb, path);
-		if (rc && rc == -EREMOTE) {
-			struct smb3_fs_context v = {NULL};
-			/* if @path contains a tree name, skip it in the prefix path */
-			if (added_treename) {
-				rc = smb3_parse_devname(path, &v);
-				if (rc)
-					break;
-				rc = -EREMOTE;
-				npath = build_unc_path_to_root(&v, cifs_sb, true);
-				smb3_cleanup_fs_context_contents(&v);
-			} else {
-				v.UNC = ctx->UNC;
-				v.prepath = path + 1;
-				npath = build_unc_path_to_root(&v, cifs_sb, true);
-			}
-			if (IS_ERR(npath)) {
-				rc = PTR_ERR(npath);
-				break;
-			}
-			kfree(*dfs_path);
-			*dfs_path = npath;
+
+		if (IS_ERR(npath)) {
+			rc = PTR_ERR(npath);
+			goto out;
 		}
-		*s = tmp;
-	} while (rc == 0);
 
+		kfree(*dfs_path);
+		*dfs_path = npath;
+		rc = -EREMOTE;
+	}
+
+out:
 	kfree(path);
 	return rc;
 }
@@ -3432,8 +3405,8 @@ int cifs_mount(struct cifs_sb_info *cifs
 			put_root_ses(root_ses);
 			set_root_ses(cifs_sb, ses, &root_ses);
 		}
-		/* Check for remaining path components and then continue chasing them (-EREMOTE) */
-		rc = check_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
+		/* Get next dfs path and then continue chasing them if -EREMOTE */
+		rc = next_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
 		/* Prevent recursion on broken link referrals */
 		if (rc == -EREMOTE && ++count > MAX_NESTED_LINKS)
 			rc = -ELOOP;


