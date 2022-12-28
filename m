Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAB26580E7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiL1QXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiL1QVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:21:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AA61B9C8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:19:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 065C061568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCBAC433F0;
        Wed, 28 Dec 2022 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244375;
        bh=8rZFMDp6qzkogc+ATkqbBO+TYJyEu7kRuC/0XmOxaAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tToRMHCTRyhaJA8FqCPrYyMmgXMUvrvEmoU/yKAdtZVfwKM9g4ar0EH032mYyRgdy
         dnX47fUOYUQ4/uTCxPmrTRZWy1jrvNNGgVUz1BhSHZuYEhulxQY73Nrj4WY1iJjbe+
         D8ECfOhiKZ48p8ilVK2taqmjJ8vvaLtcS77DSbJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sheng Yong <shengyong@oppo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0659/1146] f2fs: fix to enable compress for newly created file if extension matches
Date:   Wed, 28 Dec 2022 15:36:38 +0100
Message-Id: <20221228144348.056045861@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Sheng Yong <shengyong@oppo.com>

[ Upstream commit 787caf1bdcd9f04058e4e8d8ed56db1dbafea0b7 ]

If compress_extension is set, and a newly created file matches the
extension, the file could be marked as compression file. However,
if inline_data is also enabled, there is no chance to check its
extension since f2fs_should_compress() always returns false.

This patch moves set_compress_inode(), which do extension check, in
f2fs_should_compress() to check extensions before setting inline
data flag.

Fixes: 7165841d578e ("f2fs: fix to check inline_data during compressed inode conversion")
Signed-off-by: Sheng Yong <shengyong@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  |   2 +-
 fs/f2fs/namei.c | 329 ++++++++++++++++++++++++------------------------
 2 files changed, 164 insertions(+), 167 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e6355a5683b7..8b9f0b3c7723 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2974,7 +2974,7 @@ static inline void f2fs_change_bit(unsigned int nr, char *addr)
 /* Flags that should be inherited by new inodes from their parent. */
 #define F2FS_FL_INHERITED (F2FS_SYNC_FL | F2FS_NODUMP_FL | F2FS_NOATIME_FL | \
 			   F2FS_DIRSYNC_FL | F2FS_PROJINHERIT_FL | \
