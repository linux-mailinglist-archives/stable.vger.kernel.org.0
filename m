Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711875921CE
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiHNPmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241176AbiHNPkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:40:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4A021831;
        Sun, 14 Aug 2022 08:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D65DB80B7E;
        Sun, 14 Aug 2022 15:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A209C433B5;
        Sun, 14 Aug 2022 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491165;
        bh=MndWcP1tH2TdgPOXBHyOSON7mwvxcXIppAyDlJHNYAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdkDI9cjf465fKrOw30gYbRMABApII8gP6Ajpim298djmYbX7hphL6LF91jjd7ibo
         0QOKDBQ5wCInhNO0EgohPStIBkxH/ll6UZ2InMJI+HM1pyWIgHy8llaIxcd+ZM4wQE
         WpTGxNW62pCbwgdGPGUU6DSacvOFqVtPaEv5tSEXwxEj8zGFA64w4pNfV4KTrHBEw9
         g8umrJgTxcbawqKJqz515r4P//8zvB8lN96gBMzDiwcTVN9htqN/aCNH7YMag/pl0G
         GAoMVLJPqlQHBlDEhgHXeqzi11RvpuGFcKa4oFiqkgubklOXrjLYdAdp+38INKpxtZ
         a55jdptsbdhRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Czerner <lczerner@redhat.com>,
        syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 55/56] ext4: block range must be validated before use in ext4_mb_clear_bb()
Date:   Sun, 14 Aug 2022 11:30:25 -0400
Message-Id: <20220814153026.2377377-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit 1e1c2b86ef86a8477fd9b9a4f48a6bfe235606f6 ]

Block range to free is validated in ext4_free_blocks() using
ext4_inode_block_valid() and then it's passed to ext4_mb_clear_bb().
However in some situations on bigalloc file system the range might be
adjusted after the validation in ext4_free_blocks() which can lead to
troubles on corrupted file systems such as one found by syzkaller that
resulted in the following BUG

kernel BUG at fs/ext4/ext4.h:3319!
PREEMPT SMP NOPTI
CPU: 28 PID: 4243 Comm: repro Kdump: loaded Not tainted 5.19.0-rc6+ #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
RIP: 0010:ext4_free_blocks+0x95e/0xa90
Call Trace:
 <TASK>
 ? lock_timer_base+0x61/0x80
 ? __es_remove_extent+0x5a/0x760
 ? __mod_timer+0x256/0x380
 ? ext4_ind_truncate_ensure_credits+0x90/0x220
 ext4_clear_blocks+0x107/0x1b0
 ext4_free_data+0x15b/0x170
 ext4_ind_truncate+0x214/0x2c0
 ? _raw_spin_unlock+0x15/0x30
 ? ext4_discard_preallocations+0x15a/0x410
 ? ext4_journal_check_start+0xe/0x90
 ? __ext4_journal_start_sb+0x2f/0x110
 ext4_truncate+0x1b5/0x460
 ? __ext4_journal_start_sb+0x2f/0x110
 ext4_evict_inode+0x2b4/0x6f0
 evict+0xd0/0x1d0
 ext4_enable_quotas+0x11f/0x1f0
 ext4_orphan_cleanup+0x3de/0x430
 ? proc_create_seq_private+0x43/0x50
 ext4_fill_super+0x295f/0x3ae0
 ? snprintf+0x39/0x40
 ? sget_fc+0x19c/0x330
 ? ext4_reconfigure+0x850/0x850
 get_tree_bdev+0x16d/0x260
 vfs_get_tree+0x25/0xb0
 path_mount+0x431/0xa70
 __x64_sys_mount+0xe2/0x120
 do_syscall_64+0x5b/0x80
 ? do_user_addr_fault+0x1e2/0x670
 ? exc_page_fault+0x70/0x170
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fdf4e512ace

Fix it by making sure that the block range is properly validated before
used every time it changes in ext4_free_blocks() or ext4_mb_clear_bb().

Link: https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c
Reported-by: syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Tested-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220714165903.58260-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 816448041db8..3fc2b8ff2826 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5916,6 +5916,15 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 
 	sbi = EXT4_SB(sb);
 
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
+		ext4_error(sb, "Freeing blocks in system zone - "
+			   "Block = %llu, count = %lu", block, count);
+		/* err = 0. ext4_std_error should be a no op */
+		goto error_return;
+	}
+	flags |= EXT4_FREE_BLOCKS_VALIDATED;
+
 do_more:
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
@@ -5932,6 +5941,8 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 		overflow = EXT4_C2B(sbi, bit) + count -
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
@@ -5946,7 +5957,8 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 		goto error_return;
 	}
 
-	if (!ext4_inode_block_valid(inode, block, count)) {
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks in system zone - "
 			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
@@ -6069,6 +6081,8 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 		block += count;
 		count = overflow;
 		put_bh(bitmap_bh);
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 		goto do_more;
 	}
 error_return:
@@ -6115,6 +6129,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			   "block = %llu, count = %lu", block, count);
 		return;
 	}
+	flags |= EXT4_FREE_BLOCKS_VALIDATED;
 
 	ext4_debug("freeing block %llu\n", block);
 	trace_ext4_free_blocks(inode, block, count, flags);
@@ -6146,6 +6161,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			block -= overflow;
 			count += overflow;
 		}
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	overflow = EXT4_LBLK_COFF(sbi, count);
 	if (overflow) {
@@ -6156,6 +6173,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 				return;
 		} else
 			count += sbi->s_cluster_ratio - overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 
 	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
-- 
2.35.1

