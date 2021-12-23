Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9D47E108
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 10:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347583AbhLWJ5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 04:57:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59814 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239351AbhLWJ5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 04:57:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42631B81F9E
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 09:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60410C36AE9;
        Thu, 23 Dec 2021 09:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640253464;
        bh=8B1OvtWZuOkP0wWgrweJM6+jeQ6vhCBj97IyVWEStnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWfudjEBN63Ab+dlilQJS2J8dISix1bbRWeZ1QMGMMeabqfFQAqbJYnyN6ntGN0ja
         ky9PWMBlVfnuqFnSlwVBBMmUZMtg0QZcLoVeJR1iBl6jtmOhBYNJkFT6vaq5n9rxPX
         FMQu4VswQFXNfWAUvD6vV6NfoL7/DV1/sljgm4Wb752B04ghAuURnsZRF/39hOnlE4
         C7TBq5VmSCqMpj8d8L5S0yJ6UoTknWXWovCplk1v+1Drx8iKsI2VLXcEHs3k6B9f5z
         WOCfuHUgGJ4Jb6vUqzPI4II3ri8g7NOWtnvMHPN8W2CQIBXpjxwZuBoL0FRNuZbaNL
         /BV+KQ/MAc8XQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v5.10] ceph: fix up non-directory creation in SGID directories
Date:   Thu, 23 Dec 2021 10:57:33 +0100
Message-Id: <20211223095733.587981-1-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <https://lore.kernel.org/stable/YcBgWdVOT6GtICE6@kroah.com>
References: <https://lore.kernel.org/stable/YcBgWdVOT6GtICE6@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Ceph always inherits the SGID bit if it is set on the parent inode,
while the generic inode_init_owner does not do this in a few cases where
it can create a possible security problem (cf. [1]).

Update ceph to strip the SGID bit just as inode_init_owner would.

This bug was detected by the mapped mount testsuite in [3]. The
testsuite tests all core VFS functionality and semantics with and
without mapped mounts. That is to say it functions as a generic VFS
testsuite in addition to a mapped mount testsuite. While working on
mapped mount support for ceph, SIGD inheritance was the only failing
test for ceph after the port.

The same bug was detected by the mapped mount testsuite in XFS in
January 2021 (cf. [2]).

[1]: commit 0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
[2]: commit 01ea173e103e ("xfs: fix up non-directory creation in SGID directories")
[3]: https://git.kernel.org/fs/xfs/xfstests-dev.git

Cc: stable@vger.kernel.org (adapted to v5.10)
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/file.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8e6855e7ed83..8ed881fd7440 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -603,13 +603,25 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.cap.realm = cpu_to_le64(ci->i_snap_realm->ino);
 	in.cap.flags = CEPH_CAP_FLAG_AUTH;
 	in.ctime = in.mtime = in.atime = iinfo.btime;
-	in.mode = cpu_to_le32((u32)mode);
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
 	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
-	in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_mode & S_ISGID ?
-				dir->i_gid : current_fsgid()));
+	if (dir->i_mode & S_ISGID) {
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
+
+		/* Directories always inherit the setgid bit. */
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
+			 !in_group_p(dir->i_gid) &&
+			 !capable_wrt_inode_uidgid(dir, CAP_FSETID))
+			mode &= ~S_ISGID;
+	} else {
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
+	}
+	in.mode = cpu_to_le32((u32)mode);
+
 	in.nlink = cpu_to_le32(1);
 	in.max_size = cpu_to_le64(lo->stripe_unit);
 
-- 
2.30.2

