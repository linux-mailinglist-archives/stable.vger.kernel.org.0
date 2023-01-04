Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD9765D929
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbjADQWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239979AbjADQWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9750C756
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 877E7B817B8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A32C433EF;
        Wed,  4 Jan 2023 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849319;
        bh=wiAIjIg6fyEs03sUJS9d08v2ut1gRznqaNxm/J16Kq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZ9ffdrzttkO/vaCHCN8rdeq7p3fj1tBt4a04pTZgRybqLDlxIVpKTOzJPBup/zIX
         Ka1jH54M6kzwwSer22U7r7UoAnw3BU2QF5axXM3UQryEYvNuP590twekx4rFWUtlzs
         CIcFP4srW34hLdk5gKerns302m+CRGeR6TPa5JRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 161/207] ext4: silence the warning when evicting inode with dioread_nolock
Date:   Wed,  4 Jan 2023 17:06:59 +0100
Message-Id: <20230104160516.990584588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

commit bc12ac98ea2e1b70adc6478c8b473a0003b659d3 upstream.

When evicting an inode with default dioread_nolock, it could be raced by
the unwritten extents converting kworker after writeback some new
allocated dirty blocks. It convert unwritten extents to written, the
extents could be merged to upper level and free extent blocks, so it
could mark the inode dirty again even this inode has been marked
I_FREEING. But the inode->i_io_list check and warning in
ext4_evict_inode() missing this corner case. Fortunately,
ext4_evict_inode() will wait all extents converting finished before this
check, so it will not lead to inode use-after-free problem, every thing
is OK besides this warning. The WARN_ON_ONCE was originally designed
for finding inode use-after-free issues in advance, but if we add
current dioread_nolock case in, it will become not quite useful, so fix
this warning by just remove this check.

 ======
 WARNING: CPU: 7 PID: 1092 at fs/ext4/inode.c:227
 ext4_evict_inode+0x875/0xc60
 ...
 RIP: 0010:ext4_evict_inode+0x875/0xc60
 ...
 Call Trace:
  <TASK>
  evict+0x11c/0x2b0
  iput+0x236/0x3a0
  do_unlinkat+0x1b4/0x490
  __x64_sys_unlinkat+0x4c/0xb0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x7fa933c1115b
 ======

rm                          kworker
                            ext4_end_io_end()
vfs_unlink()
 ext4_unlink()
                             ext4_convert_unwritten_io_end_vec()
                              ext4_convert_unwritten_extents()
                               ext4_map_blocks()
                                ext4_ext_map_blocks()
                                 ext4_ext_try_to_merge_up()
                                  __mark_inode_dirty()
                                   check !I_FREEING
                                   locked_inode_to_wb_and_lock_list()
 iput()
  iput_final()
   evict()
    ext4_evict_inode()
     truncate_inode_pages_final() //wait release io_end
                                    inode_io_list_move_locked()
                             ext4_release_io_end()
     trigger WARN_ON_ONCE()

Cc: stable@kernel.org
Fixes: ceff86fddae8 ("ext4: Avoid freeing inodes on dirty list")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220629112647.4141034-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -222,13 +222,13 @@ void ext4_evict_inode(struct inode *inod
 
 	/*
 	 * For inodes with journalled data, transaction commit could have
-	 * dirtied the inode. Flush worker is ignoring it because of I_FREEING
-	 * flag but we still need to remove the inode from the writeback lists.
+	 * dirtied the inode. And for inodes with dioread_nolock, unwritten
+	 * extents converting worker could merge extents and also have dirtied
+	 * the inode. Flush worker is ignoring it because of I_FREEING flag but
+	 * we still need to remove the inode from the writeback lists.
 	 */
-	if (!list_empty_careful(&inode->i_io_list)) {
-		WARN_ON_ONCE(!ext4_should_journal_data(inode));
+	if (!list_empty_careful(&inode->i_io_list))
 		inode_io_list_del(inode);
-	}
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any


