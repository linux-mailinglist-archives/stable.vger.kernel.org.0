Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C2831FE7B
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 19:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBSSC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 13:02:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:33552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229743AbhBSSCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 13:02:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613757734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=aAcpCEvg+ZxJ5mjiDa3qT1YuqtZKVdyyU2KDk5CdNVg=;
        b=oybHGj61U50PAluuhUb5zWlfiaO3yLjshX0sw/51ZI1fWdOod/pRn0JkA1wS3ROIxkKaMu
        gvSyC77G8gRQA5eNwCKLrI8wObg1hchKCFBAUKUDfei0+amkZpxWRhg99kHic+CCAn5GT5
        enuEWlYjtPA8L8D467WHS9HO/Z5/0MA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CBFBCABAE;
        Fri, 19 Feb 2021 18:02:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2961DDA6FC; Fri, 19 Feb 2021 19:00:17 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     stable@vger.kernel.org
Cc:     wangyugui@e16-tech.com, David Sterba <dsterba@suse.cz>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: fix backport of 2175bf57dc952 in 5.10.13
Date:   Fri, 19 Feb 2021 19:00:16 +0100
Message-Id: <20210219180016.4759-1-dsterba@suse.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.cz>

There's a mistake in backport of upstream commit 2175bf57dc95 ("btrfs:
fix possible free space tree corruption with online conversion") as
5.10.13 commit 2175bf57dc95.

The enum value BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED has been added to the
wrong enum set, colliding with value of BTRFS_FS_QUOTA_ENABLE. This
could cause problems during the tree conversion, where the quotas
wouldn't be set up properly but the related code executed anyway due to
the bit set.

Link: https://lore.kernel.org/linux-btrfs/20210219111741.95DD.409509F4@e16-tech.com
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
CC: stable@vger.kernel.org # 5.10.13+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 30ea9780725f..b6884eda9ff6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -146,9 +146,6 @@ enum {
 	BTRFS_FS_STATE_DEV_REPLACING,
 	/* The btrfs_fs_info created for self-tests */
 	BTRFS_FS_STATE_DUMMY_FS_INFO,
-
-	/* Indicate that we can't trust the free space tree for caching yet */
-	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 #define BTRFS_BACKREF_REV_MAX		256
@@ -562,6 +559,9 @@ enum {
 
 	/* Indicate that the discard workqueue can service discards. */
 	BTRFS_FS_DISCARD_RUNNING,
+
+	/* Indicate that we can't trust the free space tree for caching yet */
+	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 /*
-- 
2.29.2

