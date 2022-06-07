Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65122540747
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349218AbiFGRqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347947AbiFGRoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:44:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2A2109180;
        Tue,  7 Jun 2022 10:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83959B822B8;
        Tue,  7 Jun 2022 17:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D5AC385A5;
        Tue,  7 Jun 2022 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623277;
        bh=ekZHOiZn36fPxaUjgoYe6rktgLzpBpb8q8NSosekvF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnpV2WsoH+jf3fROGiVtJHKKWRrD+B7UXjygiRxMKjFZQB6o65Jki9tfhBAeCPmhv
         asi6ccLLReFsD+CZDXDF8lSVTWo8nBh0cgZAsQNQ68EP/Ppf1R9pyHybIq9YNVCJ0R
         5PVn30eiB3F+37qfxc3uUDoOqUu6S4hWjZqRmEtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 359/452] ext4: fix use-after-free in ext4_rename_dir_prepare
Date:   Tue,  7 Jun 2022 19:03:36 +0200
Message-Id: <20220607164919.261264855@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 0be698ecbe4471fcad80e81ec6a05001421041b3 upstream.

We got issue as follows:
EXT4-fs (loop0): mounted filesystem without journal. Opts: ,errors=continue
ext4_get_first_dir_block: bh->b_data=0xffff88810bee6000 len=34478
ext4_get_first_dir_block: *parent_de=0xffff88810beee6ae bh->b_data=0xffff88810bee6000
ext4_rename_dir_prepare: [1] parent_de=0xffff88810beee6ae
==================================================================
BUG: KASAN: use-after-free in ext4_rename_dir_prepare+0x152/0x220
Read of size 4 at addr ffff88810beee6ae by task rep/1895

CPU: 13 PID: 1895 Comm: rep Not tainted 5.10.0+ #241
Call Trace:
 dump_stack+0xbe/0xf9
 print_address_description.constprop.0+0x1e/0x220
 kasan_report.cold+0x37/0x7f
 ext4_rename_dir_prepare+0x152/0x220
 ext4_rename+0xf44/0x1ad0
 ext4_rename2+0x11c/0x170
 vfs_rename+0xa84/0x1440
 do_renameat2+0x683/0x8f0
 __x64_sys_renameat+0x53/0x60
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f45a6fc41c9
RSP: 002b:00007ffc5a470218 EFLAGS: 00000246 ORIG_RAX: 0000000000000108
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f45a6fc41c9
RDX: 0000000000000005 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 00007ffc5a470240 R08: 00007ffc5a470160 R09: 0000000020000080
R10: 00000000200001c0 R11: 0000000000000246 R12: 0000000000400bb0
R13: 00007ffc5a470320 R14: 0000000000000000 R15: 0000000000000000

The buggy address belongs to the page:
page:00000000440015ce refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x10beee
flags: 0x200000000000000()
raw: 0200000000000000 ffffea00043ff4c8 ffffea0004325608 0000000000000000
raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88810beee580: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88810beee600: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88810beee680: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                  ^
 ffff88810beee700: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88810beee780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
Disabling lock debugging due to kernel taint
ext4_rename_dir_prepare: [2] parent_de->inode=3537895424
ext4_rename_dir_prepare: [3] dir=0xffff888124170140
ext4_rename_dir_prepare: [4] ino=2
ext4_rename_dir_prepare: ent->dir->i_ino=2 parent=-757071872

Reason is first directory entry which 'rec_len' is 34478, then will get illegal
parent entry. Now, we do not check directory entry after read directory block
in 'ext4_get_first_dir_block'.
To solve this issue, check directory entry in 'ext4_get_first_dir_block'.

[ Trigger an ext4_error() instead of just warning if the directory is
  missing a '.' or '..' entry.   Also make sure we return an error code
  if the file system is corrupted.  -TYT ]

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220414025223.4113128-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3500,6 +3500,9 @@ static struct buffer_head *ext4_get_firs
 	struct buffer_head *bh;
 
 	if (!ext4_has_inline_data(inode)) {
+		struct ext4_dir_entry_2 *de;
+		unsigned int offset;
+
 		/* The first directory block must not be a hole, so
 		 * treat it as DIRENT_HTREE
 		 */
@@ -3508,9 +3511,30 @@ static struct buffer_head *ext4_get_firs
 			*retval = PTR_ERR(bh);
 			return NULL;
 		}
-		*parent_de = ext4_next_entry(
-					(struct ext4_dir_entry_2 *)bh->b_data,
-					inode->i_sb->s_blocksize);
+
+		de = (struct ext4_dir_entry_2 *) bh->b_data;
+		if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data,
+					 bh->b_size, 0) ||
+		    le32_to_cpu(de->inode) != inode->i_ino ||
+		    strcmp(".", de->name)) {
+			EXT4_ERROR_INODE(inode, "directory missing '.'");
+			brelse(bh);
+			*retval = -EFSCORRUPTED;
+			return NULL;
+		}
+		offset = ext4_rec_len_from_disk(de->rec_len,
+						inode->i_sb->s_blocksize);
+		de = ext4_next_entry(de, inode->i_sb->s_blocksize);
+		if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data,
+					 bh->b_size, offset) ||
+		    le32_to_cpu(de->inode) == 0 || strcmp("..", de->name)) {
+			EXT4_ERROR_INODE(inode, "directory missing '..'");
+			brelse(bh);
+			*retval = -EFSCORRUPTED;
+			return NULL;
+		}
+		*parent_de = de;
+
 		return bh;
 	}
 


