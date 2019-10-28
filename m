Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB53E6C8A
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 07:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbfJ1Gv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 02:51:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:47496 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731998AbfJ1Gv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 02:51:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 206B7AF83;
        Mon, 28 Oct 2019 06:51:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: tracepoints: Fix wrong parameter order for qgroup events
Date:   Mon, 28 Oct 2019 14:51:49 +0800
Message-Id: <20191028065149.89155-2-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028065149.89155-1-wqu@suse.com>
References: <20191028065149.89155-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fd2b007eaec898564e269d1f478a2da0380ecf51 upstream.

[BUG]
For btrfs:qgroup_meta_reserve event, the trace event can output garbage:

  qgroup_meta_reserve: 9c7f6acc-b342-4037-bc47-7f6e4d2232d7: refroot=5(FS_TREE) type=DATA diff=2

The diff should always be alinged to sector size (4k), so there is
definitely something wrong.

[CAUSE]
For the wrong @diff, it's caused by wrong parameter order.
The correct parameters are:

  struct btrfs_root, s64 diff, int type.

However the parameters used are:

  struct btrfs_root, int type, s64 diff.

Fixes: 4ee0d8832c2e ("btrfs: qgroup: Update trace events for metadata reservation")
CC: stable@vger.kernel.org # 4.19
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
[Fix conflcits caused by parameter refactor]
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3ea2008dcde3..cdd6d5021000 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3259,7 +3259,7 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 		return 0;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, type, (s64)num_bytes);
+	trace_qgroup_meta_reserve(root, (s64)num_bytes, type);
 	ret = qgroup_reserve(root, num_bytes, enforce, type);
 	if (ret < 0)
 		return ret;
@@ -3306,7 +3306,7 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 	 */
 	num_bytes = sub_root_meta_rsv(root, num_bytes, type);
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, type, -(s64)num_bytes);
+	trace_qgroup_meta_reserve(root, -(s64)num_bytes, type);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes, type);
 }
 
-- 
2.23.0

