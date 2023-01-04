Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F68865D9AB
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239812AbjADQ1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239840AbjADQ0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:26:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413B233D75
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6758B817B8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFC4C433EF;
        Wed,  4 Jan 2023 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849607;
        bh=646KULrc+YqY/DoBIgUczkDY3B9fHFZiADHQ5hBDPTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDyzpti36asq4f1kI5UCY9vTUIHU8ooMGoEwCi7FE+OvGy5h9RbJHfb4Xtk6UiNRX
         4yYg858CLUo3jyDloent9ZxeWnXds16z7LMaWDfUck0w8ukQyxWbNk248CkC+u++zR
         WXmrDIbeRr0N4GnhJi4pICu9+j6vh4fApWCFq/Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 160/177] ext4: fix corrupt backup group descriptors after online resize
Date:   Wed,  4 Jan 2023 17:07:31 +0100
Message-Id: <20230104160512.520866688@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 8f49ec603ae3e213bfab2799182724e3abac55a1 upstream.

In commit 9a8c5b0d0615 ("ext4: update the backup superblock's at the end
of the online resize"), it is assumed that update_backups() only updates
backup superblocks, so each b_data is treated as a backupsuper block to
update its s_block_group_nr and s_checksum. However, update_backups()
also updates the backup group descriptors, which causes the backup group
descriptors to be corrupted.

The above commit fixes the problem of invalid checksum of the backup
superblock. The root cause of this problem is that the checksum of
ext4_update_super() is not set correctly. This problem has been fixed
in the previous patch ("ext4: fix bad checksum after online resize").

However, we do need to set block_group_nr for the backup superblock in
update_backups(). When a block is in a group that contains a backup
superblock, and the block is the first block in the group, the block is
definitely a superblock. We add a helper function that includes setting
s_block_group_nr and updating checksum, and then call it only when the
above conditions are met to prevent the backup group descriptors from
being incorrectly modified.

Fixes: 9a8c5b0d0615 ("ext4: update the backup superblock's at the end of the online resize")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221117040341.1380702-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 70fef50ab3f9..d460440d6dee 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1110,6 +1110,16 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+static inline void ext4_set_block_group_nr(struct super_block *sb, char *data,
+					   ext4_group_t group)
+{
+	struct ext4_super_block *es = (struct ext4_super_block *) data;
+
+	es->s_block_group_nr = cpu_to_le16(group);
+	if (ext4_has_metadata_csum(sb))
+		es->s_checksum = ext4_superblock_csum(sb, es);
+}
+
 /*
  * Update the backup copies of the ext4 metadata.  These don't need to be part
  * of the main resize transaction, because e2fsck will re-write them if there
@@ -1158,7 +1168,8 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 	while (group < sbi->s_groups_count) {
 		struct buffer_head *bh;
 		ext4_fsblk_t backup_block;
-		struct ext4_super_block *es;
+		int has_super = ext4_bg_has_super(sb, group);
+		ext4_fsblk_t first_block = ext4_group_first_block_no(sb, group);
 
 		/* Out of journal space, and can't get more - abort - so sad */
 		err = ext4_resize_ensure_credits_batch(handle, 1);
@@ -1168,8 +1179,7 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 		if (meta_bg == 0)
 			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
 		else
-			backup_block = (ext4_group_first_block_no(sb, group) +
-					ext4_bg_has_super(sb, group));
+			backup_block = first_block + has_super;
 
 		bh = sb_getblk(sb, backup_block);
 		if (unlikely(!bh)) {
@@ -1187,10 +1197,8 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 		memcpy(bh->b_data, data, size);
 		if (rest)
 			memset(bh->b_data + size, 0, rest);
-		es = (struct ext4_super_block *) bh->b_data;
-		es->s_block_group_nr = cpu_to_le16(group);
-		if (ext4_has_metadata_csum(sb))
-			es->s_checksum = ext4_superblock_csum(sb, es);
+		if (has_super && (backup_block == first_block))
+			ext4_set_block_group_nr(sb, bh->b_data, group);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 		err = ext4_handle_dirty_metadata(handle, NULL, bh);
-- 
2.39.0



