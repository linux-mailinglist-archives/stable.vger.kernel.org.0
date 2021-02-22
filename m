Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA49321674
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhBVMW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:22:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:37844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhBVMTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:19:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613996320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gOpSFNVBjTt/SOM3TpsbFAYQrrxDOza6wH16CpSs7w4=;
        b=G7uE8S0RJJrO9Ff+LpmFNvhBfG5HozZ8PAkS38a9vOg6wu0NWGgzbqLFUn4kZ0SkEwsqCp
        ZE7AhXxEcCznJPIPFKeHgD9IbRkFTHxOtxl1hCL3mhPqPQFeT79Oo/L1RQZnl8jwNNigu2
        tWbP+jODkYB4DGoLKo0o7zATtvLH5j4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83874AD5C;
        Mon, 22 Feb 2021 12:18:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7FDB5DA783; Mon, 22 Feb 2021 13:16:41 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.cz>,
        Wang Yugui <wangyugui@e16-tech.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: fix backport of 2175bf57dc952 in 5.4.95
Date:   Mon, 22 Feb 2021 13:16:39 +0100
Message-Id: <20210222121639.30086-1-dsterba@suse.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.cz>

There's a mistake in backport of upstream commit 2175bf57dc95 ("btrfs:
fix possible free space tree corruption with online conversion") as
5.4.95 commit e1ae9aab8029.

The enum value BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED has been added to the
wrong enum set, colliding with value of BTRFS_FS_QUOTA_ENABLE. This
could cause problems during the tree conversion, where the quotas
wouldn't be set up properly but the related code executed anyway due to
the bit set.

Link: https://lore.kernel.org/linux-btrfs/20210219111741.95DD.409509F4@e16-tech.com
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
CC: stable@vger.kernel.org # 5.4.95+
Signed-off-by: David Sterba <dsterba@suse.com>
---

This is same fix that went to 5.10.x, with refreshed diff so it applies
cleanly on 5.4.x and with updated references.

 fs/btrfs/ctree.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cda5534d3d0e..7960359dbc70 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -136,9 +136,6 @@ enum {
 	BTRFS_FS_STATE_DEV_REPLACING,
 	/* The btrfs_fs_info created for self-tests */
 	BTRFS_FS_STATE_DUMMY_FS_INFO,
-
-	/* Indicate that we can't trust the free space tree for caching yet */
-	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 #define BTRFS_BACKREF_REV_MAX		256
@@ -527,6 +524,9 @@ enum {
 	 * so we don't need to offload checksums to workqueues.
 	 */
 	BTRFS_FS_CSUM_IMPL_FAST,
+
+	/* Indicate that we can't trust the free space tree for caching yet */
+	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 struct btrfs_fs_info {
-- 
2.29.2

