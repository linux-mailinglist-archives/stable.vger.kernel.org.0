Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14503291E8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbhCAUgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:36:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236436AbhCAU27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:28:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCB4C65209;
        Mon,  1 Mar 2021 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622052;
        bh=wSyk2xL8OWCWaUiU48TAZwMjd0X501c6Jy3Qh2vK8Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KROs6EPQjy7fTuDSLZ06WtPSB9ZAqNCx2ZGTDikQq4azNCIwjcIykSa+7Lale2V4S
         wNjPWw9wmUrMk7gXdj3rRnTRxjstuW8g5ZII+kBST5LsCc3nke8Z2mtkinfWKjzREk
         tXgbw8Ak5jqkM4raNvXa/Oxh1t+2SnaDpVsYb4gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 740/775] cifs: fix DFS failover
Date:   Mon,  1 Mar 2021 17:15:08 +0100
Message-Id: <20210301161237.906386615@linuxfoundation.org>
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

commit 8513222b9ef2709ba40cbda07b55d5fbcfdd4bc7 upstream.

In do_dfs_failover(), the mount_get_conns() function requires the full
fs context in order to get new connection to server, so clone the
original context and change it accordingly when retrying the DFS
targets in the referral.

If failover was successful, then update original context with the new
UNC, prefix path and ip address.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |  123 +++++++++++++++++++++++++-----------------------------
 1 file changed, 59 insertions(+), 64 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3038,96 +3038,91 @@ static int update_vol_info(const struct
 	return 0;
 }
 
-static int setup_dfs_tgt_conn(const char *path, const char *full_path,
-			      const struct dfs_cache_tgt_iterator *tgt_it,
-			      struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx,
-			      unsigned int *xid, struct TCP_Server_Info **server,
-			      struct cifs_ses **ses, struct cifs_tcon **tcon)
-{
-	int rc;
-	struct dfs_info3_param ref = {0};
-	char *mdata = NULL;
-	struct smb3_fs_context fake_ctx = {NULL};
-	char *fake_devname = NULL;
-
-	cifs_dbg(FYI, "%s: dfs path: %s\n", __func__, path);
-
-	rc = dfs_cache_get_tgt_referral(path, tgt_it, &ref);
-	if (rc)
-		return rc;
-
-	mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-					   full_path + 1, &ref,
-					   &fake_devname);
-	free_dfs_info_param(&ref);
-
-	if (IS_ERR(mdata)) {
-		rc = PTR_ERR(mdata);
-		mdata = NULL;
-	} else
-		rc = cifs_setup_volume_info(&fake_ctx, mdata, fake_devname);
-
-	kfree(mdata);
-	kfree(fake_devname);
-
-	if (!rc) {
-		/*
-		 * We use a 'fake_ctx' here because we need pass it down to the
-		 * mount_{get,put} functions to test connection against new DFS
-		 * targets.
-		 */
-		mount_put_conns(cifs_sb, *xid, *server, *ses, *tcon);
-		rc = mount_get_conns(&fake_ctx, cifs_sb, xid, server, ses,
-				     tcon);
-		if (!rc || (*server && *ses)) {
-			/*
-			 * We were able to connect to new target server.
-			 * Update current context with new target server.
-			 */
-			rc = update_vol_info(tgt_it, &fake_ctx, ctx);
-		}
-	}
-	smb3_cleanup_fs_context_contents(&fake_ctx);
-	return rc;
-}
-
 static int do_dfs_failover(const char *path, const char *full_path, struct cifs_sb_info *cifs_sb,
 			   struct smb3_fs_context *ctx, struct cifs_ses *root_ses,
 			   unsigned int *xid, struct TCP_Server_Info **server,
 			   struct cifs_ses **ses, struct cifs_tcon **tcon)
 {
 	int rc;
-	struct dfs_cache_tgt_list tgt_list;
+	struct dfs_cache_tgt_list tgt_list = {0};
 	struct dfs_cache_tgt_iterator *tgt_it = NULL;
+	struct smb3_fs_context tmp_ctx = {NULL};
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
 		return -EOPNOTSUPP;
 
+	cifs_dbg(FYI, "%s: path=%s full_path=%s\n", __func__, path, full_path);
+
 	rc = dfs_cache_noreq_find(path, NULL, &tgt_list);
 	if (rc)
 		return rc;
+	/*
+	 * We use a 'tmp_ctx' here because we need pass it down to the mount_{get,put} functions to
+	 * test connection against new DFS targets.
+	 */
+	rc = smb3_fs_context_dup(&tmp_ctx, ctx);
+	if (rc)
+		goto out;
 
 	for (;;) {
+		struct dfs_info3_param ref = {0};
+		char *fake_devname = NULL, *mdata = NULL;
+
 		/* Get next DFS target server - if any */
 		rc = get_next_dfs_tgt(path, &tgt_list, &tgt_it);
 		if (rc)
 			break;
-		/* Connect to next DFS target */
-		rc = setup_dfs_tgt_conn(path, full_path, tgt_it, cifs_sb, ctx, xid, server, ses,
-					tcon);
-		if (!rc || (*server && *ses))
+
+		rc = dfs_cache_get_tgt_referral(path, tgt_it, &ref);
+		if (rc)
+			break;
+
+		cifs_dbg(FYI, "%s: old ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
+			 tmp_ctx.prepath);
+
+		mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options, full_path + 1, &ref,
+						   &fake_devname);
+		free_dfs_info_param(&ref);
+
+		if (IS_ERR(mdata)) {
+			rc = PTR_ERR(mdata);
+			mdata = NULL;
+		} else
+			rc = cifs_setup_volume_info(&tmp_ctx, mdata, fake_devname);
+
+		kfree(mdata);
+		kfree(fake_devname);
+
+		if (rc)
+			break;
+
+		cifs_dbg(FYI, "%s: new ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
+			 tmp_ctx.prepath);
+
+		mount_put_conns(cifs_sb, *xid, *server, *ses, *tcon);
+		rc = mount_get_conns(&tmp_ctx, cifs_sb, xid, server, ses, tcon);
+		if (!rc || (*server && *ses)) {
+			/*
+			 * We were able to connect to new target server. Update current context with
+			 * new target server.
+			 */
+			rc = update_vol_info(tgt_it, &tmp_ctx, ctx);
 			break;
+		}
 	}
 	if (!rc) {
+		cifs_dbg(FYI, "%s: final ctx: UNC=%s prepath=%s\n", __func__, tmp_ctx.UNC,
+			 tmp_ctx.prepath);
 		/*
-		 * Update DFS target hint in DFS referral cache with the target
-		 * server we successfully reconnected to.
+		 * Update DFS target hint in DFS referral cache with the target server we
+		 * successfully reconnected to.
 		 */
-		rc = dfs_cache_update_tgthint(*xid, root_ses ? root_ses : *ses,
-					      cifs_sb->local_nls,
-					      cifs_remap(cifs_sb), path,
-					      tgt_it);
+		rc = dfs_cache_update_tgthint(*xid, root_ses ? root_ses : *ses, cifs_sb->local_nls,
+					      cifs_remap(cifs_sb), path, tgt_it);
 	}
+
+out:
+	smb3_cleanup_fs_context_contents(&tmp_ctx);
 	dfs_cache_free_tgts(&tgt_list);
 	return rc;
 }


