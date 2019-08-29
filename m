Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E526CA2434
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbfH2SRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730081AbfH2SRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E320B23428;
        Thu, 29 Aug 2019 18:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102651;
        bh=c0vTY9RjKr4789bEk4NHVoGVq0dNtJCGIXHXg1sat0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6EH3eVUVAumM7SbipS4U4bCUrDD92nCBryLgdwtFFVx6QFbkOCv3bwATvZ2mQzrG
         mQbd8SFVuDI+h/OV759EPQZ9GaBOzsydr9xC7naqDJyTHBvwItVwfv4WWYNFm6pbN7
         AA950Qtez56gDNBroIddBhYKPejXAkOnmBApSU3o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 25/27] ceph: fix buffer free while holding i_ceph_lock in __ceph_build_xattrs_blob()
Date:   Thu, 29 Aug 2019 14:16:51 -0400
Message-Id: <20190829181655.8741-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181655.8741-1-sashal@kernel.org>
References: <20190829181655.8741-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

[ Upstream commit 12fe3dda7ed89c95cc0ef7abc001ad1ad3e092f8 ]

Calling ceph_buffer_put() in __ceph_build_xattrs_blob() may result in
freeing the i_xattrs.blob buffer while holding the i_ceph_lock.  This can
be fixed by having this function returning the old blob buffer and have
the callers of this function freeing it when the lock is released.

The following backtrace was triggered by fstests generic/117.

  BUG: sleeping function called from invalid context at mm/vmalloc.c:2283
  in_atomic(): 1, irqs_disabled(): 0, pid: 649, name: fsstress
  4 locks held by fsstress/649:
   #0: 00000000a7478e7e (&type->s_umount_key#19){++++}, at: iterate_supers+0x77/0xf0
   #1: 00000000f8de1423 (&(&ci->i_ceph_lock)->rlock){+.+.}, at: ceph_check_caps+0x7b/0xc60
   #2: 00000000562f2b27 (&s->s_mutex){+.+.}, at: ceph_check_caps+0x3bd/0xc60
   #3: 00000000f83ce16a (&mdsc->snap_rwsem){++++}, at: ceph_check_caps+0x3ed/0xc60
  CPU: 1 PID: 649 Comm: fsstress Not tainted 5.2.0+ #439
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
  Call Trace:
   dump_stack+0x67/0x90
   ___might_sleep.cold+0x9f/0xb1
   vfree+0x4b/0x60
   ceph_buffer_release+0x1b/0x60
   __ceph_build_xattrs_blob+0x12b/0x170
   __send_cap+0x302/0x540
   ? __lock_acquire+0x23c/0x1e40
   ? __mark_caps_flushing+0x15c/0x280
   ? _raw_spin_unlock+0x24/0x30
   ceph_check_caps+0x5f0/0xc60
   ceph_flush_dirty_caps+0x7c/0x150
   ? __ia32_sys_fdatasync+0x20/0x20
   ceph_sync_fs+0x5a/0x130
   iterate_supers+0x8f/0xf0
   ksys_sync+0x4f/0xb0
   __ia32_sys_sync+0xa/0x10
   do_syscall_64+0x50/0x1c0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7fc6409ab617

Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c  |  5 ++++-
 fs/ceph/snap.c  |  4 +++-
 fs/ceph/super.h |  2 +-
 fs/ceph/xattr.c | 11 ++++++++---
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 238d24348a98a..df95e39ccd45b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1162,6 +1162,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 {
 	struct ceph_inode_info *ci = cap->ci;
 	struct inode *inode = &ci->vfs_inode;
+	struct ceph_buffer *old_blob = NULL;
 	struct cap_msg_args arg;
 	int held, revoking, dropping;
 	int wake = 0;
@@ -1227,7 +1228,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	ci->i_requested_max_size = arg.max_size;
 
 	if (flushing & CEPH_CAP_XATTR_EXCL) {
-		__ceph_build_xattrs_blob(ci);
+		old_blob = __ceph_build_xattrs_blob(ci);
 		arg.xattr_version = ci->i_xattrs.version;
 		arg.xattr_buf = ci->i_xattrs.blob;
 	} else {
@@ -1262,6 +1263,8 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_buffer_put(old_blob);
+
 	ret = send_cap_msg(&arg);
 	if (ret < 0) {
 		dout("error sending cap msg, must requeue %p\n", inode);
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index a7e763dac0385..29ed1688a1d3a 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -460,6 +460,7 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	struct inode *inode = &ci->vfs_inode;
 	struct ceph_cap_snap *capsnap;
 	struct ceph_snap_context *old_snapc, *new_snapc;
+	struct ceph_buffer *old_blob = NULL;
 	int used, dirty;
 
 	capsnap = kzalloc(sizeof(*capsnap), GFP_NOFS);
@@ -536,7 +537,7 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	capsnap->gid = inode->i_gid;
 
 	if (dirty & CEPH_CAP_XATTR_EXCL) {
-		__ceph_build_xattrs_blob(ci);
+		old_blob = __ceph_build_xattrs_blob(ci);
 		capsnap->xattr_blob =
 			ceph_buffer_get(ci->i_xattrs.blob);
 		capsnap->xattr_version = ci->i_xattrs.version;
@@ -579,6 +580,7 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	}
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_buffer_put(old_blob);
 	kfree(capsnap);
 	ceph_put_snap_context(old_snapc);
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 60b70f0985f67..46f600107cb5b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -835,7 +835,7 @@ extern int ceph_getattr(const struct path *path, struct kstat *stat,
 int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
 ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
 extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
-extern void __ceph_build_xattrs_blob(struct ceph_inode_info *ci);
+extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
 extern void __ceph_destroy_xattrs(struct ceph_inode_info *ci);
 extern void __init ceph_xattr_init(void);
 extern void ceph_xattr_exit(void);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 932c6cdc22d66..3a166f860b6cf 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -681,12 +681,15 @@ static int __get_required_blob_size(struct ceph_inode_info *ci, int name_size,
 
 /*
  * If there are dirty xattrs, reencode xattrs into the prealloc_blob
- * and swap into place.
+ * and swap into place.  It returns the old i_xattrs.blob (or NULL) so
+ * that it can be freed by the caller as the i_ceph_lock is likely to be
+ * held.
  */
-void __ceph_build_xattrs_blob(struct ceph_inode_info *ci)
+struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci)
 {
 	struct rb_node *p;
 	struct ceph_inode_xattr *xattr = NULL;
+	struct ceph_buffer *old_blob = NULL;
 	void *dest;
 
 	dout("__build_xattrs_blob %p\n", &ci->vfs_inode);
@@ -717,12 +720,14 @@ void __ceph_build_xattrs_blob(struct ceph_inode_info *ci)
 			dest - ci->i_xattrs.prealloc_blob->vec.iov_base;
 
 		if (ci->i_xattrs.blob)
-			ceph_buffer_put(ci->i_xattrs.blob);
+			old_blob = ci->i_xattrs.blob;
 		ci->i_xattrs.blob = ci->i_xattrs.prealloc_blob;
 		ci->i_xattrs.prealloc_blob = NULL;
 		ci->i_xattrs.dirty = false;
 		ci->i_xattrs.version++;
 	}
+
+	return old_blob;
 }
 
 static inline int __get_request_mask(struct inode *in) {
-- 
2.20.1

