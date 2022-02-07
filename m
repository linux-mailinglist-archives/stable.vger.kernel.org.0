Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F714ABD7E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346612AbiBGLon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385107AbiBGLbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141B4C033247;
        Mon,  7 Feb 2022 03:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D1DE60A67;
        Mon,  7 Feb 2022 11:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4254CC004E1;
        Mon,  7 Feb 2022 11:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233359;
        bh=96amUmCpTDzItVXSdoi5GA0nI3qQJEkMsW3DEz5lelk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdGi85eKiTBKSaV2gXu0xo0ckHPybXaPZue3DFINuX2Xcv4sXSEdZuxflK6DuE0AL
         MbV0y+ifI7Un63W6XckTGF6tJcmDMI0U3xHbBRKS3uiGqH0t8lnc9uudtdPE7v8rM/
         d3O+ZP2YfbhO93svBSXkrB0MhaNvS08b8uCkVhA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 099/110] ext4: prevent used blocks from being allocated during fast commit replay
Date:   Mon,  7 Feb 2022 12:07:12 +0100
Message-Id: <20220207103805.744397195@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
@@ -2935,6 +2935,9 @@ void ext4_fc_replay_cleanup(struct super
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
@@ -6096,11 +6096,15 @@ int ext4_ext_clear_bb(struct inode *inod
 
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
@@ -1603,16 +1603,23 @@ out:
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
@@ -1630,6 +1637,9 @@ static int ext4_fc_record_regions(struct
 	region->pblk = pblk;
 	region->len = len;
 
+	if (replay)
+		state->fc_regions_valid++;
+
 	return 0;
 }
 
@@ -1973,7 +1983,7 @@ static int ext4_fc_replay_scan(journal_t
 			ret = ext4_fc_record_regions(sb,
 				le32_to_cpu(ext.fc_ino),
 				le32_to_cpu(ex->ee_block), ext4_ext_pblock(ex),
-				ext4_ext_get_actual_len(ex));
+				ext4_ext_get_actual_len(ex), 0);
 			if (ret < 0)
 				break;
 			ret = JBD2_FC_REPLAY_CONTINUE;


