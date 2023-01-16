Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6333966CB96
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbjAPRPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbjAPROi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:14:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0164C6DD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39F91B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90267C433EF;
        Mon, 16 Jan 2023 16:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888123;
        bh=gVPOEQfuwNWTXcuf8glSoOgdI3mcoEL/km21iXPLRIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPU0Hm2pl7wFSP0+D4zpLoHmqPXLAc7os4MsrcOVDxz7pvP2rIUj6jUXmfcQyDQM6
         HXqsmohnhyNBoR05kqepKu06PbDT4fWrBZwjOUF3S21hqb4eVeGhat0J8UhrSHcmjC
         pXoBhFAP4fbn95rEwrEvRZKufXCkx+ZVI8jkTm8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 409/521] ext4: fix bug_on in __es_tree_search caused by bad boot loader inode
Date:   Mon, 16 Jan 2023 16:51:11 +0100
Message-Id: <20230116154905.391576987@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

commit 991ed014de0840c5dc405b679168924afb2952ac upstream.

We got a issue as fllows:
==================================================================
 kernel BUG at fs/ext4/extents_status.c:203!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 1 PID: 945 Comm: cat Not tainted 6.0.0-next-20221007-dirty #349
 RIP: 0010:ext4_es_end.isra.0+0x34/0x42
 RSP: 0018:ffffc9000143b768 EFLAGS: 00010203
 RAX: 0000000000000000 RBX: ffff8881769cd0b8 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffffffff8fc27cf7 RDI: 00000000ffffffff
 RBP: ffff8881769cd0bc R08: 0000000000000000 R09: ffffc9000143b5f8
 R10: 0000000000000001 R11: 0000000000000001 R12: ffff8881769cd0a0
 R13: ffff8881768e5668 R14: 00000000768e52f0 R15: 0000000000000000
 FS: 00007f359f7f05c0(0000)GS:ffff88842fd00000(0000)knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f359f5a2000 CR3: 000000017130c000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  __es_tree_search.isra.0+0x6d/0xf5
  ext4_es_cache_extent+0xfa/0x230
  ext4_cache_extents+0xd2/0x110
  ext4_find_extent+0x5d5/0x8c0
  ext4_ext_map_blocks+0x9c/0x1d30
  ext4_map_blocks+0x431/0xa50
  ext4_mpage_readpages+0x48e/0xe40
  ext4_readahead+0x47/0x50
  read_pages+0x82/0x530
  page_cache_ra_unbounded+0x199/0x2a0
  do_page_cache_ra+0x47/0x70
  page_cache_ra_order+0x242/0x400
  ondemand_readahead+0x1e8/0x4b0
  page_cache_sync_ra+0xf4/0x110
  filemap_get_pages+0x131/0xb20
  filemap_read+0xda/0x4b0
  generic_file_read_iter+0x13a/0x250
  ext4_file_read_iter+0x59/0x1d0
  vfs_read+0x28f/0x460
  ksys_read+0x73/0x160
  __x64_sys_read+0x1e/0x30
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  </TASK>
==================================================================

In the above issue, ioctl invokes the swap_inode_boot_loader function to
swap inode<5> and inode<12>. However, inode<5> contain incorrect imode and
disordered extents, and i_nlink is set to 1. The extents check for inode in
the ext4_iget function can be bypassed bacause 5 is EXT4_BOOT_LOADER_INO.
While links_count is set to 1, the extents are not initialized in
swap_inode_boot_loader. After the ioctl command is executed successfully,
the extents are swapped to inode<12>, in this case, run the `cat` command
to view inode<12>. And Bug_ON is triggered due to the incorrect extents.

When the boot loader inode is not initialized, its imode can be one of the
following:
1) the imode is a bad type, which is marked as bad_inode in ext4_iget and
   set to S_IFREG.
2) the imode is good type but not S_IFREG.
3) the imode is S_IFREG.

The BUG_ON may be triggered by bypassing the check in cases 1 and 2.
Therefore, when the boot loader inode is bad_inode or its imode is not
S_IFREG, initialize the inode to avoid triggering the BUG.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221026042310.3839669-5-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -169,7 +169,7 @@ static long swap_inode_boot_loader(struc
 	/* Protect extent tree against block allocations via delalloc */
 	ext4_double_down_write_data_sem(inode, inode_bl);
 
-	if (inode_bl->i_nlink == 0) {
+	if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
 		/* this inode has never been used as a BOOT_LOADER */
 		set_nlink(inode_bl, 1);
 		i_uid_write(inode_bl, 0);


