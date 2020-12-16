Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24E12DBD66
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 10:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgLPJQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 04:16:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9450 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgLPJQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 04:16:23 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CwqGQ5RJ2zhrS2;
        Wed, 16 Dec 2020 17:15:10 +0800 (CST)
Received: from szvp000203569.huawei.com (10.120.216.130) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 16 Dec 2020 17:15:33 +0800
From:   Chao Yu <yuchao0@huawei.com>
To:     <jaegeuk@kernel.org>
CC:     <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <chao@kernel.org>,
        Chao Yu <yuchao0@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH] f2fs: fix out-of-repair __setattr_copy()
Date:   Wed, 16 Dec 2020 17:15:23 +0800
Message-ID: <20201216091523.21411-1-yuchao0@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.120.216.130]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__setattr_copy() was copied from setattr_copy() in fs/attr.c, there is
two missing patches doesn't cover this inner function, fix it.

Commit 7fa294c8991c ("userns: Allow chown and setgid preservation")
Commit 23adbe12ef7d ("fs,userns: Change inode_capable to capable_wrt_inode_uidgid")

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 16ea10f2bcf5..5bcaa68f74ad 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -848,7 +848,8 @@ static void __setattr_copy(struct inode *inode, const struct iattr *attr)
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(inode->i_gid) &&
+			!capable_wrt_inode_uidgid(inode, CAP_FSETID))
 			mode &= ~S_ISGID;
 		set_acl_inode(inode, mode);
 	}
-- 
2.29.2