-			   F2FS_CASEFOLD_FL | F2FS_COMPR_FL | F2FS_NOCOMP_FL)
+			   F2FS_CASEFOLD_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define F2FS_REG_FLMASK		(~(F2FS_DIRSYNC_FL | F2FS_PROJINHERIT_FL | \
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a389772fd212..b6c14c9c33a0 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -22,8 +22,163 @@
 #include "acl.h"
 #include <trace/events/f2fs.h>
 
+static inline int is_extension_exist(const unsigned char *s, const char *sub,
+						bool tmp_ext)
+{
+	size_t slen = strlen(s);
+	size_t sublen = strlen(sub);
+	int i;
+
+	if (sublen == 1 && *sub == '*')
+		return 1;
+
+	/*
+	 * filename format of multimedia file should be defined as:
+	 * "filename + '.' + extension + (optional: '.' + temp extension)".
+	 */
+	if (slen < sublen + 2)
+		return 0;
+
+	if (!tmp_ext) {
+		/* file has no temp extension */
+		if (s[slen - sublen - 1] != '.')
+			return 0;
+		return !strncasecmp(s + slen - sublen, sub, sublen);
+	}
+
+	for (i = 1; i < slen - sublen; i++) {
+		if (s[i] != '.')
+			continue;
+		if (!strncasecmp(s + i + 1, sub, sublen))
+			return 1;
+	}
+
+	return 0;
+}
+
+int f2fs_update_extension_list(struct f2fs_sb_info *sbi, const char *name,
+							bool hot, bool set)
+{
+	__u8 (*extlist)[F2FS_EXTENSION_LEN] = sbi->raw_super->extension_list;
+	int cold_count = le32_to_cpu(sbi->raw_super->extension_count);
+	int hot_count = sbi->raw_super->hot_ext_count;
+	int total_count = cold_count + hot_count;
+	int start, count;
+	int i;
+
+	if (set) {
+		if (total_count == F2FS_MAX_EXTENSION)
+			return -EINVAL;
+	} else {
+		if (!hot && !cold_count)
+			return -EINVAL;
+		if (hot && !hot_count)
+			return -EINVAL;
+	}
+
+	if (hot) {
+		start = cold_count;
+		count = total_count;
+	} else {
+		start = 0;
+		count = cold_count;
+	}
+
+	for (i = start; i < count; i++) {
+		if (strcmp(name, extlist[i]))
+			continue;
+
+		if (set)
+			return -EINVAL;
+
+		memcpy(extlist[i], extlist[i + 1],
+				F2FS_EXTENSION_LEN * (total_count - i - 1));
+		memset(extlist[total_count - 1], 0, F2FS_EXTENSION_LEN);
+		if (hot)
+			sbi->raw_super->hot_ext_count = hot_count - 1;
+		else
+			sbi->raw_super->extension_count =
+						cpu_to_le32(cold_count - 1);
+		return 0;
+	}
+
+	if (!set)
+		return -EINVAL;
+
+	if (hot) {
+		memcpy(extlist[count], name, strlen(name));
+		sbi->raw_super->hot_ext_count = hot_count + 1;
+	} else {
+		char buf[F2FS_MAX_EXTENSION][F2FS_EXTENSION_LEN];
+
+		memcpy(buf, &extlist[cold_count],
+				F2FS_EXTENSION_LEN * hot_count);
+		memset(extlist[cold_count], 0, F2FS_EXTENSION_LEN);
+		memcpy(extlist[cold_count], name, strlen(name));
+		memcpy(&extlist[cold_count + 1], buf,
+				F2FS_EXTENSION_LEN * hot_count);
+		sbi->raw_super->extension_count = cpu_to_le32(cold_count + 1);
+	}
+	return 0;
+}
+
+static void set_compress_new_inode(struct f2fs_sb_info *sbi, struct inode *dir,
+				struct inode *inode, const unsigned char *name)
+{
+	__u8 (*extlist)[F2FS_EXTENSION_LEN] = sbi->raw_super->extension_list;
+	unsigned char (*noext)[F2FS_EXTENSION_LEN] =
+						F2FS_OPTION(sbi).noextensions;
+	unsigned char (*ext)[F2FS_EXTENSION_LEN] = F2FS_OPTION(sbi).extensions;
+	unsigned char ext_cnt = F2FS_OPTION(sbi).compress_ext_cnt;
+	unsigned char noext_cnt = F2FS_OPTION(sbi).nocompress_ext_cnt;
+	int i, cold_count, hot_count;
+
+	if (!f2fs_sb_has_compression(sbi))
+		return;
+
+	if (S_ISDIR(inode->i_mode))
+		goto inherit_comp;
+
+	/* This name comes only from normal files. */
+	if (!name)
+		return;
+
+	/* Don't compress hot files. */
+	f2fs_down_read(&sbi->sb_lock);
+	cold_count = le32_to_cpu(sbi->raw_super->extension_count);
+	hot_count = sbi->raw_super->hot_ext_count;
+	for (i = cold_count; i < cold_count + hot_count; i++)
+		if (is_extension_exist(name, extlist[i], false))
+			break;
+	f2fs_up_read(&sbi->sb_lock);
+	if (i < (cold_count + hot_count))
+		return;
+
+	/* Don't compress unallowed extension. */
+	for (i = 0; i < noext_cnt; i++)
+		if (is_extension_exist(name, noext[i], false))
+			return;
+
+	/* Compress wanting extension. */
+	for (i = 0; i < ext_cnt; i++) {
+		if (is_extension_exist(name, ext[i], false)) {
+			set_compress_context(inode);
+			return;
+		}
+	}
+inherit_comp:
+	/* Inherit the {no-}compression flag in directory */
+	if (F2FS_I(dir)->i_flags & F2FS_NOCOMP_FL) {
+		F2FS_I(inode)->i_flags |= F2FS_NOCOMP_FL;
+		f2fs_mark_inode_dirty_sync(inode, true);
+	} else if (F2FS_I(dir)->i_flags & F2FS_COMPR_FL) {
+		set_compress_context(inode);
+	}
+}
+
 static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
-						struct inode *dir, umode_t mode)
+						struct inode *dir, umode_t mode,
+						const char *name)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	nid_t ino;
@@ -114,12 +269,8 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL)
 		set_inode_flag(inode, FI_PROJ_INHERIT);
 
