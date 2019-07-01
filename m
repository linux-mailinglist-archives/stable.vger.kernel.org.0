Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6A731E49
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfFANXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728315AbfFANXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:23:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5382127358;
        Sat,  1 Jun 2019 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395396;
        bh=4J9YH8H33lL1cAD9vxXb2Asyh3ywbLyY9cbc1X6NWkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAVRK01S9eeFZ3xFUEoS5henZYWTdt1myfk8oYKgw1/6GinxXQt7bXnsytqgQtrNT
         EsP3dmfIacuBZvDqGV/Q+5VWQdBsZ+9FO1iqj47uK4YDuF7MKZrCIRG7H0bG3Dh/eC
         Orw5Mv1ZIJN6fkyNrW1X9P+u0V4NmVWBKdRSOipc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 036/141] f2fs: fix to avoid panic in f2fs_remove_inode_page()
Date:   Sat,  1 Jun 2019 09:20:12 -0400
Message-Id: <20190601132158.25821-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 8b6810f8acfe429fde7c7dad4714692cc5f75651 ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203219

- Overview
When mounting the attached crafted image and running program, I got this error.
Additionally, it hangs on sync after running the program.

The image is intentionally fuzzed from a normal f2fs image for testing and I enabled option CONFIG_F2FS_CHECK_FS on.

- Reproduces
cc poc_06.c
mkdir test
mount -t f2fs tmp.img test
cp a.out test
cd test
sudo ./a.out
sync

- Messages
 kernel BUG at fs/f2fs/node.c:1183!
 RIP: 0010:f2fs_remove_inode_page+0x294/0x2d0
 Call Trace:
  f2fs_evict_inode+0x2a3/0x3a0
  evict+0xba/0x180
  __dentry_kill+0xbe/0x160
  dentry_kill+0x46/0x180
  dput+0xbb/0x100
  do_renameat2+0x3c9/0x550
  __x64_sys_rename+0x17/0x20
  do_syscall_64+0x43/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is f2fs_remove_inode_page() will trigger kernel panic due to
inconsistent i_blocks value of inode.

To avoid panic, let's just print debug message and set SBI_NEED_FSCK to
give a hint to fsck for latter repairing of potential image corruption.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
[Jaegeuk Kim: fix build warning and add unlikely]
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 19a0d83aae653..807a77518a491 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1180,8 +1180,14 @@ int f2fs_remove_inode_page(struct inode *inode)
 		f2fs_put_dnode(&dn);
 		return -EIO;
 	}
-	f2fs_bug_on(F2FS_I_SB(inode),
-			inode->i_blocks != 0 && inode->i_blocks != 8);
+
+	if (unlikely(inode->i_blocks != 0 && inode->i_blocks != 8)) {
+		f2fs_msg(F2FS_I_SB(inode)->sb, KERN_WARNING,
+			"Inconsistent i_blocks, ino:%lu, iblocks:%llu",
+			inode->i_ino,
+			(unsigned long long)inode->i_blocks);
+		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
+	}
 
 	/* will put inode & node pages */
 	err = truncate_node(&dn);
-- 
2.20.1

