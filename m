Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E56531C71
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfFANVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbfFANVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C055272FE;
        Sat,  1 Jun 2019 13:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395284;
        bh=3PmY+xIbfOtUT8ZXCVXiVtg42HjcdYEkCCaoWoQ33Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oO8qNyQKualRh9mEQmgUIoo+Rc6FGGYNGPeDRHJQlXTDS9iJvUU++W4i9fIcLnU1D
         CZy4CmSFZ2RKxCuizIIGKnFoUd/L99DQdp2bxnehS2UwL4gTnu9Ou9dfAS4ntkKGw1
         jqDKTcTEs0Pfsw+9ySD5XyAkECnFRiU1BjCQCC7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.0 047/173] f2fs: fix to use inline space only if inline_xattr is enable
Date:   Sat,  1 Jun 2019 09:17:19 -0400
Message-Id: <20190601131934.25053-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 622927f3b8809206f6da54a6a7ed4df1a7770fce ]

With below mkfs and mount option:

MKFS_OPTIONS  -- -O extra_attr -O project_quota -O inode_checksum -O flexible_inline_xattr -O inode_crtime -f
MOUNT_OPTIONS -- -o noinline_xattr

We may miss xattr data with below testcase:
- mkdir dir
- setfattr -n "user.name" -v 0 dir
- for ((i = 0; i < 190; i++)) do touch dir/$i; done
- umount
- mount
- getfattr -n "user.name" dir

user.name: No such attribute

The root cause is that we persist xattr data into reserved inline xattr
space, even if inline_xattr is not enable in inline directory inode, after
inline dentry conversion, reserved space no longer exists, so that xattr
data missed.

Let's use inline xattr space only if inline_xattr flag is set on inode
to fix this iusse.

Fixes: 6afc662e68b5 ("f2fs: support flexible inline xattr size")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f8dfa64429f64..2149d1f190d62 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2570,7 +2570,9 @@ static inline void *inline_xattr_addr(struct inode *inode, struct page *page)
 
 static inline int inline_xattr_size(struct inode *inode)
 {
-	return get_inline_xattr_addrs(inode) * sizeof(__le32);
+	if (f2fs_has_inline_xattr(inode))
+		return get_inline_xattr_addrs(inode) * sizeof(__le32);
+	return 0;
 }
 
 static inline int f2fs_has_inline_data(struct inode *inode)
-- 
2.20.1

