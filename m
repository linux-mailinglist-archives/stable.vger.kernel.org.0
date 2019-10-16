Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7D3D9DFF
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395260AbfJPVze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395252AbfJPVzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:33 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ABBA21D7F;
        Wed, 16 Oct 2019 21:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262932;
        bh=+Xx8dEvgQfqrBHSIOX0sGjnhqv4hoRx4grH9nfmkAtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIIpjv+fGVWGMJRJ7NLrZloPPGEAQZfDEO1HeEw2/Xm7uaIXi7yW87Hfg296YDzPq
         VTjYALCcJ0spv5GOexF1EbbSyIV3sn/Xedl7PYcsoQt92QrABhsTE9WTNTU/VOVnoU
         QcreUb7kXbVWH+3p7qniuNhK7mIbs/Y08bBdUqBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 4.9 92/92] xfs: clear sb->s_fs_info on mount failure
Date:   Wed, 16 Oct 2019 14:51:05 -0700
Message-Id: <20191016214849.217245343@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1674,6 +1674,7 @@ xfs_fs_fill_super(
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
+	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
  out:
@@ -1691,6 +1692,10 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	/* if ->fill_super failed, we have no mount to tear down */
+	if (!sb->s_fs_info)
+		return;
+
 	xfs_notice(mp, "Unmounting Filesystem");
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
@@ -1700,6 +1705,8 @@ xfs_fs_put_super(
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
+
+	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1719,6 +1726,9 @@ xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
 	struct shrink_control	*sc)
 {
+	/* Paranoia: catch incorrect calls during mount setup or teardown */
+	if (WARN_ON_ONCE(!sb->s_fs_info))
+		return 0;
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 


