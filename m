Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64964063CE
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhIJAtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234963AbhIJAZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BFBD610A3;
        Fri, 10 Sep 2021 00:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233459;
        bh=d7btG8WqUYKP0BAS9y1/vub8PmoVRbCXgL8IJ+40SlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuX1p3Q9aCz8IjZkjenft0EGTWVLr07wC1VK9OA59J4YFOiZGY/L5/puNBeNqPHbT
         WoOxg+iQ+D/jGXdMxJPnwjAQKmIqa5gIC8tiRBi3spLmPcUsYB0ZTUMC2bPUksWoeI
         8wOVCDHrAndX4Eiplt9aVGFm0GT2lMmAKca7RTfyvSg1WkOMd2RSTS8xfkZ9K6rUBX
         ZXu8vR+l3rYlB/wU7OpzSUgvDE02DpA50cNke9h+7V6VVds7rpRyDcFEHHViyJvszt
         5M6vJMpUzMssDdMJbR7iw7EpQB8k/wDnRSbWpM74XQFGIlVgR7Y66jeJjRiK5S4o3P
         cRgF6cM+kFYBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/14] ext4: Make sure quota files are not grabbed accidentally
Date:   Thu,  9 Sep 2021 20:24:01 -0400
Message-Id: <20210910002403.176887-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002403.176887-1-sashal@kernel.org>
References: <20210910002403.176887-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit bd2c38cf1726ea913024393a0d11f2e2a3f4c180 ]

If ext4 filesystem is corrupted so that quota files are linked from
directory hirerarchy, bad things can happen. E.g. quota files can get
corrupted or deleted. Make sure we are not grabbing quota file inodes
when we expect normal inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210812133122.26360-1-jack@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6551f08e89a7..9792a604e35c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4231,6 +4231,7 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
 	struct ext4_inode_info *ei;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	struct inode *inode;
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 	long ret;
@@ -4240,9 +4241,12 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	gid_t i_gid;
 
 	if ((!(flags & EXT4_IGET_SPECIAL) &&
-	     (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)) ||
+	     ((ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO) ||
+	      ino == le32_to_cpu(es->s_usr_quota_inum) ||
+	      ino == le32_to_cpu(es->s_grp_quota_inum) ||
+	      ino == le32_to_cpu(es->s_prj_quota_inum))) ||
 	    (ino < EXT4_ROOT_INO) ||
-	    (ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
+	    (ino > le32_to_cpu(es->s_inodes_count))) {
 		if (flags & EXT4_IGET_HANDLE)
 			return ERR_PTR(-ESTALE);
 		__ext4_error(sb, function, line,
-- 
2.30.2

