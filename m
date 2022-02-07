Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBD64ABDC1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389075AbiBGLqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386710AbiBGLgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:36:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D70C0401E6;
        Mon,  7 Feb 2022 03:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EBC1B8112C;
        Mon,  7 Feb 2022 11:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C04C004E1;
        Mon,  7 Feb 2022 11:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233774;
        bh=TU7dy6IjSz60N6jVr/tfuxaZIh8qCIsBtKViXY1Pn5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2reOLNQvyw2VZddMSPDm1sjlVLb8GQwjzEOXbcceXUCwla6f7USxsIKwZ0PC/X4s/
         lFPmSoVKI572gG5DAfef9EBH2M7cBA5ykeyHYxmJKlE+L8FV4sa4esCBKpI66Y6Voq
         DbXv8zY6owXfzJcGHwQrWj7ZIYVZRFkYAzsvFrlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.16 115/126] ext4: prevent used blocks from being allocated during fast commit replay
Date:   Mon,  7 Feb 2022 12:07:26 +0100
Message-Id: <20220207103808.033200848@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Yin <yinxin.x@bytedance.com>

commit 599ea31d13617c5484c40cdf50d88301dc351cfc upstream.

During fast commit replay procedure, we clear inode blocks bitmap in
ext4_ext_clear_bb(), this may cause ext4_mb_new_blocks_simple() allocate
blocks still in use.

Make ext4_fc_record_regions() also record physical disk regions used by
inodes during replay procedure. Then ext4_mb_new_blocks_simple() can
excludes these blocks in use.

Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Link: https://lore.kernel.org/r/20220110035141.1980-2-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h        |    3 +++
 fs/ext4/extents.c     |    4 ++++
 fs/ext4/fast_commit.c |   20 +++++++++++++++-----
 3 files changed, 22 insertions(+), 5 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2936,6 +2936,9 @@ void ext4_fc_replay_cleanup(struct super
 int ext4_fc_commit(journal_t *journal, tid_t commit_tid);
 int __init ext4_fc_init_dentry_cache(void);
 void ext4_fc_destroy_dentry_cache(void);
+int ext4_fc_record_regions(struct super_block *sb, int ino,
+			   ext4_lblk_t lblk, ext4_fsblk_t pblk,
+			   int len, int replay);
 
 /* mballoc.c */
 extern const struct seq_operations ext4_mb_seq_groups_ops;
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -6101,11 +6101,15 @@ int ext4_ext_clear_bb(struct inode *inod
 
 					ext4_mb_mark_bb(inode->i_sb,
 							path[j].p_block, 1, 0);
+					ext4_fc_record_regions(inode->i_sb, inode->i_ino,
+							0, path[j].p_block, 1, 1);
 				}
 				ext4_ext_drop_refs(path);
 				kfree(path);
 			}
 			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, 0);
+			ext4_fc_record_regions(inode->i_sb, inode->i_ino,
+					map.m_lblk, map.m_pblk, map.m_len, 1);
 		}
 		cur = cur + map.m_len;
 	}
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1606,16 +1606,23 @@ out:
 }
 
 /*
- * Record physical disk regions which are in use as per fast commit area. Our
- * simple replay phase allocator excludes these regions from allocation.
+ * Record physical disk regions which are in use as per fast commit area,
+ * and used by inodes during replay phase. Our simple replay phase
+ * allocator excludes these regions from allocation.
  */
-static int ext4_fc_record_regions(struct super_block *sb, int ino,
-		ext4_lblk_t lblk, ext4_fsblk_t pblk, int len)
+int ext4_fc_record_regions(struct super_block *sb, int ino,
+		ext4_lblk_t lblk, ext4_fsblk_t pblk, int len, int replay)
 {
 	struct ext4_fc_replay_state *state;
 	struct ext4_fc_alloc_region *region;
 
 	state = &EXT4_SB(sb)->s_fc_replay_state;
+	/*
+	 * during replay phase, the fc_regions_valid may not same as
+	 * fc_regions_used, update it when do new additions.
+	 */
+	if (replay && state->fc_regions_used != state->fc_regions_valid)
+		state->fc_regions_used = state->fc_regions_valid;
 	if (state->fc_regions_used == state->fc_regions_size) {
 		state->fc_regions_size +=
 			EXT4_FC_REPLAY_REALLOC_INCREMENT;
@@ -1633,6 +1640,9 @@ static int ext4_fc_record_regions(struct
 	region->pblk = pblk;
 	region->len = len;
 
+	if (replay)
+		state->fc_regions_valid++;
+
 	return 0;
 }
 
@@ -1980,7 +1990,7 @@ static int ext4_fc_replay_scan(journal_t
 			ret = ext4_fc_record_regions(sb,
 				le32_to_cpu(ext.fc_ino),
 				le32_to_cpu(ex->ee_block), ext4_ext_pblock(ex),
-				ext4_ext_get_actual_len(ex));
+				ext4_ext_get_actual_len(ex), 0);
 			if (ret < 0)
 				break;
 			ret = JBD2_FC_REPLAY_CONTINUE;


