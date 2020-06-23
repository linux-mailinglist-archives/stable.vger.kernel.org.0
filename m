Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558212064EF
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbgFWV32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389239AbgFWUPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:15:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E72212073E;
        Tue, 23 Jun 2020 20:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943303;
        bh=J8gLyxuh7i1Ph5mKliRbbrUkmLcIN1tXAi/qcBYfNoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhI2FRJqwhD87/rKDoujkUmD2o/49UjrD2lWrRSpZfyZ6C+kBKTCDVjshMMK8uWeY
         m7u7rM8P7s+LNXpXlSDzJnLNOBqYNgdb6qiCYTO3upwLnGXz8SGlRCBkl8UAZ6D8MR
         Pjm5RbLTQdE5nMrZ+a6qR3zw2FSZ3voTke7aztqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 308/477] ceph: dont return -ESTALE if theres still an open file
Date:   Tue, 23 Jun 2020 21:55:05 +0200
Message-Id: <20200623195422.097412353@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

[ Upstream commit 878dabb64117406abd40977b87544d05bb3031fc ]

Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
a file handle to dentry"), this fixes another corner case with
name_to_handle_at/open_by_handle_at.  The issue has been detected by
xfstest generic/467, when doing:

 - name_to_handle_at("/cephfs/myfile")
 - open("/cephfs/myfile")
 - unlink("/cephfs/myfile")
 - sync; sync;
 - drop caches
 - open_by_handle_at()

The call to open_by_handle_at should not fail because the file hasn't been
deleted yet (only unlinked) and we do have a valid handle to it.  -ESTALE
shall be returned only if i_nlink is 0 *and* i_count is 1.

This patch also makes sure we have LINK caps before checking i_nlink.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/export.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 79dc06881e78e..e088843a7734c 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -172,9 +172,16 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
 static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 {
 	struct inode *inode = __lookup_inode(sb, ino);
+	int err;
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
-	if (inode->i_nlink == 0) {
+	/* We need LINK caps to reliably check i_nlink */
+	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
+	if (err)
+		return ERR_PTR(err);
+	/* -ESTALE if inode as been unlinked and no file is open */
+	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
-- 
2.25.1



