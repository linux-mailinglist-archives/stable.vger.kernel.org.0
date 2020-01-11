Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E678A13804E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbgAKK2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgAKK2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:28:09 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1184E205F4;
        Sat, 11 Jan 2020 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738489;
        bh=8LQ57KpO9LCtfp2kIPRmeXoksDw3hbOG6V5DoikAhgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGX/a44JDyIDKE7zDmrgNruGvNiZNqttDN8XzdfNnKNbPdFHSeUm+lJi1XrKECInc
         84+Cja5pmyihy+CPOHX8Aes4DPrdc4lSPqMuQgKQmKe5dsyr/yIEwY+GfKm1jCQffA
         fvD51RPogoYeq6jk9DGcj4u6llUbCDMbP1/I4yAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/165] fs: avoid softlockups in s_inodes iterators
Date:   Sat, 11 Jan 2020 10:50:23 +0100
Message-Id: <20200111094930.545018929@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fef457a42882..96d62d97694e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -676,6 +676,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	struct inode *inode, *next;
 	LIST_HEAD(dispose);
 
+again:
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -698,6 +699,12 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
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
index 2ecef6155fc0..ac9eb273e28c 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -77,6 +77,7 @@ static void fsnotify_unmount_inodes(struct super_block *sb)
 
 		iput_inode = inode;
 
+		cond_resched();
 		spin_lock(&sb->s_inode_list_lock);
 	}
 	spin_unlock(&sb->s_inode_list_lock);
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 9b96243de081..7abc3230c21a 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -986,6 +986,7 @@ static int add_dquot_ref(struct super_block *sb, int type)
 		 * later.
 		 */
 		old_inode = inode;
+		cond_resched();
 		spin_lock(&sb->s_inode_list_lock);
 	}
 	spin_unlock(&sb->s_inode_list_lock);
-- 
2.20.1



