Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB0664A83
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjAJSdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbjAJScc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67D926C0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30F9FCE18E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A2EC433F0;
        Tue, 10 Jan 2023 18:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375295;
        bh=/3KwFOJ60nPBxtXUUhxP/ONqDSzeo7ftJfRT7oq0bLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXdRrZn5jo8MxPF+8DZ2WpRNKFpPqS8buaBpWiFPmcwCdyuUgmthJ7fRcYiausFO6
         +g9/DBPL7b4Oo2zv2qkWsGLrVcLrWpYJhsJYtrxoYS7Teh6JWJT6B5UboZchqOkkxT
         VNlo85N4LCk7bcx0SessZw/Ar+mpPr+Ng3JK1tts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.15 143/290] ext4: fix use-after-free in ext4_orphan_cleanup
Date:   Tue, 10 Jan 2023 19:03:55 +0100
Message-Id: <20230110180036.779364397@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

commit a71248b1accb2b42e4980afef4fa4a27fa0e36f5 upstream.

I caught a issue as follows:
==================================================================
 BUG: KASAN: use-after-free in __list_add_valid+0x28/0x1a0
 Read of size 8 at addr ffff88814b13f378 by task mount/710

 CPU: 1 PID: 710 Comm: mount Not tainted 6.1.0-rc3-next #370
 Call Trace:
  <TASK>
  dump_stack_lvl+0x73/0x9f
  print_report+0x25d/0x759
  kasan_report+0xc0/0x120
  __asan_load8+0x99/0x140
  __list_add_valid+0x28/0x1a0
  ext4_orphan_cleanup+0x564/0x9d0 [ext4]
  __ext4_fill_super+0x48e2/0x5300 [ext4]
  ext4_fill_super+0x19f/0x3a0 [ext4]
  get_tree_bdev+0x27b/0x450
  ext4_get_tree+0x19/0x30 [ext4]
  vfs_get_tree+0x49/0x150
  path_mount+0xaae/0x1350
  do_mount+0xe2/0x110
  __x64_sys_mount+0xf0/0x190
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  </TASK>
 [...]
==================================================================

Above issue may happen as follows:
-------------------------------------
ext4_fill_super
  ext4_orphan_cleanup
   --- loop1: assume last_orphan is 12 ---
    list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan)
    ext4_truncate --> return 0
      ext4_inode_attach_jinode --> return -ENOMEM
    iput(inode) --> free inode<12>
   --- loop2: last_orphan is still 12 ---
    list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
    // use inode<12> and trigger UAF

To solve this issue, we need to propagate the return value of
ext4_inode_attach_jinode() appropriately.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221102080633.1630225-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4198,7 +4198,8 @@ int ext4_truncate(struct inode *inode)
 
 	/* If we zero-out tail of the page, we have to create jinode for jbd2 */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
-		if (ext4_inode_attach_jinode(inode) < 0)
+		err = ext4_inode_attach_jinode(inode);
+		if (err)
 			goto out_trace;
 	}
 


