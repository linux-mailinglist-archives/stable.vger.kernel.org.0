Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0A210BA21
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbfK0VAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731269AbfK0VAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:00:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65CE02084B;
        Wed, 27 Nov 2019 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888409;
        bh=b6JKrXfZ3sW46mtc8cUPJf+7pJXsH6mrbwPNqmM5xCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGKuMGAAU/MJblrJ5TrBN2n4th4QSRqbYt+yNhxuVP5/wIUUxmqzjrlATLptNHPQR
         xLbn525GaN2+sOvGREe/k6IoxN8/zBXFqbNGt11fLQLh/kNkWu33ywg9IGIt7anOQm
         91cVLuUTy82u/BuSWZvQpwTygds5juZ39aheqsSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/306] f2fs: spread f2fs_set_inode_flags()
Date:   Wed, 27 Nov 2019 21:29:33 +0100
Message-Id: <20191127203124.116784284@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 9149a5eb606152df158eb7d7da5a34e84b574189 ]

This patch changes codes as below:
- use f2fs_set_inode_flags() to update i_flags atomically to avoid
potential race.
- synchronize F2FS_I(inode)->i_flags to inode->i_flags in
f2fs_new_inode().
- use f2fs_set_inode_flags() to simply codes in f2fs_quota_{on,off}.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  | 2 +-
 fs/f2fs/namei.c | 2 ++
 fs/f2fs/super.c | 5 ++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2dc49a5419070..34e48bcf50874 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3388,7 +3388,7 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
 {
 #ifdef CONFIG_F2FS_FS_ENCRYPTION
 	file_set_encrypt(inode);
-	inode->i_flags |= S_ENCRYPTED;
+	f2fs_set_inode_flags(inode);
 #endif
 }
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1f67e389169f5..6b23dcbf52f45 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -124,6 +124,8 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL)
 		set_inode_flag(inode, FI_PROJ_INHERIT);
 
+	f2fs_set_inode_flags(inode);
+
 	trace_f2fs_new_inode(inode, 0);
 	return inode;
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 15779123d0895..7a9cc64f5ca37 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1837,8 +1837,7 @@ static int f2fs_quota_on(struct super_block *sb, int type, int format_id,
 
 	inode_lock(inode);
 	F2FS_I(inode)->i_flags |= F2FS_NOATIME_FL | F2FS_IMMUTABLE_FL;
-	inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
-					S_NOATIME | S_IMMUTABLE);
+	f2fs_set_inode_flags(inode);
 	inode_unlock(inode);
 	f2fs_mark_inode_dirty_sync(inode, false);
 
@@ -1863,7 +1862,7 @@ static int f2fs_quota_off(struct super_block *sb, int type)
 
 	inode_lock(inode);
 	F2FS_I(inode)->i_flags &= ~(F2FS_NOATIME_FL | F2FS_IMMUTABLE_FL);
-	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
+	f2fs_set_inode_flags(inode);
 	inode_unlock(inode);
 	f2fs_mark_inode_dirty_sync(inode, false);
 out_put:
-- 
2.20.1



