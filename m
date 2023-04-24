Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370A46ECE87
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjDXNd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjDXNdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11377EF7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA6062332
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDB4C433EF;
        Mon, 24 Apr 2023 13:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343146;
        bh=WLgYMxy2p5o2evbGVrqjKBGVceZ7450KEpU2tpZOjQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2J9aGeLDo5HTMtfTkuTSPdVSeTxWz4I7CCqfEDtkNYdi11FZKLow2lCspBY4EZj53
         UhHxHTus/EfH6UWCYO7cm5xtD1E/qA760ZklzRm5O0uUO4EFHkD2jPf0oiQCQbzx/u
         7UW2Qi0EkMoOkN3kWhjkErtU+mKT4GPCCxKFKGyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 093/110] cifs: avoid dup prefix path in dfs_get_automount_devname()
Date:   Mon, 24 Apr 2023 15:17:55 +0200
Message-Id: <20230424131140.030245609@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@manguebit.com>

commit d5a863a153e90996ab2aef6b9e08d509f4d5662b upstream.

@server->origin_fullpath already contains the tree name + optional
prefix, so avoid calling __build_path_from_dentry_optional_prefix() as
it might end up duplicating prefix path from @cifs_sb->prepath into
final full path.

Instead, generate DFS full path by simply merging
@server->origin_fullpath with dentry's path.

This fixes the following case

	mount.cifs //root/dfs/dir /mnt/ -o ...
	ls /mnt/link

where cifs_dfs_do_automount() will call smb3_parse_devname() with
@devname set to "//root/dfs/dir/link" instead of
"//root/dfs/dir/dir/link".

Fixes: 7ad54b98fc1f ("cifs: use origin fullpath for automounts")
Cc: <stable@vger.kernel.org> # 6.2+
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_dfs_ref.c |  2 --
 fs/cifs/dfs.h          | 22 ++++++++++++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index cb40074feb3e..0329a907bdfe 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -171,8 +171,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 		mnt = ERR_CAST(full_path);
 		goto out;
 	}
-
-	convert_delimiter(full_path, '/');
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	tmp = *cur_ctx;
diff --git a/fs/cifs/dfs.h b/fs/cifs/dfs.h
index 13f26e01f7b9..0b8cbf721fff 100644
--- a/fs/cifs/dfs.h
+++ b/fs/cifs/dfs.h
@@ -34,19 +34,33 @@ static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *p
 			      cifs_remap(cifs_sb), path, ref, tl);
 }
 
+/* Return DFS full path out of a dentry set for automount */
 static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
+	size_t len;
+	char *s;
 
 	if (unlikely(!server->origin_fullpath))
 		return ERR_PTR(-EREMOTE);
 
-	return __build_path_from_dentry_optional_prefix(dentry, page,
-							server->origin_fullpath,
-							strlen(server->origin_fullpath),
-							true);
+	s = dentry_path_raw(dentry, page, PATH_MAX);
+	if (IS_ERR(s))
+		return s;
+	/* for root, we want "" */
+	if (!s[1])
+		s++;
+
+	len = strlen(server->origin_fullpath);
+	if (s < (char *)page + len)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	s -= len;
+	memcpy(s, server->origin_fullpath, len);
+	convert_delimiter(s, '/');
+	return s;
 }
 
 static inline void dfs_put_root_smb_sessions(struct list_head *head)
-- 
2.40.0



