Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69930FF2E3
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfKPQWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:22:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbfKPPnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:22 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5523207DD;
        Sat, 16 Nov 2019 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919002;
        bh=On0GqOyxsloTEVa6hsuBGk6Zfg6op1AFEmlN8rwIm8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QApM3epZXKxZXlA3fT7DxgTL1u3w5bzuDDYzbzjDfTkG1C5msEW1bh+iLgmUfqZoO
         QJnR29TAM4WdmTlmGGuwlVAxQ/866kOeqBJhLMzSqI8T7a7aX94mTwbma1UqWCBycz
         S53UZ2SP99xY14cZVCyp+ztDEeyKtzx0rCxksteM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 105/237] f2fs: spread f2fs_set_inode_flags()
Date:   Sat, 16 Nov 2019 10:39:00 -0500
Message-Id: <20191116154113.7417-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fb216488d67a9..c9d19832426b1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3387,7 +3387,7 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
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
index d9106bbe7df63..7aefb2c35c48f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1835,8 +1835,7 @@ static int f2fs_quota_on(struct super_block *sb, int type, int format_id,
 
 	inode_lock(inode);
 	F2FS_I(inode)->i_flags |= F2FS_NOATIME_FL | F2FS_IMMUTABLE_FL;
-	inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
-					S_NOATIME | S_IMMUTABLE);
+	f2fs_set_inode_flags(inode);
 	inode_unlock(inode);
 	f2fs_mark_inode_dirty_sync(inode, false);
 
@@ -1861,7 +1860,7 @@ static int f2fs_quota_off(struct super_block *sb, int type)
 
 	inode_lock(inode);
 	F2FS_I(inode)->i_flags &= ~(F2FS_NOATIME_FL | F2FS_IMMUTABLE_FL);
-	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
+	f2fs_set_inode_flags(inode);
 	inode_unlock(inode);
 	f2fs_mark_inode_dirty_sync(inode, false);
 out_put:
-- 
2.20.1

