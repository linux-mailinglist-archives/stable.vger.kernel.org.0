Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F189724DDFA
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgHURZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgHUQPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E2C21741;
        Fri, 21 Aug 2020 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026524;
        bh=4P0E1TdwEUvHFMgvNrSm/DXS5S0ovHvkEWD5HGQ/MOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZCJjL9Zj5J6cnTtuS7R5txtxAvHS2wjGPeb1SvKdU18XZgduni6tLj/MVWIDPAp2
         Sx6YWE+KzqMGtKWbJLsOVobZAX/868WwDirgT1UbHFZkPeg/NFuKPrdzCx7ijhlSvP
         Y9AUMP6hcKGV245REWMBcDF98CFJlkxL+lHX9yPo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Guifu <bluce.liguifu@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.8 47/62] f2fs: fix use-after-free issue
Date:   Fri, 21 Aug 2020 12:14:08 -0400
Message-Id: <20200821161423.347071-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
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
index 20e56b0fa46a9..0deb839da0a03 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1173,6 +1173,9 @@ static void f2fs_put_super(struct super_block *sb)
 	int i;
 	bool dropped;
 
+	/* unregister procfs/sysfs entries in advance to avoid race case */
+	f2fs_unregister_sysfs(sbi);
+
 	f2fs_quota_off_umount(sb);
 
 	/* prevent remaining shrinker jobs */
@@ -1238,8 +1241,6 @@ static void f2fs_put_super(struct super_block *sb)
 
 	kvfree(sbi->ckpt);
 
-	f2fs_unregister_sysfs(sbi);
-
 	sb->s_fs_info = NULL;
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
-- 
2.25.1

