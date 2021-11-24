Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0469445C687
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354170AbhKXOKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348746AbhKXOGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B6B861248;
        Wed, 24 Nov 2021 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759545;
        bh=81hJQ2p9SsUcEagTG61mCTcL3IZGDWKHthijO4gMigo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7KFzg9tsUntXmNn/2XxQBbky1Gkg9vdw9GBHOPenzK0lMuL5YOiXCZQ1KqBQnD0E
         UoHaKUEZaSV+rEAAvqDsA8Xwz9znejQDSKwnHubPZaM4V24WdjeDv75BvFdWvYZmr9
         u7fO1BTUMDqzTiLUtALIgq2cYZ82V1AzMgfyuvWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 276/279] fs: export an inode_update_time helper
Date:   Wed, 24 Nov 2021 12:59:23 +0100
Message-Id: <20211124115728.224225231@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit e60feb445fce9e51c1558a6aa7faf9dd5ded533b upstream.

If you already have an inode and need to update the time on the inode
there is no way to do this properly.  Export this helper to allow file
systems to update time on the inode so the appropriate handler is
called, either ->update_time or generic_update_time.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c         |    7 ++++---
 include/linux/fs.h |    2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1782,12 +1782,13 @@ EXPORT_SYMBOL(generic_update_time);
  * This does the actual work of updating an inodes time or version.  Must have
  * had called mnt_want_write() before calling this.
  */
-static int update_time(struct inode *inode, struct timespec64 *time, int flags)
+int inode_update_time(struct inode *inode, struct timespec64 *time, int flags)
 {
 	if (inode->i_op->update_time)
 		return inode->i_op->update_time(inode, time, flags);
 	return generic_update_time(inode, time, flags);
 }
+EXPORT_SYMBOL(inode_update_time);
 
 /**
  *	atime_needs_update	-	update the access time
@@ -1857,7 +1858,7 @@ void touch_atime(const struct path *path
 	 * of the fs read only, e.g. subvolumes in Btrfs.
 	 */
 	now = current_time(inode);
-	update_time(inode, &now, S_ATIME);
+	inode_update_time(inode, &now, S_ATIME);
 	__mnt_drop_write(mnt);
 skip_update:
 	sb_end_write(inode->i_sb);
@@ -2002,7 +2003,7 @@ int file_update_time(struct file *file)
 	if (__mnt_want_write_file(file))
 		return 0;
 
-	ret = update_time(inode, &now, sync_it);
+	ret = inode_update_time(inode, &now, sync_it);
 	__mnt_drop_write_file(file);
 
 	return ret;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2498,6 +2498,8 @@ enum file_time_flags {
 
 extern bool atime_needs_update(const struct path *, struct inode *);
 extern void touch_atime(const struct path *);
+int inode_update_time(struct inode *inode, struct timespec64 *time, int flags);
+
 static inline void file_accessed(struct file *file)
 {
 	if (!(file->f_flags & O_NOATIME))


