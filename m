Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BD4BAAC3
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbfIVTah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392103AbfIVStO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594FF208C2;
        Sun, 22 Sep 2019 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178153;
        bh=BfTwByiLBOEtLAiKrDFm0+a1C2cPRfgHJQH9uMU+AJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqDreZYtQnCS3hIesWW+cCH4z+LduxQLbiFAuninchOD8BNydttvpvM49nk/1j3Pn
         Bjn+OZu1DkvM8xmZuFQBOwxvU42L2ww3HoFSm326SyzOZCKvskv8bYS8lkcFB6Mx9r
         XTDMOU8gg06k9tFPOxaoxK6hPXLBLtUxbfzA9F34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 199/203] btrfs: delayed-inode: Kill the BUG_ON() in btrfs_delete_delayed_dir_index()
Date:   Sun, 22 Sep 2019 14:43:45 -0400
Message-Id: <20190922184350.30563-199-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 933c22a7512c5c09b1fdc46b557384efe8d03233 ]

There is one report of fuzzed image which leads to BUG_ON() in
btrfs_delete_delayed_dir_index().

Although that fuzzed image can already be addressed by enhanced
extent-tree error handler, it's still better to hunt down more BUG_ON().

This patch will hunt down two BUG_ON()s in
btrfs_delete_delayed_dir_index():
- One for error from btrfs_delayed_item_reserve_metadata()
  Instead of BUG_ON(), we output an error message and free the item.
  And return the error.
  All callers of this function handles the error by aborting current
  trasaction.

- One for possible EEXIST from __btrfs_add_delayed_deletion_item()
  That function can return -EEXIST.
  We already have a good enough error message for that, only need to
  clean up the reserved metadata space and allocated item.

To help above cleanup, also modifiy __btrfs_remove_delayed_item() called
in btrfs_release_delayed_item(), to skip unassociated item.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203253
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 43fdb2992956a..6858a05606dd3 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -474,6 +474,9 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 	struct rb_root_cached *root;
 	struct btrfs_delayed_root *delayed_root;
 
+	/* Not associated with any delayed_node */
+	if (!delayed_item->delayed_node)
+		return;
 	delayed_root = delayed_item->delayed_node->root->fs_info->delayed_root;
 
 	BUG_ON(!delayed_root);
@@ -1525,7 +1528,12 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	 * we have reserved enough space when we start a new transaction,
 	 * so reserving metadata failure is impossible.
 	 */
-	BUG_ON(ret);
+	if (ret < 0) {
+		btrfs_err(trans->fs_info,
+"metadata reservation failed for delayed dir item deltiona, should have been reserved");
+		btrfs_release_delayed_item(item);
+		goto end;
+	}
 
 	mutex_lock(&node->mutex);
 	ret = __btrfs_add_delayed_deletion_item(node, item);
@@ -1534,7 +1542,8 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 			  "err add delayed dir index item(index: %llu) into the deletion tree of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
 			  index, node->root->root_key.objectid,
 			  node->inode_id, ret);
-		BUG();
+		btrfs_delayed_item_release_metadata(dir->root, item);
+		btrfs_release_delayed_item(item);
 	}
 	mutex_unlock(&node->mutex);
 end:
-- 
2.20.1

