Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EAA6AEC08
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjCGRvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjCGRvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:51:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF4FA42F1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:45:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F5DB818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A7BC433EF;
        Tue,  7 Mar 2023 17:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211150;
        bh=sCrqRIZlm/aXYMX3LXqqHc78MmZaCV72Cq9hgyWE0dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Blds3VEBwKzESfFufuZvvxBUbxErCDJL1W/bP7W8ZkW3KF8zPO/mzQKJRU5ZKVoCM
         Lphg2O78XdRqBOADSv2/QQdY4sPdyHYIZI/O+aAbf3xL6zcOE2nY4b8owibHeBCHrM
         N0JnP2Bq1paLbooLFxjHceb+syGhe+tF6R9AnvEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0770/1001] cifs: improve checking of DFS links over STATUS_OBJECT_NAME_INVALID
Date:   Tue,  7 Mar 2023 17:59:02 +0100
Message-Id: <20230307170055.186067812@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@manguebit.com>

commit b9ee2e307c6b06384b6f9e393a9b8e048e8fc277 upstream.

Do not map STATUS_OBJECT_NAME_INVALID to -EREMOTE under non-DFS
shares, or 'nodfs' mounts or CONFIG_CIFS_DFS_UPCALL=n builds.
Otherwise, in the slow path, get a referral to figure out whether it
is an actual DFS link.

This could be simply reproduced under a non-DFS share by running the
following

  $ mount.cifs //srv/share /mnt -o ...
  $ cat /mnt/$(printf '\U110000')
  cat: '/mnt/'$'\364\220\200\200': Object is remote

Fixes: c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
CC: stable@vger.kernel.org # 6.2
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsproto.h |   20 +++++++++++----
 fs/cifs/misc.c      |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2inode.c |   21 ++++++++--------
 fs/cifs/smb2ops.c   |   23 ++++++++++-------
 4 files changed, 106 insertions(+), 25 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -670,11 +670,21 @@ static inline int get_dfs_path(const uns
 int match_target_ip(struct TCP_Server_Info *server,
 		    const char *share, size_t share_len,
 		    bool *result);
-
-int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
-				       struct cifs_tcon *tcon,
-				       struct cifs_sb_info *cifs_sb,
-				       const char *dfs_link_path);
+int cifs_inval_name_dfs_link_error(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   const char *full_path,
+				   bool *islink);
+#else
+static inline int cifs_inval_name_dfs_link_error(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   const char *full_path,
+				   bool *islink)
+{
+	*islink = false;
+	return 0;
+}
 #endif
 
 static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -21,6 +21,7 @@
 #include "cifsfs.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dns_resolve.h"
+#include "dfs_cache.h"
 #endif
 #include "fs_context.h"
 #include "cached_dir.h"
@@ -1300,4 +1301,70 @@ int cifs_update_super_prepath(struct cif
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	return 0;
 }
+
+/*
+ * Handle weird Windows SMB server behaviour. It responds with
+ * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request for
+ * "\<server>\<dfsname>\<linkpath>" DFS reference, where <dfsname> contains
+ * non-ASCII unicode symbols.
+ */
+int cifs_inval_name_dfs_link_error(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   const char *full_path,
+				   bool *islink)
+{
+	struct cifs_ses *ses = tcon->ses;
+	size_t len;
+	char *path;
+	char *ref_path;
+
+	*islink = false;
+
+	/*
+	 * Fast path - skip check when @full_path doesn't have a prefix path to
+	 * look up or tcon is not DFS.
+	 */
+	if (strlen(full_path) < 2 || !cifs_sb ||
+	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    !is_tcon_dfs(tcon) || !ses->server->origin_fullpath)
+		return 0;
+
+	/*
+	 * Slow path - tcon is DFS and @full_path has prefix path, so attempt
+	 * to get a referral to figure out whether it is an DFS link.
+	 */
+	len = strnlen(tcon->tree_name, MAX_TREE_SIZE + 1) + strlen(full_path) + 1;
+	path = kmalloc(len, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	scnprintf(path, len, "%s%s", tcon->tree_name, full_path);
+	ref_path = dfs_cache_canonical_path(path + 1, cifs_sb->local_nls,
+					    cifs_remap(cifs_sb));
+	kfree(path);
+
+	if (IS_ERR(ref_path)) {
+		if (PTR_ERR(ref_path) != -EINVAL)
+			return PTR_ERR(ref_path);
+	} else {
+		struct dfs_info3_param *refs = NULL;
+		int num_refs = 0;
+
+		/*
+		 * XXX: we are not using dfs_cache_find() here because we might
+		 * end filling all the DFS cache and thus potentially
+		 * removing cached DFS targets that the client would eventually
+		 * need during failover.
+		 */
+		if (ses->server->ops->get_dfs_refer &&
+		    !ses->server->ops->get_dfs_refer(xid, ses, ref_path, &refs,
+						     &num_refs, cifs_sb->local_nls,
+						     cifs_remap(cifs_sb)))
+			*islink = refs[0].server_type == DFS_TYPE_LINK;
+		free_dfs_info_array(refs, num_refs);
+		kfree(ref_path);
+	}
+	return 0;
+}
 #endif
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -526,12 +526,13 @@ int smb2_query_path_info(const unsigned
 			 struct cifs_sb_info *cifs_sb, const char *full_path,
 			 struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse)
 {
-	int rc;
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
 	struct cached_fid *cfid = NULL;
 	struct kvec err_iov[3] = {};
 	int err_buftype[3] = {};
+	bool islink;
+	int rc, rc2;
 
 	*adjust_tz = false;
 	*reparse = false;
@@ -579,15 +580,15 @@ int smb2_query_path_info(const unsigned
 					      SMB2_OP_QUERY_INFO, cfile, NULL, NULL,
 					      NULL, NULL);
 			goto out;
-		} else if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
-			   hdr->Status == STATUS_OBJECT_NAME_INVALID) {
-			/*
-			 * Handle weird Windows SMB server behaviour. It responds with
-			 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
-			 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
-			 * where <dfsname> contains non-ASCII unicode symbols.
-			 */
-			rc = -EREMOTE;
+		} else if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
+			rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
+							     full_path, &islink);
+			if (rc2) {
+				rc = rc2;
+				goto out;
+			}
+			if (islink)
+				rc = -EREMOTE;
 		}
 		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
 		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -794,7 +794,6 @@ static int
 smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
-	int rc;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	int err_buftype = CIFS_NO_BUFFER;
@@ -802,6 +801,8 @@ smb2_is_path_accessible(const unsigned i
 	struct kvec err_iov = {};
 	struct cifs_fid fid;
 	struct cached_fid *cfid;
+	bool islink;
+	int rc, rc2;
 
 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
 	if (!rc) {
@@ -830,15 +831,17 @@ smb2_is_path_accessible(const unsigned i
 
 		if (unlikely(!hdr || err_buftype == CIFS_NO_BUFFER))
 			goto out;
-		/*
-		 * Handle weird Windows SMB server behaviour. It responds with
-		 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
-		 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
-		 * where <dfsname> contains non-ASCII unicode symbols.
-		 */
-		if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
-		    hdr->Status == STATUS_OBJECT_NAME_INVALID)
-			rc = -EREMOTE;
+
+		if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
+			rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
+							     full_path, &islink);
+			if (rc2) {
+				rc = rc2;
+				goto out;
+			}
+			if (islink)
+				rc = -EREMOTE;
+		}
 		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
 		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
 			rc = -EOPNOTSUPP;


