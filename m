Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5CC6BB1DC
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbjCOMbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjCOMa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:30:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60B619C5A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5F6CBCE19A7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59490C433D2;
        Wed, 15 Mar 2023 12:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883397;
        bh=tIxfPT9egr32Zt84ihANgCc0jCA/gVDbx56Kcven3Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCmk7+m9Iay1jEu9FNFtuxUAYfGHSJrEffFa7f5qqHtMUjV21x51Bmkz2ERPgD/cq
         DSKAhpsHWHVbkBV3mXfd3vFZ4zwnI15Z919ZwaYeeqdZ9BpKtZhQpn0qrrgLNMW4HO
         S0zm0tDigN6HmaIfm3X+I2udjlJLvYIzeZAT6prQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com,
        Lukas Czerner <lczerner@redhat.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Theodore Tso <tytso@mit.edu>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.15 128/145] ext4: block range must be validated before use in ext4_mb_clear_bb()
Date:   Wed, 15 Mar 2023 13:13:14 +0100
Message-Id: <20230315115743.176786972@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

commit 1e1c2b86ef86a8477fd9b9a4f48a6bfe235606f6 upstream.

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
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5916,6 +5916,15 @@ static void ext4_mb_clear_bb(handle_t *h
 
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
@@ -5932,6 +5941,8 @@ do_more:
 		overflow = EXT4_C2B(sbi, bit) + count -
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
@@ -5946,7 +5957,8 @@ do_more:
 		goto error_return;
 	}
 
-	if (!ext4_inode_block_valid(inode, block, count)) {
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks in system zone - "
 			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
@@ -6069,6 +6081,8 @@ do_more:
 		block += count;
 		count = overflow;
 		put_bh(bitmap_bh);
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 		goto do_more;
 	}
 error_return:
@@ -6115,6 +6129,7 @@ void ext4_free_blocks(handle_t *handle,
 			   "block = %llu, count = %lu", block, count);
 		return;
 	}
+	flags |= EXT4_FREE_BLOCKS_VALIDATED;
 
 	ext4_debug("freeing block %llu\n", block);
 	trace_ext4_free_blocks(inode, block, count, flags);
@@ -6146,6 +6161,8 @@ void ext4_free_blocks(handle_t *handle,
 			block -= overflow;
 			count += overflow;
 		}
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	overflow = EXT4_LBLK_COFF(sbi, count);
 	if (overflow) {
@@ -6156,6 +6173,8 @@ void ext4_free_blocks(handle_t *handle,
 				return;
 		} else
 			count += sbi->s_cluster_ratio - overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 
 	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {


