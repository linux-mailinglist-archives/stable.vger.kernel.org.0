Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155AF76918
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfGZNtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388428AbfGZNot (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15E7A22CC2;
        Fri, 26 Jul 2019 13:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148688;
        bh=apjQDmC7ggWn6wZiINcLuS4dmV3yVs3syvWojk8qpXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xdkudk+CtimnmrQ9ib9DLOFRl+odOSkRIRBQgJXJuhetIzP1yqj+EwycDWF5B8ZWv
         fyYi++9nB4kRh8yH6u7NAjJesFcmlq6Ms9vHFqIvIKweEZO7aGuxxJaO0AVBJ1+e60
         EOwckUcyiuALAYicMaXsln0uQ9CrlUKAayuy9/LQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/30] ceph: return -ERANGE if virtual xattr value didn't fit in buffer
Date:   Fri, 26 Jul 2019 09:44:14 -0400
Message-Id: <20190726134432.12993-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134432.12993-1-sashal@kernel.org>
References: <20190726134432.12993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3b421018f48c482bdc9650f894aa1747cf90e51d ]

The getxattr manpage states that we should return ERANGE if the
destination buffer size is too small to hold the value.
ceph_vxattrcb_layout does this internally, but we should be doing
this for all vxattrs.

Fix the only caller of getxattr_cb to check the returned size
against the buffer length and return -ERANGE if it doesn't fit.
Drop the same check in ceph_vxattrcb_layout and just rely on the
caller to handle it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Acked-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/xattr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 75267cdd5dfd..81144a8c0927 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -74,7 +74,7 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	const char *ns_field = " pool_namespace=";
 	char buf[128];
 	size_t len, total_len = 0;
-	int ret;
+	ssize_t ret;
 
 	pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
 
@@ -98,11 +98,8 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	if (pool_ns)
 		total_len += strlen(ns_field) + pool_ns->len;
 
-	if (!size) {
-		ret = total_len;
-	} else if (total_len > size) {
-		ret = -ERANGE;
-	} else {
+	ret = total_len;
+	if (size >= total_len) {
 		memcpy(val, buf, len);
 		ret = len;
 		if (pool_name) {
@@ -757,8 +754,11 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	vxattr = ceph_match_vxattr(inode, name);
 	if (vxattr) {
 		err = -ENODATA;
-		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci)))
+		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
 			err = vxattr->getxattr_cb(ci, value, size);
+			if (size && size < err)
+				err = -ERANGE;
+		}
 		return err;
 	}
 
-- 
2.20.1

