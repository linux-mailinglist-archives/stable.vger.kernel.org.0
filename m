Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8B42724E6
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 15:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgIUNMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 09:12:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:56014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgIUNMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 09:12:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90E80B563;
        Mon, 21 Sep 2020 13:12:47 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 34A381E0BA1; Mon, 21 Sep 2020 15:12:11 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     <reiserfs-devel@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] reiserfs: Initialize inode keys properly
Date:   Mon, 21 Sep 2020 15:12:09 +0200
Message-Id: <20200921131209.31976-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

reiserfs_read_locked_inode() didn't initialize key length properly. Use
_make_cpu_key() macro for key initialization so that all key member are
properly initialized.

CC: stable@vger.kernel.org
Reported-by: syzbot+d94d02749498bb7bab4b@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/inode.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 1509775da040..e43fed96704d 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1551,11 +1551,7 @@ void reiserfs_read_locked_inode(struct inode *inode,
 	 * set version 1, version 2 could be used too, because stat data
 	 * key is the same in both versions
 	 */
-	key.version = KEY_FORMAT_3_5;
-	key.on_disk_key.k_dir_id = dirino;
-	key.on_disk_key.k_objectid = inode->i_ino;
-	key.on_disk_key.k_offset = 0;
-	key.on_disk_key.k_type = 0;
+	_make_cpu_key(&key, KEY_FORMAT_3_5, dirino, inode->i_ino, 0, 0, 3);
 
 	/* look for the object's stat data */
 	retval = search_item(inode->i_sb, &key, &path_to_sd);
-- 
2.16.4

