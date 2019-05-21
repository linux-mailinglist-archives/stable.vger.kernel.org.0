Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588B924933
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 09:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfEUHoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 03:44:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:37332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbfEUHoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 03:44:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DAB55AD12;
        Tue, 21 May 2019 07:44:05 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D0BED1E3C81; Tue, 21 May 2019 09:44:04 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/3] ext4: Wait for outstanding dio during truncate in nojournal mode
Date:   Tue, 21 May 2019 09:43:56 +0200
Message-Id: <20190521074358.17186-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190521074358.17186-1-jack@suse.cz>
References: <20190521074358.17186-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We didn't wait for outstanding direct IO during truncate in nojournal
mode (as we skip orphan handling in that case). This can lead to fs
corruption or stale data exposure if truncate ends up freeing blocks
and these get reallocated before direct IO finishes. Fix the condition
determining whether the wait is necessary.

CC: stable@vger.kernel.org
Fixes: 1c9114f9c0f1 ("ext4: serialize unlocked dio reads with truncate")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 82298c63ea6d..9bcb7f2b86dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5630,20 +5630,17 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				goto err_out;
 			}
 		}
-		if (!shrink)
+		if (!shrink) {
 			pagecache_isize_extended(inode, oldsize, inode->i_size);
-
-		/*
-		 * Blocks are going to be removed from the inode. Wait
-		 * for dio in flight.  Temporarily disable
-		 * dioread_nolock to prevent livelock.
-		 */
-		if (orphan) {
-			if (!ext4_should_journal_data(inode)) {
-				inode_dio_wait(inode);
-			} else
-				ext4_wait_for_tail_page_commit(inode);
+		} else {
+			/*
+			 * Blocks are going to be removed from the inode. Wait
+			 * for dio in flight.
+			 */
+			inode_dio_wait(inode);
 		}
+		if (orphan && ext4_should_journal_data(inode))
+			ext4_wait_for_tail_page_commit(inode);
 		down_write(&EXT4_I(inode)->i_mmap_sem);
 
 		rc = ext4_break_layouts(inode);
-- 
2.16.4

