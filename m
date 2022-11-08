Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594D562141A
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiKHN5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiKHN5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:57:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2E766CA2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:57:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBE9CB81AFA
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292D6C43150;
        Tue,  8 Nov 2022 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915832;
        bh=hfFVETcDNQK4vJNnA8WcgX90OOkPlpb+3X8UrPc7eFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgI1aC3WJH/77tN9YeFqLaENjhtr+sTHuz/QY3Mhg8OxjryGcW5/1dKiS9hkbf1pA
         Y9T3GK23kQEFd64IFHoeWvTpC1ZMBQV+4b+ezt8IvO8yIG3W5uu6FUysARVONp2XZ8
         8mRNFHmxuKl6aU/c6ruO8OrDiEmH+c3GfjiskdDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        syzbot+c740bb18df70ad00952e@syzkaller.appspotmail.com,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 104/118] ext4: fix warning in ext4_da_release_space
Date:   Tue,  8 Nov 2022 14:39:42 +0100
Message-Id: <20221108133345.248913517@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit 1b8f787ef547230a3249bcf897221ef0cc78481b upstream.

Syzkaller report issue as follows:
EXT4-fs (loop0): Free/Dirty block details
EXT4-fs (loop0): free_blocks=0
EXT4-fs (loop0): dirty_blocks=0
EXT4-fs (loop0): Block reservation details
EXT4-fs (loop0): i_reserved_data_blocks=0
EXT4-fs warning (device loop0): ext4_da_release_space:1527: ext4_da_release_space: ino 18, to_free 1 with only 0 reserved data blocks
------------[ cut here ]------------
WARNING: CPU: 0 PID: 92 at fs/ext4/inode.c:1528 ext4_da_release_space+0x25e/0x370 fs/ext4/inode.c:1524
Modules linked in:
CPU: 0 PID: 92 Comm: kworker/u4:4 Not tainted 6.0.0-syzkaller-09423-g493ffd6605b2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:ext4_da_release_space+0x25e/0x370 fs/ext4/inode.c:1528
RSP: 0018:ffffc900015f6c90 EFLAGS: 00010296
RAX: 42215896cd52ea00 RBX: 0000000000000000 RCX: 42215896cd52ea00
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: 1ffff1100e907d96 R08: ffffffff816aa79d R09: fffff520002bece5
R10: fffff520002bece5 R11: 1ffff920002bece4 R12: ffff888021fd2000
R13: ffff88807483ecb0 R14: 0000000000000001 R15: ffff88807483e740
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555569ba628 CR3: 000000000c88e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ext4_es_remove_extent+0x1ab/0x260 fs/ext4/extents_status.c:1461
 mpage_release_unused_pages+0x24d/0xef0 fs/ext4/inode.c:1589
 ext4_writepages+0x12eb/0x3be0 fs/ext4/inode.c:2852
 do_writepages+0x3c3/0x680 mm/page-writeback.c:2469
 __writeback_single_inode+0xd1/0x670 fs/fs-writeback.c:1587
 writeback_sb_inodes+0xb3b/0x18f0 fs/fs-writeback.c:1870
 wb_writeback+0x41f/0x7b0 fs/fs-writeback.c:2044
 wb_do_writeback fs/fs-writeback.c:2187 [inline]
 wb_workfn+0x3cb/0xef0 fs/fs-writeback.c:2227
 process_one_work+0x877/0xdb0 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Above issue may happens as follows:
ext4_da_write_begin
  ext4_create_inline_data
    ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
    ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
__ext4_ioctl
  ext4_ext_migrate -> will lead to eh->eh_entries not zero, and set extent flag
ext4_da_write_begin
  ext4_da_convert_inline_data_to_extent
    ext4_da_write_inline_data_begin
      ext4_da_map_blocks
        ext4_insert_delayed_block
	  if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk))
	    if (!ext4_es_scan_clu(inode, &ext4_es_is_mapped, lblk))
	      ext4_clu_mapped(inode, EXT4_B2C(sbi, lblk)); -> will return 1
	       allocated = true;
          ext4_es_insert_delayed_block(inode, lblk, allocated);
ext4_writepages
  mpage_map_and_submit_extent(handle, &mpd, &give_up_on_write); -> return -ENOSPC
  mpage_release_unused_pages(&mpd, give_up_on_write); -> give_up_on_write == 1
    ext4_es_remove_extent
      ext4_da_release_space(inode, reserved);
        if (unlikely(to_free > ei->i_reserved_data_blocks))
	  -> to_free == 1  but ei->i_reserved_data_blocks == 0
	  -> then trigger warning as above

To solve above issue, forbid inode do migrate which has inline data.

Cc: stable@kernel.org
Reported-by: syzbot+c740bb18df70ad00952e@syzkaller.appspotmail.com
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221018022701.683489-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -425,7 +425,8 @@ int ext4_ext_migrate(struct inode *inode
 	 * already is extent-based, error out.
 	 */
 	if (!ext4_has_feature_extents(inode->i_sb) ||
-	    (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ||
+	    ext4_has_inline_data(inode))
 		return -EINVAL;
 
 	if (S_ISLNK(inode->i_mode) && inode->i_blocks == 0)