-	if (f2fs_sb_has_compression(sbi)) {
-		/* Inherit the compression flag in directory */
-		if ((F2FS_I(dir)->i_flags & F2FS_COMPR_FL) &&
-					f2fs_may_compress(inode))
-			set_compress_context(inode);
-	}
+	/* Check compression first. */
+	set_compress_new_inode(sbi, dir, inode, name);
 
 	/* Should enable inline_data after compression set */
 	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
@@ -153,40 +304,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 	return ERR_PTR(err);
 }
 
-static inline int is_extension_exist(const unsigned char *s, const char *sub,
-						bool tmp_ext)
-{
-	size_t slen = strlen(s);
-	size_t sublen = strlen(sub);
-	int i;
-
-	if (sublen == 1 && *sub == '*')
-		return 1;
-
-	/*
-	 * filename format of multimedia file should be defined as:
-	 * "filename + '.' + extension + (optional: '.' + temp extension)".
-	 */
-	if (slen < sublen + 2)
-		return 0;
-
-	if (!tmp_ext) {
-		/* file has no temp extension */
-		if (s[slen - sublen - 1] != '.')
-			return 0;
-		return !strncasecmp(s + slen - sublen, sub, sublen);
-	}
-
-	for (i = 1; i < slen - sublen; i++) {
-		if (s[i] != '.')
-			continue;
-		if (!strncasecmp(s + i + 1, sub, sublen))
-			return 1;
-	}
-
-	return 0;
-}
-
 /*
  * Set file's temperature for hot/cold data separation
  */
@@ -217,124 +334,6 @@ static inline void set_file_temperature(struct f2fs_sb_info *sbi, struct inode *
 		file_set_hot(inode);
 }
 
