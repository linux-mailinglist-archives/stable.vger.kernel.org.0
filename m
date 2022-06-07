Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F22540EF6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353178AbiFGS6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354103AbiFGSzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:55:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8433314B2D6;
        Tue,  7 Jun 2022 11:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F9CCB82182;
        Tue,  7 Jun 2022 18:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A02C385A5;
        Tue,  7 Jun 2022 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625038;
        bh=CGDqyVimsvSuCIDmx3Ut9j/d7HeAcS+e06cxIj+7Xfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9TpT6VXPELqGvnja8/OSMYSPmOHs8/O0owhc4xEYgTewSfD4QoJL3k7XKhtfRi+j
         Z93f0hArZRPvnU1J78PtoaZL5/Im3SRldvS1lJLj/ByrdqY/QSI369sVRJaC5D3iQ5
         7rIIJTN44/5MgQEHbaNw49a9B+MLF0n6aD5fZkQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 544/667] ext4: fix bug_on in ext4_writepages
Date:   Tue,  7 Jun 2022 19:03:29 +0200
Message-Id: <20220607164951.014233904@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

commit ef09ed5d37b84d18562b30cf7253e57062d0db05 upstream.

we got issue as follows:
EXT4-fs error (device loop0): ext4_mb_generate_buddy:1141: group 0, block bitmap and bg descriptor inconsistent: 25 vs 31513 free cls
------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:2708!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 2 PID: 2147 Comm: rep Not tainted 5.18.0-rc2-next-20220413+ #155
RIP: 0010:ext4_writepages+0x1977/0x1c10
RSP: 0018:ffff88811d3e7880 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88811c098000
RDX: 0000000000000000 RSI: ffff88811c098000 RDI: 0000000000000002
RBP: ffff888128140f50 R08: ffffffffb1ff6387 R09: 0000000000000000
R10: 0000000000000007 R11: ffffed10250281ea R12: 0000000000000001
R13: 00000000000000a4 R14: ffff88811d3e7bb8 R15: ffff888128141028
FS:  00007f443aed9740(0000) GS:ffff8883aef00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020007200 CR3: 000000011c2a4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_writepages+0x130/0x3a0
 filemap_fdatawrite_wbc+0x83/0xa0
 filemap_flush+0xab/0xe0
 ext4_alloc_da_blocks+0x51/0x120
 __ext4_ioctl+0x1534/0x3210
 __x64_sys_ioctl+0x12c/0x170
 do_syscall_64+0x3b/0x90

It may happen as follows:
1. write inline_data inode
vfs_write
  new_sync_write
    ext4_file_write_iter
      ext4_buffered_write_iter
        generic_perform_write
          ext4_da_write_begin
            ext4_da_write_inline_data_begin -> If inline data size too
            small will allocate block to write, then mapping will has
            dirty page
                ext4_da_convert_inline_data_to_extent ->clear EXT4_STATE_MAY_INLINE_DATA
2. fallocate
do_vfs_ioctl
  ioctl_preallocate
    vfs_fallocate
      ext4_fallocate
        ext4_convert_inline_data
          ext4_convert_inline_data_nolock
            ext4_map_blocks -> fail will goto restore data
            ext4_restore_inline_data
              ext4_create_inline_data
              ext4_write_inline_data
              ext4_set_inode_state -> set inode EXT4_STATE_MAY_INLINE_DATA
3. writepages
__ext4_ioctl
  ext4_alloc_da_blocks
    filemap_flush
      filemap_fdatawrite_wbc
        do_writepages
          ext4_writepages
            if (ext4_has_inline_data(inode))
              BUG_ON(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))

The root cause of this issue is we destory inline data until call
ext4_writepages under delay allocation mode.  But there maybe already
convert from inline to extent.  To solve this issue, we call
filemap_flush first..

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220516122634.1690462-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -2011,6 +2011,18 @@ int ext4_convert_inline_data(struct inod
 	if (!ext4_has_inline_data(inode)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 		return 0;
+	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		/*
+		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
+		 * cleared. This means we are in the middle of moving of
+		 * inline data to delay allocated block. Just force writeout
+		 * here to finish conversion.
+		 */
+		error = filemap_flush(inode->i_mapping);
+		if (error)
+			return error;
+		if (!ext4_has_inline_data(inode))
+			return 0;
 	}
 
 	needed_blocks = ext4_writepage_trans_blocks(inode);


