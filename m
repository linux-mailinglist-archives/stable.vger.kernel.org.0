Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD762CD7EA
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436576AbgLCNa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436466AbgLCNaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:23 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 24/39] btrfs: do nofs allocations when adding and removing qgroup relations
Date:   Thu,  3 Dec 2020 08:28:18 -0500
Message-Id: <20201203132834.930999-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7aa6d359845a9dbf7ad90b0b1b6347ef4764621f ]

When adding or removing a qgroup relation we are doing a GFP_KERNEL
allocation which is not safe because we are holding a transaction
handle open and that can make us deadlock if the allocator needs to
recurse into the filesystem. So just surround those calls with a
nofs context.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9205a88f2a881..15c38803576ce 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/btrfs.h>
+#include <linux/sched/mm.h>
 
 #include "ctree.h"
 #include "transaction.h"
@@ -1324,13 +1325,17 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	struct btrfs_qgroup *member;
 	struct btrfs_qgroup_list *list;
 	struct ulist *tmp;
+	unsigned int nofs_flag;
 	int ret = 0;
 
 	/* Check the level of src and dst first */
 	if (btrfs_qgroup_level(src) >= btrfs_qgroup_level(dst))
 		return -EINVAL;
 
+	/* We hold a transaction handle open, must do a NOFS allocation. */
+	nofs_flag = memalloc_nofs_save();
 	tmp = ulist_alloc(GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1387,10 +1392,14 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	struct btrfs_qgroup_list *list;
 	struct ulist *tmp;
 	bool found = false;
+	unsigned int nofs_flag;
 	int ret = 0;
 	int ret2;
 
+	/* We hold a transaction handle open, must do a NOFS allocation. */
+	nofs_flag = memalloc_nofs_save();
 	tmp = ulist_alloc(GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 	if (!tmp)
 		return -ENOMEM;
 
-- 
2.27.0

