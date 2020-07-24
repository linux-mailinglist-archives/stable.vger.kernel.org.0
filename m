Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797C822BBCD
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 04:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgGXCAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 22:00:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:46896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgGXCAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 22:00:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CB33BB130;
        Fri, 24 Jul 2020 02:00:43 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: reloc: clear DEAD_RELOC_TREE bit for orphan roots to prevent runaway balance
Date:   Fri, 24 Jul 2020 10:00:26 +0800
Message-Id: <20200724020027.31751-2-wqu@suse.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724020027.31751-1-wqu@suse.com>
References: <20200724020027.31751-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1dae7e0e58b484eaa43d530f211098fdeeb0f404 upstream.

[BUG]
There are several reported runaway balance, that balance is flooding the
log with "found X extents" where the X never changes.

[CAUSE]
Commit d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after
merge_reloc_roots") introduced BTRFS_ROOT_DEAD_RELOC_TREE bit to
indicate that one subvolume has finished its tree blocks swap with its
reloc tree.

However if balance is canceled or hits ENOSPC halfway, we didn't clear
the BTRFS_ROOT_DEAD_RELOC_TREE bit, leaving that bit hanging forever
until unmount.

Any subvolume root with that bit, would cause backref cache to skip this
tree block, as it has finished its tree block swap.  This would cause
all tree blocks of that root be ignored by balance, leading to runaway
balance.

[FIX]
Fix the problem by also clearing the BTRFS_ROOT_DEAD_RELOC_TREE bit for
the original subvolume of orphan reloc root.

Add an umount check for the stale bit still set.

Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Qu Wenruo <wqu@suse.com>
[Manually solve the conflicts due to no btrfs root refs rework]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/relocation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3f8c706d75ee..1b087ee338cc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2540,6 +2540,8 @@ void merge_reloc_roots(struct reloc_control *rc)
 			if (!IS_ERR(root)) {
 				if (root->reloc_root == reloc_root)
 					root->reloc_root = NULL;
+				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
+					  &root->state);
 			}
 
 			list_del_init(&reloc_root->root_list);
-- 
2.27.0

