Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC73C475EF1
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245365AbhLOR0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbhLORY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A46C061378;
        Wed, 15 Dec 2021 09:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3B7CB8202A;
        Wed, 15 Dec 2021 17:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F86C36AE3;
        Wed, 15 Dec 2021 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589093;
        bh=Qyu5rfUna9v6YgG1OqOKARS7oRI7jx8getrtOz0G7oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPo0AylqjwtmZVdnnbkzpyHH3haQTIK6XVdBZFseHt4KcD0wMNUldJH5kAuKC20WK
         rBePZ3JsF8pX400chATebqNDFYVOjRtWc8V1vhSj5ZMWs5nPnaIn0tcbtWxwMEVSaq
         q/C+o2ZpiAPpfLzTaA+iuY/YPhNTcxaiG8hQaOLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chenguanyou <chenguanyou@xiaomi.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Ed Tsai <ed.tsai@mediatek.com>
Subject: [PATCH 5.10 18/33] fuse: make sure reclaim doesnt write the inode
Date:   Wed, 15 Dec 2021 18:21:16 +0100
Message-Id: <20211215172025.403287477@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 5c791fe1e2a4f401f819065ea4fc0450849f1818 upstream.

In writeback cache mode mtime/ctime updates are cached, and flushed to the
server using the ->write_inode() callback.

Closing the file will result in a dirty inode being immediately written,
but in other cases the inode can remain dirty after all references are
dropped.  This result in the inode being written back from reclaim, which
can deadlock on a regular allocation while the request is being served.

The usual mechanisms (GFP_NOFS/PF_MEMALLOC*) don't work for FUSE, because
serving a request involves unrelated userspace process(es).

Instead do the same as for dirty pages: make sure the inode is written
before the last reference is gone.

 - fallocate(2)/copy_file_range(2): these call file_update_time() or
   file_modified(), so flush the inode before returning from the call

 - unlink(2), link(2) and rename(2): these call fuse_update_ctime(), so
   flush the ctime directly from this helper

Reported-by: chenguanyou <chenguanyou@xiaomi.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c    |    8 ++++++++
 fs/fuse/file.c   |   15 +++++++++++++++
 fs/fuse/fuse_i.h |    1 +
 fs/fuse/inode.c  |    3 +++
 4 files changed, 27 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -791,11 +791,19 @@ static int fuse_symlink(struct inode *di
 	return create_new_entry(fm, &args, dir, entry, S_IFLNK);
 }
 
+void fuse_flush_time_update(struct inode *inode)
+{
+	int err = sync_inode_metadata(inode, 1);
+
+	mapping_set_error(inode->i_mapping, err);
+}
+
 void fuse_update_ctime(struct inode *inode)
 {
 	if (!IS_NOCMTIME(inode)) {
 		inode->i_ctime = current_time(inode);
 		mark_inode_dirty_sync(inode);
+		fuse_flush_time_update(inode);
 	}
 }
 
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1849,6 +1849,17 @@ int fuse_write_inode(struct inode *inode
 	struct fuse_file *ff;
 	int err;
 
+	/*
+	 * Inode is always written before the last reference is dropped and
+	 * hence this should not be reached from reclaim.
+	 *
+	 * Writing back the inode from reclaim can deadlock if the request
+	 * processing itself needs an allocation.  Allocations triggering
+	 * reclaim while serving a request can't be prevented, because it can
+	 * involve any number of unrelated userspace processes.
+	 */
+	WARN_ON(wbc->for_reclaim);
+
 	ff = __fuse_write_file_get(fc, fi);
 	err = fuse_flush_times(inode, ff);
 	if (ff)
@@ -3338,6 +3349,8 @@ out:
 	if (lock_inode)
 		inode_unlock(inode);
 
+	fuse_flush_time_update(inode);
+
 	return err;
 }
 
@@ -3447,6 +3460,8 @@ out:
 	inode_unlock(inode_out);
 	file_accessed(file_in);
 
+	fuse_flush_time_update(inode_out);
+
 	return err;
 }
 
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1113,6 +1113,7 @@ int fuse_allow_current_process(struct fu
 
 u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
 
+void fuse_flush_time_update(struct inode *inode);
 void fuse_update_ctime(struct inode *inode);
 
 int fuse_update_attributes(struct inode *inode, struct file *file);
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -119,6 +119,9 @@ static void fuse_evict_inode(struct inod
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
+	/* Will write inode on close/munmap and in all other dirtiers */
+	WARN_ON(inode->i_state & I_DIRTY_INODE);
+
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (inode->i_sb->s_flags & SB_ACTIVE) {


