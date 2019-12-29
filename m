Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A8012C99F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfL2SLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730124AbfL2Rmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8EAF20718;
        Sun, 29 Dec 2019 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641358;
        bh=xPBuZ/Yy2Fb8R5lQVrMcwLR/VojIuUTEyFWg9fzCUjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwrON5TSXOBx1VOnUPdSczG59wqx2zojKbCNPBmAmYUw100JZ1YK3p1XboclWETZy
         z03d1cXoa4lUidYUOO4dEcbkryjM+2PRHFZ2ifn3i3mUtaO4SviLb51+1COizhovHE
         +EENdtpUujNqarg0nX2lLsGHxxnEnmJLKpfQsDbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 033/434] btrfs: send: remove WARN_ON for readonly mount
Date:   Sun, 29 Dec 2019 18:21:26 +0100
Message-Id: <20191229172704.232139904@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit fbd542971aa1e9ec33212afe1d9b4f1106cd85a1 upstream.

We log warning if root::orphan_cleanup_state is not set to
ORPHAN_CLEANUP_DONE in btrfs_ioctl_send(). However if the filesystem is
mounted as readonly we skip the orphan item cleanup during the lookup
and root::orphan_cleanup_state remains at the init state 0 instead of
ORPHAN_CLEANUP_DONE (2). So during send in btrfs_ioctl_send() we hit the
warning as below.

  WARN_ON(send_root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE);

WARNING: CPU: 0 PID: 2616 at /Volumes/ws/btrfs-devel/fs/btrfs/send.c:7090 btrfs_ioctl_send+0xb2f/0x18c0 [btrfs]
::
RIP: 0010:btrfs_ioctl_send+0xb2f/0x18c0 [btrfs]
::
Call Trace:
::
_btrfs_ioctl_send+0x7b/0x110 [btrfs]
btrfs_ioctl+0x150a/0x2b00 [btrfs]
::
do_vfs_ioctl+0xa9/0x620
? __fget+0xac/0xe0
ksys_ioctl+0x60/0x90
__x64_sys_ioctl+0x16/0x20
do_syscall_64+0x49/0x130
entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reproducer:
  mkfs.btrfs -fq /dev/sdb
  mount /dev/sdb /btrfs
  btrfs subvolume create /btrfs/sv1
  btrfs subvolume snapshot -r /btrfs/sv1 /btrfs/ss1
  umount /btrfs
  mount -o ro /dev/sdb /btrfs
  btrfs send /btrfs/ss1 -f /tmp/f

The warning exists because having orphan inodes could confuse send and
cause it to fail or produce incorrect streams.  The two cases that would
cause such send failures, which are already fixed are:

1) Inodes that were unlinked - these are orphanized and remain with a
   link count of 0. These caused send operations to fail because it
   expected to always find at least one path for an inode. However this
   is no longer a problem since send is now able to deal with such
   inodes since commit 46b2f4590aab ("Btrfs: fix send failure when root
   has deleted files still open") and treats them as having been
   completely removed (the state after an orphan cleanup is performed).

2) Inodes that were in the process of being truncated. These resulted in
   send not knowing about the truncation and potentially issue write
   operations full of zeroes for the range from the new file size to the
   old file size. This is no longer a problem because we no longer
   create orphan items for truncation since commit f7e9e8fc792f ("Btrfs:
   stop creating orphan items for truncate").

As such before these commits, the WARN_ON here provided a clue in case
something went wrong. Instead of being a warning against the
root::orphan_cleanup_state value, it could have been more accurate by
checking if there were actually any orphan items, and then issue a
warning only if any exists, but that would be more expensive to check.
Since orphanized inodes no longer cause problems for send, just remove
the warning.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Link: https://lore.kernel.org/linux-btrfs/21cb5e8d059f6e1496a903fa7bfc0a297e2f5370.camel@scientia.net/
CC: stable@vger.kernel.org # 4.19+
Suggested-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7076,12 +7076,6 @@ long btrfs_ioctl_send(struct file *mnt_f
 	spin_unlock(&send_root->root_item_lock);
 
 	/*
-	 * This is done when we lookup the root, it should already be complete
-	 * by the time we get here.
-	 */
-	WARN_ON(send_root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE);
-
-	/*
 	 * Userspace tools do the checks and warn the user if it's
 	 * not RO.
 	 */


