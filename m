Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5473CB1A8
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbfJCWFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:05:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:49626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731123AbfJCWFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 18:05:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CA23B11A;
        Thu,  3 Oct 2019 22:05:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 145BC1E4816; Fri,  4 Oct 2019 00:06:14 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 04/22] ext4: Fix credit estimate for final inode freeing
Date:   Fri,  4 Oct 2019 00:05:50 +0200
Message-Id: <20191003220613.10791-4-jack@suse.cz>
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
 fs/ext4/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 516faa280ced..e6b631d50c26 100644
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
+	 * (xattr block freeind), bitmap, group descriptor (inode freeing)
+	 */
+	int extra_credits = 6;
 	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	trace_ext4_evict_inode(inode);
-- 
2.16.4

