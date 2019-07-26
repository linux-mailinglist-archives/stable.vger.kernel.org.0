Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749C676A86
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfGZNkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbfGZNkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E6222CBD;
        Fri, 26 Jul 2019 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148429;
        bh=u8mihk7BMaBudNZAbfb+ZXvceZCfjoz1RKteTCz+rjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWZNAD4eWFMJTGz1owVDvO3s4yEOk/PcZMBu+qxa/MN0AjYAEIVbyVIZvQ4G6rwPC
         S8u9eghoUCDbodKwdIK/9SGfGol77x+XTVlNJymHrblb4DWS9z5veQmA4trKnAaQ7i
         aAZ8NPtt6NDxa5Ownnt7SMA11+wkvUUDjoyi1q10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, "Yan, Zheng" <zyan@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 32/85] ceph: fix listxattr vxattr buffer length calculation
Date:   Fri, 26 Jul 2019 09:38:42 -0400
Message-Id: <20190726133936.11177-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 2b2abcac8c251d1c77a4cc9d9f248daefae0fb4e ]

ceph_listxattr() incorrectly returns a length based on the static
ceph_vxattrs_name_size() value, which only takes into account whether
vxattrs are hidden, ignoring vxattr.exists_cb().

When filling the xattr buffer ceph_listxattr() checks VXATTR_FLAG_HIDDEN
and vxattr.exists_cb(). If both are false, we return an incorrect
(oversize) length.

Fix this behaviour by always calculating the vxattrs length at runtime,
taking both vxattr.hidden and vxattr.exists_cb() into account.

This bug is only exposed with the new "ceph.snap.btime" vxattr, as all
other vxattrs with a non-null exists_cb also carry VXATTR_FLAG_HIDDEN.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/xattr.c | 54 +++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 0cc42c8879e9..b9df49e13d9c 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -897,10 +897,9 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 	struct inode *inode = d_inode(dentry);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_vxattr *vxattrs = ceph_inode_vxattrs(inode);
-	u32 vir_namelen = 0;
+	bool len_only = (size == 0);
 	u32 namelen;
 	int err;
-	u32 len;
 	int i;
 
 	spin_lock(&ci->i_ceph_lock);
@@ -919,38 +918,45 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 	err = __build_xattrs(inode);
 	if (err < 0)
 		goto out;
-	/*
-	 * Start with virtual dir xattr names (if any) (including
-	 * terminating '\0' characters for each).
-	 */
-	vir_namelen = ceph_vxattrs_name_size(vxattrs);
 
-	/* adding 1 byte per each variable due to the null termination */
+	/* add 1 byte for each xattr due to the null termination */
 	namelen = ci->i_xattrs.names_size + ci->i_xattrs.count;
-	err = -ERANGE;
-	if (size && vir_namelen + namelen > size)
-		goto out;
-
-	err = namelen + vir_namelen;
-	if (size == 0)
-		goto out;
+	if (!len_only) {
+		if (namelen > size) {
+			err = -ERANGE;
+			goto out;
+		}
+		names = __copy_xattr_names(ci, names);
+		size -= namelen;
+	}
 
-	names = __copy_xattr_names(ci, names);
 
 	/* virtual xattr names, too */
-	err = namelen;
 	if (vxattrs) {
 		for (i = 0; vxattrs[i].name; i++) {
-			if (!(vxattrs[i].flags & VXATTR_FLAG_HIDDEN) &&
-			    !(vxattrs[i].exists_cb &&
-			      !vxattrs[i].exists_cb(ci))) {
-				len = sprintf(names, "%s", vxattrs[i].name);
-				names += len + 1;
-				err += len + 1;
+			size_t this_len;
+
+			if (vxattrs[i].flags & VXATTR_FLAG_HIDDEN)
+				continue;
+			if (vxattrs[i].exists_cb && !vxattrs[i].exists_cb(ci))
+				continue;
+
+			this_len = strlen(vxattrs[i].name) + 1;
+			namelen += this_len;
+			if (len_only)
+				continue;
+
+			if (this_len > size) {
+				err = -ERANGE;
+				goto out;
 			}
+
+			memcpy(names, vxattrs[i].name, this_len);
+			names += this_len;
+			size -= this_len;
 		}
 	}
-
+	err = namelen;
 out:
 	spin_unlock(&ci->i_ceph_lock);
 	return err;
-- 
2.20.1

