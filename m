Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80EA8CFEA4
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 18:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfJHQOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 12:14:21 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:46899 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbfJHQOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 12:14:20 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 8 Oct 2019 09:14:17 -0700
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 296E3B2BE2;
        Tue,  8 Oct 2019 12:14:19 -0400 (EDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <dchinner@redhat.com>
CC:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <srostedt@vmware.com>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4.4.y] xfs: clear sb->s_fs_info on mount failure
Date:   Tue, 8 Oct 2019 21:39:08 +0530
Message-ID: <1570550948-3364-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 fs/xfs/xfs_super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ef64a1e..ff3f581 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1572,6 +1572,7 @@ xfs_fs_fill_super(
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
+	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
  out:
@@ -1589,6 +1590,10 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	/* if ->fill_super failed, we have no mount to tear down */
+	if (!sb->s_fs_info)
+		return;
+
 	xfs_notice(mp, "Unmounting Filesystem");
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
@@ -1598,6 +1603,8 @@ xfs_fs_put_super(
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
+
+	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1617,6 +1624,9 @@ xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
 	struct shrink_control	*sc)
 {
+	/* Paranoia: catch incorrect calls during mount setup or teardown */
+	if (WARN_ON_ONCE(!sb->s_fs_info))
+		return 0;
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 
-- 
2.7.4

