Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06B59D3A9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbiHWIJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239247AbiHWIIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B22B865;
        Tue, 23 Aug 2022 01:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C08016125A;
        Tue, 23 Aug 2022 08:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF212C433D6;
        Tue, 23 Aug 2022 08:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241924;
        bh=w5L1OlnmPe1yAacwsnbfg9eGSD3IF23INkkqT0m3Q7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CK+x471BwzUaqPg5zU/oBCbPBKSozL1/ngCppUgiNaAGIPABNfTY/QczbpxggzZTL
         okuSlvsgX6Dow/nnQu4NKTZWeIU/PKgzPvo1GbvY8uug2OG6D2pLru3XxDtqK9VF6k
         HFeYoaq2de5AvT9SIyBF+/4cCoIDEEj9Vrey8TSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 021/365] btrfs: fix warning during log replay when bumping inode link count
Date:   Tue, 23 Aug 2022 09:58:42 +0200
Message-Id: <20220823080119.096900465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

commit 769030e11847c5412270c0726ff21d3a1f0a3131 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1459,7 +1459,7 @@ static int add_link(struct btrfs_trans_h
 	 * on the inode will not free it. We will fixup the link count later.
 	 */
 	if (other_inode->i_nlink == 0)
-		inc_nlink(other_inode);
+		set_nlink(other_inode, 1);
 add_link:
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
 			     name, namelen, 0, ref_index);
@@ -1602,7 +1602,7 @@ static noinline int add_inode_ref(struct
 				 * free it. We will fixup the link count later.
 				 */
 				if (!ret && inode->i_nlink == 0)
-					inc_nlink(inode);
+					set_nlink(inode, 1);
 			}
 			if (ret < 0)
 				goto out;


