Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6471F5FFF23
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiJPM1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJPM1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:27:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8AD3641A
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 05:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 936C0B802C3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 12:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0627CC433C1;
        Sun, 16 Oct 2022 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665923238;
        bh=TIyGkPZ7m5uYYIymzNw7TFCtuer6K7/SBh3sBeA2NVU=;
        h=Subject:To:Cc:From:Date:From;
        b=Y4FCOv+V4D0PtzMT34DVjl5dL+ePON7qQNjYcJmSZsYA2RVfz9r53muDAIBxD4omR
         7BD1rQP2bfDO2MaWYvpYkmuLr0zcEmxy2CJcZta853rn7UiEkgb9/8rP/BqNjmDdkW
         K/U75MB0Q+LELd2JxERmacejmgUdeU6RVXMw00rE=
Subject: FAILED: patch "[PATCH] btrfs: set generation before calling btrfs_clean_tree_block" failed to apply to 5.4-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, dsterba@suse.com,
        syzbot+fba8e2116a12609b6c59@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 14:28:04 +0200
Message-ID: <1665923284126239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

cbddcc4fa344 ("btrfs: set generation before calling btrfs_clean_tree_block in btrfs_init_new_buffer")
b40130b23ca4 ("btrfs: fix lockdep splat with reloc root extent buffers")
0a27a0474d14 ("btrfs: move lockdep class helpers to locking.c")
b4be6aefa73c ("btrfs: do not start relocation until in progress drops are done")
fdfbf020664b ("btrfs: rework async transaction committing")
54230013d41f ("btrfs: get rid of root->orphan_cleanup_state")
ae5d29d4e70a ("btrfs: inline wait_current_trans_commit_start in its caller")
32cc4f8759e1 ("btrfs: sink wait_for_unblock parameter to async commit")
e9306ad4ef5c ("btrfs: more graceful errors/warnings on 32bit systems when reaching limits")
bc03f39ec3c1 ("btrfs: use a bit to track the existence of tree mod log users")
406808ab2f0b ("btrfs: use booleans where appropriate for the tree mod log functions")
f3a84ccd28d0 ("btrfs: move the tree mod log code into its own file")
dbcc7d57bffc ("btrfs: fix race when cloning extent buffer during rewind of an old root")
cac06d843f25 ("btrfs: introduce the skeleton of btrfs_subpage structure")
2f96e40212d4 ("btrfs: fix possible free space tree corruption with online conversion")
1aaac38c83a2 ("btrfs: don't allow tree block to cross page boundary for subpage support")
948462294577 ("btrfs: keep sb cache_generation consistent with space_cache")
8b228324a8ce ("btrfs: clear free space tree on ro->rw remount")
8cd2908846d1 ("btrfs: clear oneshot options on mount and remount")
5011139a4718 ("btrfs: create free space tree on ro->rw remount")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cbddcc4fa3443fe8cfb2ff8e210deb1f6a0eea38 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 20 Sep 2022 22:43:51 +0900
Subject: [PATCH] btrfs: set generation before calling btrfs_clean_tree_block
 in btrfs_init_new_buffer

syzbot is reporting uninit-value in btrfs_clean_tree_block() [1], for
commit bc877d285ca3dba2 ("btrfs: Deduplicate extent_buffer init code")
missed that btrfs_set_header_generation() in btrfs_init_new_buffer() must
not be moved to after clean_tree_block() because clean_tree_block() is
calling btrfs_header_generation() since commit 55c69072d6bd5be1 ("Btrfs:
Fix extent_buffer usage when nodesize != leafsize").

Since memzero_extent_buffer() will reset "struct btrfs_header" part, we
can't move btrfs_set_header_generation() to before memzero_extent_buffer().
Just re-add btrfs_set_header_generation() before btrfs_clean_tree_block().

Link: https://syzkaller.appspot.com/bug?extid=fba8e2116a12609b6c59 [1]
Reported-by: syzbot <syzbot+fba8e2116a12609b6c59@syzkaller.appspotmail.com>
Fixes: bc877d285ca3dba2 ("btrfs: Deduplicate extent_buffer init code")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ae94be318a0f..cd2d36580f1a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4890,6 +4890,9 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	    !test_bit(BTRFS_ROOT_RESET_LOCKDEP_CLASS, &root->state))
 		lockdep_owner = BTRFS_FS_TREE_OBJECTID;
 
+	/* btrfs_clean_tree_block() accesses generation field. */
+	btrfs_set_header_generation(buf, trans->transid);
+
 	/*
 	 * This needs to stay, because we could allocate a freed block from an
 	 * old tree into a new tree, so we need to make sure this new block is

