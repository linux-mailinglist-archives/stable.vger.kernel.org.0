Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A815AB0E4
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiIBNAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238706AbiIBM7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4DFE1169;
        Fri,  2 Sep 2022 05:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AFDEB829E2;
        Fri,  2 Sep 2022 12:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63570C433D6;
        Fri,  2 Sep 2022 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121983;
        bh=4J2RiHe3cklBVvQ7Q0ymDh9jBYM6rHYOk5ssfRlrWjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7hma8lJh5p108NKJvUTFGcy9HGYW1JNrTlzmlt0kMfvWsYRp6YSzBeH1Qyr9RIyS
         yxNhChxngxl+isLxHkvbDgCpJQiUrnkETH9Uhy5+dNCHjhtCprNnxsi4VcqSWkO/Wz
         AkfScc3u0OZ8GkfnAEpYlwCOHTIXpkB7o0Bwd7ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/73] btrfs: fix warning during log replay when bumping inode link count
Date:   Fri,  2 Sep 2022 14:19:13 +0200
Message-Id: <20220902121406.068166289@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 769030e11847c5412270c0726ff21d3a1f0a3131 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c56a89d224bbb..7272896587302 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1444,7 +1444,7 @@ static int add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	 * on the inode will not free it. We will fixup the link count later.
 	 */
 	if (other_inode->i_nlink == 0)
-		inc_nlink(other_inode);
+		set_nlink(other_inode, 1);
 add_link:
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
 			     name, namelen, 0, ref_index);
@@ -1587,7 +1587,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				 * free it. We will fixup the link count later.
 				 */
 				if (!ret && inode->i_nlink == 0)
-					inc_nlink(inode);
+					set_nlink(inode, 1);
 			}
 			if (ret < 0)
 				goto out;
-- 
2.35.1



