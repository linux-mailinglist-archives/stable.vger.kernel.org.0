Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37E2D60A0
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391142AbgLJOiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391136AbgLJOiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:11 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 26/75] gfs2: Upgrade shared glocks for atime updates
Date:   Thu, 10 Dec 2020 15:26:51 +0100
Message-Id: <20201210142607.339447970@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 82e938bd5382b322ce81e6cb8fd030987f2da022 upstream.

Commit 20f829999c38 ("gfs2: Rework read and page fault locking") lifted
the glock lock taking from the low-level ->readpage and ->readahead
address space operations to the higher-level ->read_iter file and
->fault vm operations.  The glocks are still taken in LM_ST_SHARED mode
only.  On filesystems mounted without the noatime option, ->read_iter
sometimes needs to update the atime as well, though.  Right now, this
leads to a failed locking mode assertion in gfs2_dirty_inode.

Fix that by introducing a new update_time inode operation.  There, if
the glock is held non-exclusively, upgrade it to an exclusive lock.

Reported-by: Alexander Aring <aahringo@redhat.com>
Fixes: 20f829999c38 ("gfs2: Rework read and page fault locking")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2116,6 +2116,25 @@ loff_t gfs2_seek_hole(struct file *file,
 	return vfs_setpos(file, ret, inode->i_sb->s_maxbytes);
 }
 
+static int gfs2_update_time(struct inode *inode, struct timespec64 *time,
+			    int flags)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_glock *gl = ip->i_gl;
+	struct gfs2_holder *gh;
+	int error;
+
+	gh = gfs2_glock_is_locked_by_me(gl);
+	if (gh && !gfs2_glock_is_held_excl(gl)) {
+		gfs2_glock_dq(gh);
+		gfs2_holder_reinit(LM_ST_EXCLUSIVE, 0, gh);
+		error = gfs2_glock_nq(gh);
+		if (error)
+			return error;
+	}
+	return generic_update_time(inode, time, flags);
+}
+
 const struct inode_operations gfs2_file_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
@@ -2124,6 +2143,7 @@ const struct inode_operations gfs2_file_
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
 	.set_acl = gfs2_set_acl,
+	.update_time = gfs2_update_time,
 };
 
 const struct inode_operations gfs2_dir_iops = {
@@ -2143,6 +2163,7 @@ const struct inode_operations gfs2_dir_i
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
 	.set_acl = gfs2_set_acl,
+	.update_time = gfs2_update_time,
 	.atomic_open = gfs2_atomic_open,
 };
 


