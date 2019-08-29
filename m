Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F721A2508
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfH2S13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728460AbfH2SPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 473922341C;
        Thu, 29 Aug 2019 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102531;
        bh=T2htdwQXOeQ4/hkAuJA8LIvdZihWsSm1K99O882HxmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2jiXR8jlHeqzkEgGN6knTnLQUyQDC69IKxZ/6uhjlI2/10CiM4LpEZK/1s9tommn
         esOmX9pMRhxeY+fT4b+A05ziLFPNYiryqp02usLC3w561eK9NwACwRkx9KfxXYNOQT
         86MCP39uHQmHjDF53SJCSJinGvECRf00p/7YqRus=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 66/76] ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
Date:   Thu, 29 Aug 2019 14:13:01 -0400
Message-Id: <20190829181311.7562-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

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
index 0619adbcbe14c..8382299fc2d84 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1028,6 +1028,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf = NULL;
+	struct ceph_buffer *old_blob = NULL;
 	int issued;
 	int err;
 	int dirty = 0;
@@ -1101,13 +1102,15 @@ int __ceph_setxattr(struct inode *inode, const char *name,
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
@@ -1123,6 +1126,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 	}
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);
 	if (dirty)
-- 
2.20.1

