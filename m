Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87EB92BA
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391713AbfITOe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:34:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36190 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388169AbfITOZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:05 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqJ-0004xX-Ez; Fri, 20 Sep 2019 15:25:03 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007xM-Qs; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dave Chinner" <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.105114856@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 105/132] xfs: clear sb->s_fs_info on mount failure
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit c9fbd7bbc23dbdd73364be4d045e5d3612cf6e82 upstream.

We recently had an oops reported on a 4.14 kernel in
xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
and so the m_perag_tree lookup walked into lala land.

Essentially, the machine was under memory pressure when the mount
was being run, xfs_fs_fill_super() failed after allocating the
xfs_mount and attaching it to sb->s_fs_info. It then cleaned up and
freed the xfs_mount, but the sb->s_fs_info field still pointed to
the freed memory. Hence when the superblock shrinker then ran
it fell off the bad pointer.

With the superblock shrinker problem fixed at teh VFS level, this
stale s_fs_info pointer is still a problem - we use it
unconditionally in ->put_super when the superblock is being torn
down, and hence we can still trip over it after a ->fill_super
call failure. Hence we need to clear s_fs_info if
xfs-fs_fill_super() fails, and we need to check if it's valid in
the places it can potentially be dereferenced after a ->fill_super
failure.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/xfs/xfs_super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1038,6 +1038,10 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	/* if ->fill_super failed, we have no mount to tear down */
+	if (!sb->s_fs_info)
+		return;
+
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
@@ -1045,6 +1049,8 @@ xfs_fs_put_super(
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
+
+	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1514,6 +1520,7 @@ out_destroy_workqueues:
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
+	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
  out:
@@ -1540,6 +1547,9 @@ xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
 	int			nid)
 {
+	/* Paranoia: catch incorrect calls during mount setup or teardown */
+	if (WARN_ON_ONCE(!sb->s_fs_info))
+		return 0;
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 

