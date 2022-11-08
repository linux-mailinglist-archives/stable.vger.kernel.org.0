Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94AF06213C6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiKHNyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbiKHNxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:53:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DC04875C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5239DB816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D69C433D6;
        Tue,  8 Nov 2022 13:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915613;
        bh=UvkE7+5722kX7uzNmFqcCVexgbfVn3gbWsC8eBYHWjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvR4dudM5EO1tCqyxYCPDRkVmUXaQHmGqVLRc0mzbIEiN56Pzed8whZbsBU8WTgnk
         4QIP1L9Om9BYk4Y/YYbOd9hFn5blJgUa7Sd4ILYcX5Y0d+FsLxTFQZewmwe91tj3oC
         eko26ESGTeGPV2JvSYO3jY7dPUYtXGL2MjJ62omU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/118] btrfs: fix inode list leak during backref walking at find_parent_nodes()
Date:   Tue,  8 Nov 2022 14:38:38 +0100
Message-Id: <20221108133342.415117152@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 92876eec382a0f19f33d09d2c939e9ca49038ae5 ]

During backref walking, at find_parent_nodes(), if we are dealing with a
data extent and we get an error while resolving the indirect backrefs, at
resolve_indirect_refs(), or in the while loop that iterates over the refs
in the direct refs rbtree, we end up leaking the inode lists attached to
the direct refs we have in the direct refs rbtree that were not yet added
to the refs ulist passed as argument to find_parent_nodes(). Since they
were not yet added to the refs ulist and prelim_release() does not free
the lists, on error the caller can only free the lists attached to the
refs that were added to the refs ulist, all the remaining refs get their
inode lists never freed, therefore leaking their memory.

Fix this by having prelim_release() always free any attached inode list
to each ref found in the rbtree, and have find_parent_nodes() set the
ref's inode list to NULL once it transfers ownership of the inode list
to a ref added to the refs ulist passed to find_parent_nodes().

Fixes: 86d5f9944252 ("btrfs: convert prelimary reference tracking to use rbtrees")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 70c1c15266d6..6942707f8b03 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -288,8 +288,10 @@ static void prelim_release(struct preftree *preftree)
 	struct prelim_ref *ref, *next_ref;
 
 	rbtree_postorder_for_each_entry_safe(ref, next_ref,
-					     &preftree->root.rb_root, rbnode)
+					     &preftree->root.rb_root, rbnode) {
+		free_inode_elem_list(ref->inode_list);
 		free_pref(ref);
+	}
 
 	preftree->root = RB_ROOT_CACHED;
 	preftree->count = 0;
@@ -1388,6 +1390,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				if (ret < 0)
 					goto out;
 				ref->inode_list = eie;
+				/*
+				 * We transferred the list ownership to the ref,
+				 * so set to NULL to avoid a double free in case
+				 * an error happens after this.
+				 */
+				eie = NULL;
 			}
 			ret = ulist_add_merge_ptr(refs, ref->parent,
 						  ref->inode_list,
@@ -1413,6 +1421,14 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				eie->next = ref->inode_list;
 			}
 			eie = NULL;
+			/*
+			 * We have transferred the inode list ownership from
+			 * this ref to the ref we added to the 'refs' ulist.
+			 * So set this ref's inode list to NULL to avoid
+			 * use-after-free when our caller uses it or double
+			 * frees in case an error happens before we return.
+			 */
+			ref->inode_list = NULL;
 		}
 		cond_resched();
 	}
-- 
2.35.1



