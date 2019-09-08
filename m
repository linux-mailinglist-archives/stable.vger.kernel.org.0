Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6C8ACCD3
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfIHMnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728206AbfIHMnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:43:04 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66AC9216C8;
        Sun,  8 Sep 2019 12:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946583;
        bh=IT+tKBqhK0+Dwjx0wRy0DRX4SSYc92W6iree7MGs4qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XT5VksokUWIe6V1ekjAecwmrXClyN6du1j2pe4lRDe3hU6pRgQXwbgmtfTEVB+IWI
         k2p/LyJQqXBDhArXjeiyfI4UCkT4M186igmMhK2TaSHmw4m0a23f+SttzCx9yd7ytu
         KjgkEvNzLky0+qtJ79Tf3QripC85+MrxF/o243UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/23] ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
Date:   Sun,  8 Sep 2019 13:41:49 +0100
Message-Id: <20190908121100.079224663@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121052.898169328@linuxfoundation.org>
References: <20190908121052.898169328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 86968ef21596515958d5f0a40233d02be78ecec0 ]

Calling ceph_buffer_put() in __ceph_setxattr() may end up freeing the
i_xattrs.prealloc_blob buffer while holding the i_ceph_lock.  This can be
fixed by postponing the call until later, when the lock is released.

The following backtrace was triggered by fstests generic/117.

  BUG: sleeping function called from invalid context at mm/vmalloc.c:2283
  in_atomic(): 1, irqs_disabled(): 0, pid: 650, name: fsstress
  3 locks held by fsstress/650:
   #0: 00000000870a0fe8 (sb_writers#8){.+.+}, at: mnt_want_write+0x20/0x50
   #1: 00000000ba0c4c74 (&type->i_mutex_dir_key#6){++++}, at: vfs_setxattr+0x55/0xa0
   #2: 000000008dfbb3f2 (&(&ci->i_ceph_lock)->rlock){+.+.}, at: __ceph_setxattr+0x297/0x810
  CPU: 1 PID: 650 Comm: fsstress Not tainted 5.2.0+ #437
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
  Call Trace:
   dump_stack+0x67/0x90
   ___might_sleep.cold+0x9f/0xb1
   vfree+0x4b/0x60
   ceph_buffer_release+0x1b/0x60
   __ceph_setxattr+0x2b4/0x810
   __vfs_setxattr+0x66/0x80
   __vfs_setxattr_noperm+0x59/0xf0
   vfs_setxattr+0x81/0xa0
   setxattr+0x115/0x230
   ? filename_lookup+0xc9/0x140
   ? rcu_read_lock_sched_held+0x74/0x80
   ? rcu_sync_lockdep_assert+0x2e/0x60
   ? __sb_start_write+0x142/0x1a0
   ? mnt_want_write+0x20/0x50
   path_setxattr+0xba/0xd0
   __x64_sys_lsetxattr+0x24/0x30
   do_syscall_64+0x50/0x1c0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7ff23514359a

Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/xattr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index b24275ef97f74..22e5f3432abbf 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -916,6 +916,7 @@ int __ceph_setxattr(struct dentry *dentry, const char *name,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(dentry->d_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf = NULL;
+	struct ceph_buffer *old_blob = NULL;
 	int issued;
 	int err;
 	int dirty = 0;
@@ -984,13 +985,15 @@ retry:
 		struct ceph_buffer *blob;
 
 		spin_unlock(&ci->i_ceph_lock);
-		dout(" preaallocating new blob size=%d\n", required_blob_size);
+		ceph_buffer_put(old_blob); /* Shouldn't be required */
+		dout(" pre-allocating new blob size=%d\n", required_blob_size);
 		blob = ceph_buffer_new(required_blob_size, GFP_NOFS);
 		if (!blob)
 			goto do_sync_unlocked;
 		spin_lock(&ci->i_ceph_lock);
+		/* prealloc_blob can't be released while holding i_ceph_lock */
 		if (ci->i_xattrs.prealloc_blob)
-			ceph_buffer_put(ci->i_xattrs.prealloc_blob);
+			old_blob = ci->i_xattrs.prealloc_blob;
 		ci->i_xattrs.prealloc_blob = blob;
 		goto retry;
 	}
@@ -1006,6 +1009,7 @@ retry:
 	}
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);
 	if (dirty)
-- 
2.20.1



