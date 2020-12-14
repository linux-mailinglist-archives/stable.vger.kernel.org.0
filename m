Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D32D9ECD
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440767AbgLNSSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502353AbgLNRi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 059/105] btrfs: do nofs allocations when adding and removing qgroup relations
Date:   Mon, 14 Dec 2020 18:28:33 +0100
Message-Id: <20201214172558.109375093@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



