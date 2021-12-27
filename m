Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B5947FFEE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbhL0PmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239842AbhL0Pkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D19FC061399;
        Mon, 27 Dec 2021 07:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B179D610F4;
        Mon, 27 Dec 2021 15:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D91C36AEA;
        Mon, 27 Dec 2021 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619546;
        bh=HYfGLO98/O3zzy7+3xItRHsmVKDcMyc5noenfgx5aH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+7yStYVqkqjhGPm+E3rLG8InlRshdF0XKrZyoIM1EO8a7u3DOOqdwSqTLuSldpll
         SORkoH/eOs7X7BZvuUW7bxCdDRtcuJSKjCnWIiDKIsBSquU9Vzh8ykf/EJ8d5HBZx9
         fAUzAVrQSeQgIkrPt+7SinnF1xPkNFMgu1LAp4Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 61/76] ceph: fix up non-directory creation in SGID directories
Date:   Mon, 27 Dec 2021 16:31:16 +0100
Message-Id: <20211227151326.811592671@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit fd84bfdddd169c219c3a637889a8b87f70a072c2 upstream.

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

Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -603,13 +603,25 @@ static int ceph_finish_async_create(stru
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
 


