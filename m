Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672473D32FD
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhGWDTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233609AbhGWDS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7873060F25;
        Fri, 23 Jul 2021 03:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012743;
        bh=iwY2UIX29yvhgYYsGAvG5Ti4MqpDN7jWYSdzmf6P4uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/3JTu4+AeY1S3ANPX0uv7yie1pz8l8tIUiQHjtq28cFdvK4624wL6cGQg6u4+CWW
         YQfT9FzuUswPd5MZWxLqRbrZVZxBiDyz9CX5xkpcaie88qCA0xUIBQ7mf06yj/nmS1
         yP/ApYvcdPwK1CJTc/hpuwygFtSGLjfHe2pGVqe1wvM8tpZjMoV+OKUPnc0r+mvf//
         pBwrrSJcbIImhgKfr4VIzB1b3R3F2nPFLLPn2c06QpQNlFTsOJuE/FQhGqXYB0ZEIh
         2c4Hia8EUKDqSam5c0IQYTv3jxXjt6rQRowM1CSrqkAduGXZ6YEhxx9D3K8od+Ymln
         mIGrgMIV9C9tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        syzbot+b718ec84a87b7e73ade4@syzkaller.appspotmail.com,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 7/8] hfs: add lock nesting notation to hfs_find_init
Date:   Thu, 22 Jul 2021 23:58:51 -0400
Message-Id: <20210723035852.532303-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035852.532303-1-sashal@kernel.org>
References: <20210723035852.532303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit b3b2177a2d795e35dc11597b2609eb1e7e57e570 ]

Syzbot reports a possible recursive lock in [1].

This happens due to missing lock nesting information.  From the logs, we
see that a call to hfs_fill_super is made to mount the hfs filesystem.
While searching for the root inode, the lock on the catalog btree is
grabbed.  Then, when the parent of the root isn't found, a call to
__hfs_bnode_create is made to create the parent of the root.  This
eventually leads to a call to hfs_ext_read_extent which grabs a lock on
the extents btree.

Since the order of locking is catalog btree -> extents btree, this lock
hierarchy does not lead to a deadlock.

To tell lockdep that this locking is safe, we add nesting notation to
distinguish between catalog btrees, extents btrees, and attributes
btrees (for HFS+).  This has already been done in hfsplus.

Link: https://syzkaller.appspot.com/bug?id=f007ef1d7a31a469e3be7aeb0fde0769b18585db [1]
Link: https://lkml.kernel.org/r/20210701030756.58760-4-desmondcheongzx@gmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reported-by: syzbot+b718ec84a87b7e73ade4@syzkaller.appspotmail.com
Tested-by: syzbot+b718ec84a87b7e73ade4@syzkaller.appspotmail.com
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/bfind.c | 14 +++++++++++++-
 fs/hfs/btree.h |  7 +++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/hfs/bfind.c b/fs/hfs/bfind.c
index 4af318fbda77..ef9498a6e88a 100644
--- a/fs/hfs/bfind.c
+++ b/fs/hfs/bfind.c
@@ -25,7 +25,19 @@ int hfs_find_init(struct hfs_btree *tree, struct hfs_find_data *fd)
 	fd->key = ptr + tree->max_key_len + 2;
 	hfs_dbg(BNODE_REFS, "find_init: %d (%p)\n",
 		tree->cnid, __builtin_return_address(0));
-	mutex_lock(&tree->tree_lock);
+	switch (tree->cnid) {
+	case HFS_CAT_CNID:
+		mutex_lock_nested(&tree->tree_lock, CATALOG_BTREE_MUTEX);
+		break;
+	case HFS_EXT_CNID:
+		mutex_lock_nested(&tree->tree_lock, EXTENTS_BTREE_MUTEX);
+		break;
+	case HFS_ATTR_CNID:
+		mutex_lock_nested(&tree->tree_lock, ATTR_BTREE_MUTEX);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
index dcc2aab1b2c4..25ac9a8bb57a 100644
--- a/fs/hfs/btree.h
+++ b/fs/hfs/btree.h
@@ -13,6 +13,13 @@ typedef int (*btree_keycmp)(const btree_key *, const btree_key *);
 
 #define NODE_HASH_SIZE  256
 
+/* B-tree mutex nested subclasses */
+enum hfs_btree_mutex_classes {
+	CATALOG_BTREE_MUTEX,
+	EXTENTS_BTREE_MUTEX,
+	ATTR_BTREE_MUTEX,
+};
+
 /* A HFS BTree held in memory */
 struct hfs_btree {
 	struct super_block *sb;
-- 
2.30.2

