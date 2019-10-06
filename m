Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD0CD660
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbfJFRoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731613AbfJFRoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:44:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 513222080F;
        Sun,  6 Oct 2019 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383843;
        bh=XSU9Lm/zgAzIoiJRp75m3u5Wjh77YFlhrhlEZ9ovvSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oftgyWAHOMgqZMXdObjRU8L0rURsinRubmmnxhfkC6+amlG5cYAU4uqWTHVKiR5Kv
         CJVhSwZVRcSpfXl1YrA8U/X/soixuhCRP4hRxAtX9oWDioFOXEQUs9lYvuYy2MjrNF
         cUZyXnOW+XI7u1H/Md2tVObrFCKuS8GNWhYgnpWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jan Stancek <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 115/166] fat: work around race with userspaces read via blockdev while mounting
Date:   Sun,  6 Oct 2019 19:21:21 +0200
Message-Id: <20191006171223.014976956@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit 07bfa4415ab607e459b69bd86aa7e7602ce10b4f ]

If userspace reads the buffer via blockdev while mounting,
sb_getblk()+modify can race with buffer read via blockdev.

For example,

            FS                               userspace
    bh = sb_getblk()
    modify bh->b_data
                                  read
				    ll_rw_block(bh)
				      fill bh->b_data by on-disk data
				      /* lost modified data by FS */
				      set_buffer_uptodate(bh)
    set_buffer_uptodate(bh)

Userspace should not use the blockdev while mounting though, the udev
seems to be already doing this.  Although I think the udev should try to
avoid this, workaround the race by small overhead.

Link: http://lkml.kernel.org/r/87pnk7l3sw.fsf_-_@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/dir.c    | 13 +++++++++++--
 fs/fat/fatent.c |  3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 1bda2ab6745ba..814ad2c2ba808 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1100,8 +1100,11 @@ static int fat_zeroed_cluster(struct inode *dir, sector_t blknr, int nr_used,
 			err = -ENOMEM;
 			goto error;
 		}
+		/* Avoid race with userspace read via bdev */
+		lock_buffer(bhs[n]);
 		memset(bhs[n]->b_data, 0, sb->s_blocksize);
 		set_buffer_uptodate(bhs[n]);
+		unlock_buffer(bhs[n]);
 		mark_buffer_dirty_inode(bhs[n], dir);
 
 		n++;
@@ -1158,6 +1161,8 @@ int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts)
 	fat_time_unix2fat(sbi, ts, &time, &date, &time_cs);
 
 	de = (struct msdos_dir_entry *)bhs[0]->b_data;
+	/* Avoid race with userspace read via bdev */
+	lock_buffer(bhs[0]);
 	/* filling the new directory slots ("." and ".." entries) */
 	memcpy(de[0].name, MSDOS_DOT, MSDOS_NAME);
 	memcpy(de[1].name, MSDOS_DOTDOT, MSDOS_NAME);
@@ -1180,6 +1185,7 @@ int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts)
 	de[0].size = de[1].size = 0;
 	memset(de + 2, 0, sb->s_blocksize - 2 * sizeof(*de));
 	set_buffer_uptodate(bhs[0]);
+	unlock_buffer(bhs[0]);
 	mark_buffer_dirty_inode(bhs[0], dir);
 
 	err = fat_zeroed_cluster(dir, blknr, 1, bhs, MAX_BUF_PER_PAGE);
@@ -1237,11 +1243,14 @@ static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
 
 			/* fill the directory entry */
 			copy = min(size, sb->s_blocksize);
+			/* Avoid race with userspace read via bdev */
+			lock_buffer(bhs[n]);
 			memcpy(bhs[n]->b_data, slots, copy);
-			slots += copy;
-			size -= copy;
 			set_buffer_uptodate(bhs[n]);
+			unlock_buffer(bhs[n]);
 			mark_buffer_dirty_inode(bhs[n], dir);
+			slots += copy;
+			size -= copy;
 			if (!size)
 				break;
 			n++;
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 265983635f2be..3647c65a0f482 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -388,8 +388,11 @@ static int fat_mirror_bhs(struct super_block *sb, struct buffer_head **bhs,
 				err = -ENOMEM;
 				goto error;
 			}
+			/* Avoid race with userspace read via bdev */
+			lock_buffer(c_bh);
 			memcpy(c_bh->b_data, bhs[n]->b_data, sb->s_blocksize);
 			set_buffer_uptodate(c_bh);
+			unlock_buffer(c_bh);
 			mark_buffer_dirty_inode(c_bh, sbi->fat_inode);
 			if (sb->s_flags & SB_SYNCHRONOUS)
 				err = sync_dirty_buffer(c_bh);
-- 
2.20.1



