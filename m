Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70C82375F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389049AbfETMZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389035AbfETMZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84DB420815;
        Mon, 20 May 2019 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355120;
        bh=3HVJic2IsVhMwD2NLqQ17Pn8OtBdLg7jJNwliuijtwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AR/MpG83qy0A1YYQQGoQxs8a/3g5rrTbVQZuPv4rEPzUrnA0EVCGVIAUFllqg8N6T
         IZQeXrGyEe7GMXs8d4fYBuDAoQWi92L9au9dz9v8InjuyzCX26RfVRlzmWS4VW6tsd
         NvgVPEu4JCAUjleIb237YKtSdFBHFJABEBf5uDio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 105/105] ext4: dont update s_rev_level if not required
Date:   Mon, 20 May 2019 14:14:51 +0200
Message-Id: <20190520115254.476516117@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Dilger <adilger@dilger.ca>

commit c9e716eb9b3455a83ed7c5f5a81256a3da779a95 upstream.

Don't update the superblock s_rev_level during mount if it isn't
actually necessary, only if superblock features are being set by
the kernel.  This was originally added for ext3 since it always
set the INCOMPAT_RECOVER and HAS_JOURNAL features during mount,
but this is not needed since no journal mode was added to ext4.

That will allow Geert to mount his 20-year-old ext2 rev 0.0 m68k
filesystem, as a testament of the backward compatibility of ext4.

Fixes: 0390131ba84f ("ext4: Allow ext4 to run without a journal")
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h  |    6 +++++-
 fs/ext4/inode.c |    1 -
 fs/ext4/super.c |    1 -
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1670,6 +1670,8 @@ static inline void ext4_clear_state_flag
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
 
+extern void ext4_update_dynamic_rev(struct super_block *sb);
+
 #define EXT4_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline bool ext4_has_feature_##name(struct super_block *sb) \
 { \
@@ -1678,6 +1680,7 @@ static inline bool ext4_has_feature_##na
 } \
 static inline void ext4_set_feature_##name(struct super_block *sb) \
 { \
+	ext4_update_dynamic_rev(sb); \
 	EXT4_SB(sb)->s_es->s_feature_compat |= \
 		cpu_to_le32(EXT4_FEATURE_COMPAT_##flagname); \
 } \
@@ -1695,6 +1698,7 @@ static inline bool ext4_has_feature_##na
 } \
 static inline void ext4_set_feature_##name(struct super_block *sb) \
 { \
+	ext4_update_dynamic_rev(sb); \
 	EXT4_SB(sb)->s_es->s_feature_ro_compat |= \
 		cpu_to_le32(EXT4_FEATURE_RO_COMPAT_##flagname); \
 } \
@@ -1712,6 +1716,7 @@ static inline bool ext4_has_feature_##na
 } \
 static inline void ext4_set_feature_##name(struct super_block *sb) \
 { \
+	ext4_update_dynamic_rev(sb); \
 	EXT4_SB(sb)->s_es->s_feature_incompat |= \
 		cpu_to_le32(EXT4_FEATURE_INCOMPAT_##flagname); \
 } \
@@ -2679,7 +2684,6 @@ do {									\
 
 #endif
 
-extern void ext4_update_dynamic_rev(struct super_block *sb);
 extern int ext4_update_compat_feature(handle_t *handle, struct super_block *sb,
 					__u32 compat);
 extern int ext4_update_rocompat_feature(handle_t *handle,
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5324,7 +5324,6 @@ static int ext4_do_update_inode(handle_t
 		err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
 		if (err)
 			goto out_brelse;
-		ext4_update_dynamic_rev(sb);
 		ext4_set_feature_large_file(sb);
 		ext4_handle_sync(handle);
 		err = ext4_handle_dirty_super(handle, sb);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2259,7 +2259,6 @@ static int ext4_setup_super(struct super
 		es->s_max_mnt_count = cpu_to_le16(EXT4_DFL_MAX_MNT_COUNT);
 	le16_add_cpu(&es->s_mnt_count, 1);
 	ext4_update_tstamp(es, s_mtime);
-	ext4_update_dynamic_rev(sb);
 	if (sbi->s_journal)
 		ext4_set_feature_journal_needs_recovery(sb);
 


