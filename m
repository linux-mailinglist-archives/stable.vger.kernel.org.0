Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9050439A645
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 18:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFCQyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 12:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhFCQyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 12:54:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4742261026;
        Thu,  3 Jun 2021 16:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622739154;
        bh=KpKn9XUO4iOFlgQA8QuoLpE5t3G5v8KOBO7FRLF+BAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfqaaCA2Oem5O1+1Pe9SIuXpofl3q37ZeQerDFbF2zgVGrWbZA/HFodutsm3/Zv5w
         GBds6h8vKRMMmmS7cFoi5Ora9v1L3BUdh73Dx1Ec76WUWw3L7gGTfHq355bhtI4qWj
         hq7gssmJquBkHj8jJdDXtWZZ8JV9bNyZ8GWol78qvdxEe1fYhheI5sS1hYBCa0Y9if
         mAnsZR8MqY7zhqcGgsOjE+BlGvWHatvsXywbxFYJhmvT5qtHyP583YAsbnPUIvO2ya
         3fOQDJ93m2bBAIGQu5Mj46sg3I+bkFlpvCb6WNkGtLcsl1oaI+pxpWhJ+UqREekUPW
         wju0JjGOilRFA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     stable@vger.kernel.org
Subject: [PATCH 3/3] ceph: must hold snap_rwsem when filling inode for async create
Date:   Thu,  3 Jun 2021 12:52:31 -0400
Message-Id: <20210603165231.110559-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603165231.110559-1-jlayton@kernel.org>
References: <20210603165231.110559-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

...and add a lockdep assertion for it to ceph_fill_inode().

Cc: stable@vger.kernel.org # v5.7+
Fixes: 9a8d03ca2e2c3 ("ceph: attempt to do async create when possible")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c  | 3 +++
 fs/ceph/inode.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a01ad342a91d..d3874c2df4b1 100644
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
index e1c63adb196d..df0c8a724609 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -777,6 +777,8 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	umode_t mode = le32_to_cpu(info->mode);
 	dev_t rdev = le32_to_cpu(info->rdev);
 
+	lockdep_assert_held(&mdsc->snap_rwsem);
+
 	dout("%s %p ino %llx.%llx v %llu had %llu\n", __func__,
 	     inode, ceph_vinop(inode), le64_to_cpu(info->version),
 	     ci->i_version);
-- 
2.31.1

