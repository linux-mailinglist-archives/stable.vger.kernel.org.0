Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58938F0341
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 17:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390366AbfKEQon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 11:44:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:41612 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390352AbfKEQok (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 11:44:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C629AB1B8;
        Tue,  5 Nov 2019 16:44:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3B8651E4AB5; Tue,  5 Nov 2019 17:44:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 06/25] ext4: Fix credit estimate for final inode freeing
Date:   Tue,  5 Nov 2019 17:44:12 +0100
Message-Id: <20191105164437.32602-6-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Estimate for the number of credits needed for final freeing of inode in
ext4_evict_inode() was to small. We may modify 4 blocks (inode & sb for
orphan deletion, bitmap & group descriptor for inode freeing) and not
just 3.

Fixes: e50e5129f384 ("ext4: xattr-in-inode support")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 516faa280ced..81bc2fb23c40 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -196,7 +196,12 @@ void ext4_evict_inode(struct inode *inode)
 {
 	handle_t *handle;
 	int err;
-	int extra_credits = 3;
+	/*
+	 * Credits for final inode cleanup and freeing:
+	 * sb + inode (ext4_orphan_del()), block bitmap, group descriptor
+	 * (xattr block freeing), bitmap, group descriptor (inode freeing)
+	 */
+	int extra_credits = 6;
 	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	trace_ext4_evict_inode(inode);
@@ -252,8 +257,12 @@ void ext4_evict_inode(struct inode *inode)
 	if (!IS_NOQUOTA(inode))
 		extra_credits += EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb);
 
+	/*
+	 * Block bitmap, group descriptor, and inode are accounted in both
+ 	 * ext4_blocks_for_truncate() and extra_credits. So subtract 3.
+	 */
 	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE,
-				 ext4_blocks_for_truncate(inode)+extra_credits);
+			 ext4_blocks_for_truncate(inode) + extra_credits - 3);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
-- 
2.16.4

