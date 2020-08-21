Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D580A24DBE4
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgHUQs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgHUQUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA1020FC3;
        Fri, 21 Aug 2020 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026768;
        bh=x7OVgJvlaRrLCQacPk05iX576FtirOsPaf9wehDa5GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCdMu8OiEeVjm6dslMfZum+s0EZ6096SG8kGXbDlNZ01H4026etZMklUkvryfRIec
         FXk4c9FWU0yjLBPXw6EFDmxdg9HnWFM6cdnOyj+2dZ0OJFDwBkkQGZFonazwyeg18c
         SoiEQRsIXouXvv7W0VfENWNT4roztd9suy5kkt6o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Guifu <bluce.liguifu@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 23/30] f2fs: fix use-after-free issue
Date:   Fri, 21 Aug 2020 12:18:50 -0400
Message-Id: <20200821161857.348955-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161857.348955-1-sashal@kernel.org>
References: <20200821161857.348955-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Guifu <bluce.liguifu@huawei.com>

[ Upstream commit 99c787cfd2bd04926f1f553b30bd7dcea2caaba1 ]

During umount, f2fs_put_super() unregisters procfs entries after
f2fs_destroy_segment_manager(), it may cause use-after-free
issue when umount races with procfs accessing, fix it by relocating
f2fs_unregister_sysfs().

[Chao Yu: change commit title/message a bit]

Signed-off-by: Li Guifu <bluce.liguifu@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 89319c3524061..990339c538b0a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -782,6 +782,9 @@ static void f2fs_put_super(struct super_block *sb)
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	int i;
 
+	/* unregister procfs/sysfs entries in advance to avoid race case */
+	f2fs_unregister_sysfs(sbi);
+
 	f2fs_quota_off_umount(sb);
 
 	/* prevent remaining shrinker jobs */
@@ -834,8 +837,6 @@ static void f2fs_put_super(struct super_block *sb)
 
 	kfree(sbi->ckpt);
 
-	f2fs_unregister_sysfs(sbi);
-
 	sb->s_fs_info = NULL;
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
-- 
2.25.1

