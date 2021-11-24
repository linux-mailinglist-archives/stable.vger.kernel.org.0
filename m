Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4D445C415
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351292AbhKXNpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353400AbhKXNmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4336C63291;
        Wed, 24 Nov 2021 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758688;
        bh=SLyoh75FvKzGm9w2pX2yhhsBTaYpcUYt4uL0R1J2xKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n88AAxk96NRlAcqLdrRgukBY4x2gVw5TpfmCbSckA0epWX6LyURvcCYrV7YDX1fCA
         YtCgI2nlTuGWAKSvdQO2uqgiycqbR5F2r7dxdDiL5Jo/Bfw9pc/7yItl28TTPLV4Ds
         eEo2ip4Ufcyd8aw+uHNPkqnPLNKBKbaVULNjJTD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 152/154] fs: export an inode_update_time helper
Date:   Wed, 24 Nov 2021 12:59:08 +0100
Message-Id: <20211124115707.396176664@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
@@ -1772,12 +1772,13 @@ EXPORT_SYMBOL(generic_update_time);
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
  *	touch_atime	-	update the access time
@@ -1847,7 +1848,7 @@ void touch_atime(const struct path *path
 	 * of the fs read only, e.g. subvolumes in Btrfs.
 	 */
 	now = current_time(inode);
-	update_time(inode, &now, S_ATIME);
+	inode_update_time(inode, &now, S_ATIME);
 	__mnt_drop_write(mnt);
 skip_update:
 	sb_end_write(inode->i_sb);
@@ -1991,7 +1992,7 @@ int file_update_time(struct file *file)
 	if (__mnt_want_write_file(file))
 		return 0;
 
-	ret = update_time(inode, &now, sync_it);
+	ret = inode_update_time(inode, &now, sync_it);
 	__mnt_drop_write_file(file);
 
 	return ret;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2214,6 +2214,8 @@ enum file_time_flags {
 
 extern bool atime_needs_update(const struct path *, struct inode *);
 extern void touch_atime(const struct path *);
+int inode_update_time(struct inode *inode, struct timespec64 *time, int flags);
+
 static inline void file_accessed(struct file *file)
 {
 	if (!(file->f_flags & O_NOATIME))


