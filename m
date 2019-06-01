Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1793C31F28
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfFANSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbfFANSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 411CC272AC;
        Sat,  1 Jun 2019 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395124;
        bh=U5I4SwGO5ux2RXzKWyEj2xwdyHf+G6wG0MwXfiKJfHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9muKZlm9b+VHzPL9uyh4z/Ap7Up1DCMsPJ8BO6JgFe4y3Cku/zjirfHlnVdg/iUj
         9UQh9ZSKKkh99uLCv12C30axEi9FOgxqDdnd83WKa3aNdBh5yZesfWG6tMbPqJkf2I
         ljCkkXa4dgNdIGS2ZlXGYCyudoe6FO0DdZQalqDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.1 048/186] f2fs: fix to clear dirty inode in error path of f2fs_iget()
Date:   Sat,  1 Jun 2019 09:14:24 -0400
Message-Id: <20190601131653.24205-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 546d22f070d64a7b96f57c93333772085d3a5e6d ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203217

- Overview
When mounting the attached crafted image and running program, I got this error.
Additionally, it hangs on sync after running the program.

The image is intentionally fuzzed from a normal f2fs image for testing and I enabled option CONFIG_F2FS_CHECK_FS on.

- Reproduces
cc poc_test_05.c
mkdir test
mount -t f2fs tmp.img test
sudo ./a.out
sync

- Messages
 kernel BUG at fs/f2fs/inode.c:707!
 RIP: 0010:f2fs_evict_inode+0x33f/0x3a0
 Call Trace:
  evict+0xba/0x180
  f2fs_iget+0x598/0xdf0
  f2fs_lookup+0x136/0x320
  __lookup_slow+0x92/0x140
  lookup_slow+0x30/0x50
  walk_component+0x1c1/0x350
  path_lookupat+0x62/0x200
  filename_lookup+0xb3/0x1a0
  do_readlinkat+0x56/0x110
  __x64_sys_readlink+0x16/0x20
  do_syscall_64+0x43/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

During inode loading, __recover_inline_status() can recovery inode status
and set inode dirty, once we failed in following process, it will fail
the check in f2fs_evict_inode, result in trigger BUG_ON().

Let's clear dirty inode in error path of f2fs_iget() to avoid panic.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index e7f2e87593156..4edd6f2bb4910 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -488,6 +488,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	return inode;
 
 bad_inode:
+	f2fs_inode_synced(inode);
 	iget_failed(inode);
 	trace_f2fs_iget_exit(inode, ret);
 	return ERR_PTR(ret);
-- 
2.20.1

