Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A10363EB10
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 09:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiLAI12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 03:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiLAI1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 03:27:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1081463D76
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 00:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 016BEB81E5D
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 08:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F742C433D7;
        Thu,  1 Dec 2022 08:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669883215;
        bh=fS3GrG2XOVQ7pv5uYzExol24LLvbW4xtefIxzqyMoFc=;
        h=Subject:To:Cc:From:Date:From;
        b=T5/TBxvusn5oDcbKDVnCcVKXQmAIMR3qnYoquxXQYg2z1b/lv8+JQGFnB7G49U/ku
         Qdro6xzaiyWXwjwoUxx7RzzOyoAHL7tOyh3lLSvDzLJYFqnlAitEfKqwT5QIri71MF
         7R2daib9IjxB4ZA66fgExuiefG+MQ3C+tzYt+gDc=
Subject: FAILED: patch "[PATCH] cifs: fix potential use-after-free bugs" failed to apply to 5.15-stable tree
To:     pc@cjr.nz, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 01 Dec 2022 09:09:15 +0100
Message-ID: <166988215539109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7f28af9cf542 ("cifs: fix potential use-after-free bugs")
0e62904836ec ("smb3: remove trivial dfs compile warning")
c88f7dcd6d64 ("cifs: support nested dfs links over reconnect")
bbcce3680445 ("cifs: split out dfs code from cifs_reconnect()")
43b459aa5e22 ("cifs: introduce new helper for cifs_reconnect()")
7be3248f3139 ("cifs: To match file servers, make sure the server hostname matches")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7f28af9cf542f61758b982f8304f951ca99c8f58 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@cjr.nz>
Date: Fri, 12 Nov 2021 15:16:08 -0300
Subject: [PATCH] cifs: fix potential use-after-free bugs

Ensure that share and prefix variables are set to NULL after kfree()
when looping through DFS targets in __tree_connect_dfs_target().

Also, get rid of @ref in __tree_connect_dfs_target() and just pass a
boolean to indicate whether we're handling link targets or not.

Fixes: c88f7dcd6d64 ("cifs: support nested dfs links over reconnect")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ae21dff02f30..5c506f6ecd65 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4141,14 +4141,13 @@ static int target_share_matches_server(struct TCP_Server_Info *server, const cha
 }
 
 static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
-			      struct cifs_sb_info *cifs_sb, char *tree,
-			      struct dfs_cache_tgt_list *tl, struct dfs_info3_param *ref)
+				     struct cifs_sb_info *cifs_sb, char *tree, bool islink,
+				     struct dfs_cache_tgt_list *tl)
 {
 	int rc;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	const struct smb_version_operations *ops = server->ops;
 	struct cifs_tcon *ipc = tcon->ses->tcon_ipc;
-	bool islink;
 	char *share = NULL, *prefix = NULL;
 	const char *tcp_host;
 	size_t tcp_host_len;
@@ -4157,9 +4156,6 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 
 	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
 
-	islink = ref->server_type == DFS_TYPE_LINK;
-	free_dfs_info_param(ref);
-
 	tit = dfs_cache_get_tgt_iterator(tl);
 	if (!tit) {
 		rc = -ENOENT;
@@ -4173,6 +4169,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 
 		kfree(share);
 		kfree(prefix);
+		share = prefix = NULL;
 
 		/* Check if share matches with tcp ses */
 		rc = dfs_cache_get_tgt_share(server->current_fullpath + 1, tit, &share, &prefix);
@@ -4209,25 +4206,23 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 		 * newly resolved target.
 		 */
 		if (dfs_cache_find(xid, tcon->ses, cifs_sb->local_nls, cifs_remap(cifs_sb), target,
-				   ref, &ntl)) {
+				   NULL, &ntl)) {
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
 			if (rc)
 				continue;
 			rc = dfs_cache_noreq_update_tgthint(server->current_fullpath + 1, tit);
 			if (!rc)
 				rc = cifs_update_super_prepath(cifs_sb, prefix);
-			break;
-		}
-		/* Target is another dfs share */
-		rc = update_server_fullpath(server, cifs_sb, target);
-		dfs_cache_free_tgts(tl);
-
-		if (!rc) {
-			rc = -EREMOTE;
-			list_replace_init(&ntl.tl_list, &tl->tl_list);
 		} else {
-			dfs_cache_free_tgts(&ntl);
-			free_dfs_info_param(ref);
+			/* Target is another dfs share */
+			rc = update_server_fullpath(server, cifs_sb, target);
+			dfs_cache_free_tgts(tl);
+
+			if (!rc) {
+				rc = -EREMOTE;
+				list_replace_init(&ntl.tl_list, &tl->tl_list);
+			} else
+				dfs_cache_free_tgts(&ntl);
 		}
 		break;
 	}
@@ -4240,15 +4235,15 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 }
 
 static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
-			    struct cifs_sb_info *cifs_sb, char *tree,
-			    struct dfs_cache_tgt_list *tl, struct dfs_info3_param *ref)
+				   struct cifs_sb_info *cifs_sb, char *tree, bool islink,
+				   struct dfs_cache_tgt_list *tl)
 {
 	int rc;
 	int num_links = 0;
 	struct TCP_Server_Info *server = tcon->ses->server;
 
 	do {
-		rc = __tree_connect_dfs_target(xid, tcon, cifs_sb, tree, tl, ref);
+		rc = __tree_connect_dfs_target(xid, tcon, cifs_sb, tree, islink, tl);
 		if (!rc || rc != -EREMOTE)
 			break;
 	} while (rc = -ELOOP, ++num_links < MAX_NESTED_LINKS);
@@ -4302,7 +4297,9 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		goto out;
 	}
 
-	rc = tree_connect_dfs_target(xid, tcon, cifs_sb, tree, &tl, &ref);
+	rc = tree_connect_dfs_target(xid, tcon, cifs_sb, tree, ref.server_type == DFS_TYPE_LINK,
+				     &tl);
+	free_dfs_info_param(&ref);
 
 out:
 	kfree(tree);

