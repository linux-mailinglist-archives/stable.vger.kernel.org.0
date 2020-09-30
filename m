Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A523127EC25
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 17:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3PQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 11:16:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:47390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgI3PQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 11:16:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4B441AFBB;
        Wed, 30 Sep 2020 15:16:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EE7011E0EAA; Wed, 30 Sep 2020 17:16:19 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <reiserfs-devel@vger.kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] reiserfs: Fix oops during mount
Date:   Wed, 30 Sep 2020 17:16:16 +0200
Message-Id: <20200930151616.13466-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With suitably crafted reiserfs image and mount command reiserfs will
crash when trying to verify that XATTR_ROOT directory can be looked up
in / as that recurses back to xattr code like:

 xattr_lookup+0x24/0x280 fs/reiserfs/xattr.c:395
 reiserfs_xattr_get+0x89/0x540 fs/reiserfs/xattr.c:677
 reiserfs_get_acl+0x63/0x690 fs/reiserfs/xattr_acl.c:209
 get_acl+0x152/0x2e0 fs/posix_acl.c:141
 check_acl fs/namei.c:277 [inline]
 acl_permission_check fs/namei.c:309 [inline]
 generic_permission+0x2ba/0x550 fs/namei.c:353
 do_inode_permission fs/namei.c:398 [inline]
 inode_permission+0x234/0x4a0 fs/namei.c:463
 lookup_one_len+0xa6/0x200 fs/namei.c:2557
 reiserfs_lookup_privroot+0x85/0x1e0 fs/reiserfs/xattr.c:972
 reiserfs_fill_super+0x2b51/0x3240 fs/reiserfs/super.c:2176
 mount_bdev+0x24f/0x360 fs/super.c:1417

Fix the problem by bailing from reiserfs_xattr_get() when xattrs are not
yet initialized.

CC: stable@vger.kernel.org
Reported-by: syzbot+9b33c9b118d77ff59b6f@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/xattr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 28b241cd6987..fe63a7c3e0da 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -674,6 +674,13 @@ reiserfs_xattr_get(struct inode *inode, const char *name, void *buffer,
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
+	/*
+	 * priv_root needn't be initialized during mount so allow initial
+	 * lookups to succeed.
+	 */
+	if (!REISERFS_SB(inode->i_sb)->priv_root)
+		return 0;
+
 	dentry = xattr_lookup(inode, name, XATTR_REPLACE);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
-- 
2.16.4