-int f2fs_update_extension_list(struct f2fs_sb_info *sbi, const char *name,
-							bool hot, bool set)
-{
-	__u8 (*extlist)[F2FS_EXTENSION_LEN] = sbi->raw_super->extension_list;
-	int cold_count = le32_to_cpu(sbi->raw_super->extension_count);
-	int hot_count = sbi->raw_super->hot_ext_count;
-	int total_count = cold_count + hot_count;
-	int start, count;
-	int i;
-
-	if (set) {
-		if (total_count == F2FS_MAX_EXTENSION)
-			return -EINVAL;
-	} else {
-		if (!hot && !cold_count)
-			return -EINVAL;
-		if (hot && !hot_count)
-			return -EINVAL;
-	}
-
-	if (hot) {
-		start = cold_count;
-		count = total_count;
-	} else {
-		start = 0;
-		count = cold_count;
-	}
-
-	for (i = start; i < count; i++) {
-		if (strcmp(name, extlist[i]))
-			continue;
-
-		if (set)
-			return -EINVAL;
-
-		memcpy(extlist[i], extlist[i + 1],
-				F2FS_EXTENSION_LEN * (total_count - i - 1));
-		memset(extlist[total_count - 1], 0, F2FS_EXTENSION_LEN);
-		if (hot)
-			sbi->raw_super->hot_ext_count = hot_count - 1;
-		else
-			sbi->raw_super->extension_count =
-						cpu_to_le32(cold_count - 1);
-		return 0;
-	}
-
-	if (!set)
-		return -EINVAL;
-
-	if (hot) {
-		memcpy(extlist[count], name, strlen(name));
-		sbi->raw_super->hot_ext_count = hot_count + 1;
-	} else {
-		char buf[F2FS_MAX_EXTENSION][F2FS_EXTENSION_LEN];
-
-		memcpy(buf, &extlist[cold_count],
-				F2FS_EXTENSION_LEN * hot_count);
-		memset(extlist[cold_count], 0, F2FS_EXTENSION_LEN);
-		memcpy(extlist[cold_count], name, strlen(name));
-		memcpy(&extlist[cold_count + 1], buf,
-				F2FS_EXTENSION_LEN * hot_count);
-		sbi->raw_super->extension_count = cpu_to_le32(cold_count + 1);
-	}
-	return 0;
-}
-
-static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
-						const unsigned char *name)
-{
-	__u8 (*extlist)[F2FS_EXTENSION_LEN] = sbi->raw_super->extension_list;
-	unsigned char (*noext)[F2FS_EXTENSION_LEN] = F2FS_OPTION(sbi).noextensions;
-	unsigned char (*ext)[F2FS_EXTENSION_LEN] = F2FS_OPTION(sbi).extensions;
-	unsigned char ext_cnt = F2FS_OPTION(sbi).compress_ext_cnt;
-	unsigned char noext_cnt = F2FS_OPTION(sbi).nocompress_ext_cnt;
-	int i, cold_count, hot_count;
-
-	if (!f2fs_sb_has_compression(sbi) ||
-			F2FS_I(inode)->i_flags & F2FS_NOCOMP_FL ||
-			!f2fs_may_compress(inode) ||
-			(!ext_cnt && !noext_cnt))
-		return;
-
-	f2fs_down_read(&sbi->sb_lock);
-
-	cold_count = le32_to_cpu(sbi->raw_super->extension_count);
-	hot_count = sbi->raw_super->hot_ext_count;
-
-	for (i = cold_count; i < cold_count + hot_count; i++) {
-		if (is_extension_exist(name, extlist[i], false)) {
-			f2fs_up_read(&sbi->sb_lock);
-			return;
-		}
-	}
-
-	f2fs_up_read(&sbi->sb_lock);
-
-	for (i = 0; i < noext_cnt; i++) {
-		if (is_extension_exist(name, noext[i], false)) {
-			f2fs_disable_compressed_file(inode);
-			return;
-		}
-	}
-
-	if (is_inode_flag_set(inode, FI_COMPRESSED_FILE))
-		return;
-
-	for (i = 0; i < ext_cnt; i++) {
-		if (!is_extension_exist(name, ext[i], false))
-			continue;
-
-		/* Do not use inline_data with compression */
-		stat_dec_inline_inode(inode);
-		clear_inode_flag(inode, FI_INLINE_DATA);
-		set_compress_context(inode);
-		return;
-	}
-}
-
 static int f2fs_create(struct user_namespace *mnt_userns, struct inode *dir,
 		       struct dentry *dentry, umode_t mode, bool excl)
 {
@@ -352,15 +351,13 @@ static int f2fs_create(struct user_namespace *mnt_userns, struct inode *dir,
 	if (err)
 		return err;
 
-	inode = f2fs_new_inode(mnt_userns, dir, mode);
+	inode = f2fs_new_inode(mnt_userns, dir, mode, dentry->d_name.name);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
 	if (!test_opt(sbi, DISABLE_EXT_IDENTIFY))
 		set_file_temperature(sbi, inode, dentry->d_name.name);
 
-	set_compress_inode(sbi, inode, dentry->d_name.name);
-
 	inode->i_op = &f2fs_file_inode_operations;
 	inode->i_fop = &f2fs_file_operations;
 	inode->i_mapping->a_ops = &f2fs_dblock_aops;
@@ -689,7 +686,7 @@ static int f2fs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	if (err)
 		return err;
 
-	inode = f2fs_new_inode(mnt_userns, dir, S_IFLNK | S_IRWXUGO);
+	inode = f2fs_new_inode(mnt_userns, dir, S_IFLNK | S_IRWXUGO, NULL);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
@@ -760,7 +757,7 @@ static int f2fs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	if (err)
 		return err;
 
-	inode = f2fs_new_inode(mnt_userns, dir, S_IFDIR | mode);
+	inode = f2fs_new_inode(mnt_userns, dir, S_IFDIR | mode, NULL);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
@@ -817,7 +814,7 @@ static int f2fs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	if (err)
 		return err;
 
-	inode = f2fs_new_inode(mnt_userns, dir, mode);
+	inode = f2fs_new_inode(mnt_userns, dir, mode, NULL);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
@@ -856,7 +853,7 @@ static int __f2fs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
 	if (err)
 		return err;
 
-	inode = f2fs_new_inode(mnt_userns, dir, mode);
+	inode = f2fs_new_inode(mnt_userns, dir, mode, NULL);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-- 
2.35.1



