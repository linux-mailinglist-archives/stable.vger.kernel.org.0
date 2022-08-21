Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B649E59B426
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiHUNzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiHUNzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:55:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11B9167FC
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81D8FB80D78
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95DEC433C1;
        Sun, 21 Aug 2022 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661090104;
        bh=Q+2wh9pCrPqjdcjiXo/m+850Wv4bpA8bZXlCu4ovjUs=;
        h=Subject:To:Cc:From:Date:From;
        b=nJy+xUCsOo5iYrXTgtXqfM++kv2hLfAEsRYjLvB/Cg9pOEA3grDN204TD1EHzJ8dD
         N+lAw/nZpSdUb5JJIh4z0pcks/jRHt+JmJ1ysp6zF3UfcYGsDrcx12rSQngQFkWqDm
         Ia3fHVAYo+CWgpNbPzUtlLSq+bvt7M7XiIT++L9U=
Subject: FAILED: patch "[PATCH] btrfs: fix warning during log replay when bumping inode link" failed to apply to 5.10-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:55:00 +0200
Message-ID: <166109010066144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 769030e11847c5412270c0726ff21d3a1f0a3131 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 1 Aug 2022 14:57:52 +0100
Subject: [PATCH] btrfs: fix warning during log replay when bumping inode link
 count

During log replay, at add_link(), we may increment the link count of
another inode that has a reference that conflicts with a new reference
for the inode currently being processed.

During log replay, at add_link(), we may drop (unlink) a reference from
some inode in the subvolume tree if that reference conflicts with a new
reference found in the log for the inode we are currently processing.

After the unlink, If the link count has decreased from 1 to 0, then we
increment the link count to prevent the inode from being deleted if it's
evicted by an iput() call, because we may have references to add to that
inode later on (and we will fixup its link count later during log replay).

However incrementing the link count from 0 to 1 triggers a warning:

  $ cat fs/inode.c
  (...)
  void inc_nlink(struct inode *inode)
  {
        if (unlikely(inode->i_nlink == 0)) {
                 WARN_ON(!(inode->i_state & I_LINKABLE));
                 atomic_long_dec(&inode->i_sb->s_remove_count);
        }
  (...)

The I_LINKABLE flag is only set when creating an O_TMPFILE file, so it's
never set during log replay.

Most of the time, the warning isn't triggered even if we dropped the last
reference of the conflicting inode, and this is because:

1) The conflicting inode was previously marked for fixup, through a call
   to link_to_fixup_dir(), which increments the inode's link count;

2) And the last iput() on the inode has not triggered eviction of the
   inode, nor was eviction triggered after the iput(). So at add_link(),
   even if we unlink the last reference of the inode, its link count ends
   up being 1 and not 0.

So this means that if eviction is triggered after link_to_fixup_dir() is
called, at add_link() we will read the inode back from the subvolume tree
and have it with a correct link count, matching the number of references
it has on the subvolume tree. So if when we are at add_link() the inode
has exactly one reference only, its link count is 1, and after the unlink
its link count becomes 0.

So fix this by using set_nlink() instead of inc_nlink(), as the former
accepts a transition from 0 to 1 and it's what we use in other similar
contexts (like at link_to_fixup_dir().

Also make add_inode_ref() use set_nlink() instead of inc_nlink() to
bump the link count from 0 to 1.

The warning is actually harmless, but it may scare users. Josef also ran
into it recently.

CC: stable@vger.kernel.org # 5.1+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c1fdd6ef3f4a..9205c4a5ca81 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1459,7 +1459,7 @@ static int add_link(struct btrfs_trans_handle *trans,
 	 * on the inode will not free it. We will fixup the link count later.
 	 */
 	if (other_inode->i_nlink == 0)
-		inc_nlink(other_inode);
+		set_nlink(other_inode, 1);
 add_link:
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
 			     name, namelen, 0, ref_index);
@@ -1602,7 +1602,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				 * free it. We will fixup the link count later.
 				 */
 				if (!ret && inode->i_nlink == 0)
-					inc_nlink(inode);
+					set_nlink(inode, 1);
 			}
 			if (ret < 0)
 				goto out;

