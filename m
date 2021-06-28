Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542483B6125
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhF1Oct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233249AbhF1Oan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 264BF61CD0;
        Mon, 28 Jun 2021 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890424;
        bh=Hl5cwqhacZOpzw0gbxyzgsOteOHSYGlR0qVeLVQQEP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0quzllusryAXTxWxUbLyv6rY1K6QCCCE/0yp0pdKqM8uCxrYeLHs6H3kNgEaZpID
         iPTAEENEp1MTjKqWZpejKCJNRTug8qpxgDhbYGMvwtX+LpN4fiugH4a93ORFjVBDdn
         75zU31ZmdFyJn8O5ngYM9ST0IwXSPM2cgN/+dJSyq2cuZ06doXgLfaOH48orsrKvjy
         VtInjUXIx6NXKw0nVtrDaRk2a2S2++hZEJAW+5AkVKT6EAfnJW33ZbHf2PJk0dpPKY
         h6EXsLdQrBLrdui9/9a4gtNi5+Ihmj1AaF+R32K68Zg+6vVDJZ6NGehNpHkBOENLIz
         UTCGOPD787JRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 066/101] ceph: must hold snap_rwsem when filling inode for async create
Date:   Mon, 28 Jun 2021 10:25:32 -0400
Message-Id: <20210628142607.32218-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 27171ae6a0fdc75571e5bf3d0961631a1e4fb765 upstream.

...and add a lockdep assertion for it to ceph_fill_inode().

Cc: stable@vger.kernel.org # v5.7+
Fixes: 9a8d03ca2e2c3 ("ceph: attempt to do async create when possible")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c  | 3 +++
 fs/ceph/inode.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 209535d5b8d3..3d2e3dd4ee01 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -578,6 +578,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	struct ceph_inode_info *ci = ceph_inode(dir);
 	struct inode *inode;
 	struct timespec64 now;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_vino vino = { .ino = req->r_deleg_ino,
 				  .snap = CEPH_NOSNAP };
 
@@ -615,8 +616,10 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 
 	ceph_file_layout_to_legacy(lo, &in.layout);
 
+	down_read(&mdsc->snap_rwsem);
 	ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
 			      req->r_fmode, NULL);
+	up_read(&mdsc->snap_rwsem);
 	if (ret) {
 		dout("%s failed to fill inode: %d\n", __func__, ret);
 		ceph_dir_clear_complete(dir);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 346fcdfcd3e9..57cd78e942c0 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -762,6 +762,8 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	bool new_version = false;
 	bool fill_inline = false;
 
+	lockdep_assert_held(&mdsc->snap_rwsem);
+
 	dout("%s %p ino %llx.%llx v %llu had %llu\n", __func__,
 	     inode, ceph_vinop(inode), le64_to_cpu(info->version),
 	     ci->i_version);
-- 
2.30.2

