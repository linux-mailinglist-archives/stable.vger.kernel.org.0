Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F21E53A7A8
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344158AbiFAOCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354208AbiFAOAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88308A3382;
        Wed,  1 Jun 2022 06:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB629615CD;
        Wed,  1 Jun 2022 13:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5E8C385A5;
        Wed,  1 Jun 2022 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091748;
        bh=kGzeiVBfGM4Xs0vqQEuCoPASUVQyswjYSK386OEbxt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyeZZbxy7Kf9b6e4S+0Kz0Xcf2Ul+X4r5s5syuWOR8GYMd3ZgukhRUoWb1wNyxNBN
         inGF945w1NIb0Ak21UX6wfG8JhStHxNtPOCfTYGq015seNHnq/mCQPHcuAFJpLxnjw
         37+Cx/ZYe9fgUS8gc2Xlr2rgIgkHsH3fC9LA3N6i2FK7OewoOSUZCovp67XhXXyIE5
         JzMBn5dc1iNUYTDAQlbaMoTRZe2z8DVtWO2LPbBouS8hGe5NsHwmNe9VZDRm33kKRI
         vbtu2V8AGeogZRp6buqjQvqSq3a4M47/5BNATFAxkOY8MA1xNpVenLMbz1UbwkxbCn
         sPtat+iOPIZ3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.17 37/48] cifs: return ENOENT for DFS lookup_cache_entry()
Date:   Wed,  1 Jun 2022 09:54:10 -0400
Message-Id: <20220601135421.2003328-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 337b8b0e4343567221ef8d88aac5e418208d4ac1 ]

EEXIST didn't make sense to use when dfs_cache_find() couldn't find a
cache entry nor retrieve a referral target.

It also doesn't make sense cifs_dfs_query_info_nonascii_quirk() to
emulate ENOENT anymore.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c   | 6 ++++--
 fs/cifs/dfs_cache.c | 6 +++---
 fs/cifs/misc.c      | 6 +-----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c3a26f06fdaa..1ec77ebc71a0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3420,8 +3420,9 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 }
 
 /*
- * Check if path is remote (e.g. a DFS share). Return -EREMOTE if it is,
- * otherwise 0.
+ * Check if path is remote (i.e. a DFS share).
+ *
+ * Return -EREMOTE if it is, otherwise 0 or -errno.
  */
 static int is_path_remote(struct mount_ctx *mnt_ctx)
 {
@@ -3703,6 +3704,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	if (!isdfs)
 		goto out;
 
+	/* proceed as DFS mount */
 	uuid_gen(&mnt_ctx.mount_id);
 	rc = connect_dfs_root(&mnt_ctx, &tl);
 	dfs_cache_free_tgts(&tl);
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 956f8e5cf3e7..c5dd6f7305bd 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -654,7 +654,7 @@ static struct cache_entry *__lookup_cache_entry(const char *path, unsigned int h
 			return ce;
 		}
 	}
-	return ERR_PTR(-EEXIST);
+	return ERR_PTR(-ENOENT);
 }
 
 /*
@@ -662,7 +662,7 @@ static struct cache_entry *__lookup_cache_entry(const char *path, unsigned int h
  *
  * Use whole path components in the match.  Must be called with htable_rw_lock held.
  *
- * Return ERR_PTR(-EEXIST) if the entry is not found.
+ * Return ERR_PTR(-ENOENT) if the entry is not found.
  */
 static struct cache_entry *lookup_cache_entry(const char *path)
 {
@@ -710,7 +710,7 @@ static struct cache_entry *lookup_cache_entry(const char *path)
 		while (e > s && *e != sep)
 			e--;
 	}
-	return ERR_PTR(-EEXIST);
+	return ERR_PTR(-ENOENT);
 }
 
 /**
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index afaf59c22193..a5b5b15e658a 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1309,7 +1309,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
  * for "\<server>\<dfsname>\<linkpath>" DFS reference,
  * where <dfsname> contains non-ASCII unicode symbols.
  *
- * Check such DFS reference and emulate -ENOENT if it is actual.
+ * Check such DFS reference.
  */
 int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
 				       struct cifs_tcon *tcon,
@@ -1341,10 +1341,6 @@ int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
 		cifs_dbg(FYI, "DFS ref '%s' is found, emulate -EREMOTE\n",
 			 dfspath);
 		rc = -EREMOTE;
-	} else if (rc == -EEXIST) {
-		cifs_dbg(FYI, "DFS ref '%s' is not found, emulate -ENOENT\n",
-			 dfspath);
-		rc = -ENOENT;
 	} else {
 		cifs_dbg(FYI, "%s: dfs_cache_find returned %d\n", __func__, rc);
 	}
-- 
2.35.1

