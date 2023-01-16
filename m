Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D56B66CC2F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjAPRW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbjAPRWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C303139BAC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F3361055
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE23C433F1;
        Mon, 16 Jan 2023 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888425;
        bh=dYmxdOo64on5SBN8J7ULe0ev9JFB25rzQVw3Y0USdH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXU09mCrBEcG+5TUghskzjiDXI/Vdv/rGKIWMrvoWe3sjywfGLxnBmyYRE+6Vs5+u
         VDwQxtl8T+jZlpbQepUF4su2cZuAPNg4NEMSwzbe+IOSvxAQVtQDaF2WQT8/rIFqjN
         sHwQR5pyV+mFJWnYUswiyNgYCPPnwvFjuYT0aYos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 494/521] ext4: fix use-after-free in ext4_orphan_cleanup
Date:   Mon, 16 Jan 2023 16:52:36 +0100
Message-Id: <20230116154909.292798236@linuxfoundation.org>
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

[ Upstream commit a71248b1accb2b42e4980afef4fa4a27fa0e36f5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 16d2b88bc66d..3c7bbdaa425a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4568,7 +4568,8 @@ int ext4_truncate(struct inode *inode)
 
 	/* If we zero-out tail of the page, we have to create jinode for jbd2 */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
-		if (ext4_inode_attach_jinode(inode) < 0)
+		err = ext4_inode_attach_jinode(inode);
+		if (err)
 			goto out_trace;
 	}
 
-- 
2.35.1



