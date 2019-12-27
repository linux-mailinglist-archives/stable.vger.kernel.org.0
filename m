Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7AF12B702
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfL0Rqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbfL0RpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:45:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC152464E;
        Fri, 27 Dec 2019 17:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468711;
        bh=GmQF/U1jMdDYTC1dqGu6MsW8UyyQu7rKEZYoIr2GqGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIog5cuRFnWEZ8qd5RFalNdBo15iSpx8/AAdGsKnklUoQ4fdZ3Xx6VnniS5+wrImx
         GKSHrCACxT1rfJPGvIkssu15XDPEF1DGnj6ycEenv/sOhfDzzesaNJ1cMbeMXU9CUF
         H7RaaV0FnKiG+j3k5OODZ8pu1CLee/bH+GgmJ1k4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 66/84] fs: avoid softlockups in s_inodes iterators
Date:   Fri, 27 Dec 2019 12:43:34 -0500
Message-Id: <20191227174352.6264-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 04646aebd30b99f2cfa0182435a2ec252fcb16d0 ]

Anything that walks all inodes on sb->s_inodes list without rescheduling
risks softlockups.

Previous efforts were made in 2 functions, see:

c27d82f fs/drop_caches.c: avoid softlockups in drop_pagecache_sb()
ac05fbb inode: don't softlockup when evicting inodes

but there hasn't been an audit of all walkers, so do that now.  This
also consistently moves the cond_resched() calls to the bottom of each
loop in cases where it already exists.

One loop remains: remove_dquot_ref(), because I'm not quite sure how
to deal with that one w/o taking the i_lock.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/drop_caches.c     | 2 +-
 fs/inode.c           | 7 +++++++
 fs/notify/fsnotify.c | 1 +
 fs/quota/dquot.c     | 1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index d31b6c72b476..dc1a1d5d825b 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -35,11 +35,11 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inode_list_lock);
 
-		cond_resched();
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
 
+		cond_resched();
 		spin_lock(&sb->s_inode_list_lock);
 	}
 	spin_unlock(&sb->s_inode_list_lock);
diff --git a/fs/inode.c b/fs/inode.c
index 5c63693326bb..9c50521c9fe4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -660,6 +660,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	struct inode *inode, *next;
 	LIST_HEAD(dispose);
 
+again:
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -682,6 +683,12 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
+		if (need_resched()) {
+			spin_unlock(&sb->s_inode_list_lock);
+			cond_resched();
+			dispose_list(&dispose);
+			goto again;
+		}
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 170a733454f7..e8ee4263d7b2 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -90,6 +90,7 @@ void fsnotify_unmount_inodes(struct super_block *sb)
 
 		iput_inode = inode;
 
+		cond_resched();
 		spin_lock(&sb->s_inode_list_lock);
 	}
 	spin_unlock(&sb->s_inode_list_lock);
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 59b00d8db22c..57eed66e2c2d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -980,6 +980,7 @@ static int add_dquot_ref(struct super_block *sb, int type)
 		 * later.
 		 */
 		old_inode = inode;
+		cond_resched();
 		spin_lock(&sb->s_inode_list_lock);
 	}
 	spin_unlock(&sb->s_inode_list_lock);
-- 
2.20.1

