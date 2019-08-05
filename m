Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7981B83
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfHENGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbfHENGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:06:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 041FE2075B;
        Mon,  5 Aug 2019 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010412;
        bh=hycwXyAjIzzmKAHREUUugHq0647YvB+ksnQPYoyMh/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiySC5Il/4DEUF5uYdkLhssjJZTGhGdZOfsnIMgNMeNevhglitR92DVMP38NI77bl
         bA/ZK77Cjp9wmggqD6RUWUFF/nBmo5NYWHzzYGbHoReZ16VmRSY5BbDBmJzOWqh7FI
         6bHhy8bqduSwswVsomshX8NTBuj2aftPezSRcX3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/53] ceph: return -ERANGE if virtual xattr value didnt fit in buffer
Date:   Mon,  5 Aug 2019 15:02:39 +0200
Message-Id: <20190805124929.675491068@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
References: <20190805124927.973499541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index e1c4e0b12b4cd..0376db8a74f85 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -75,7 +75,7 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	const char *ns_field = " pool_namespace=";
 	char buf[128];
 	size_t len, total_len = 0;
-	int ret;
+	ssize_t ret;
 
 	pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
 
@@ -99,11 +99,8 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
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
@@ -761,8 +758,11 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		if (err)
 			return err;
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



