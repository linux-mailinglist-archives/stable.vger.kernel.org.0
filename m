Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE014D949
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbfFTR63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfFTR62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 13:58:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F3C2089C;
        Thu, 20 Jun 2019 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053507;
        bh=bC0gw+SJhoxFhmYM/wDBLhS8c777+Mzpr3hB6Lna+UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5FWvoc6vrldT0k94zqWArZykZ9LTlnxrksABtrBeT+5MyRz0X5UqYSpT76qYAfhg
         uxZECFUQLqhpDuMU73qS9/zWpiX+31lKxTkCJ3Tri8Dsr330IySGjxBXHhzUrTWdgi
         4HUUif+J8oEIxppmeZZi+L0hPuxn8PdLc4WiLeyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/84] f2fs: fix to avoid panic in do_recover_data()
Date:   Thu, 20 Jun 2019 19:56:10 +0200
Message-Id: <20190620174339.462434842@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 22d61e286e2d9097dae36f75ed48801056b77cac ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203227

- Overview
When mounting the attached crafted image, following errors are reported.
Additionally, it hangs on sync after trying to mount it.

The image is intentionally fuzzed from a normal f2fs image for testing.
Compile options for F2FS are as follows.
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_CHECK_FS=y

- Reproduces
mkdir test
mount -t f2fs tmp.img test
sync

- Messages
 kernel BUG at fs/f2fs/recovery.c:549!
 RIP: 0010:recover_data+0x167a/0x1780
 Call Trace:
  f2fs_recover_fsync_data+0x613/0x710
  f2fs_fill_super+0x1043/0x1aa0
  mount_bdev+0x16d/0x1a0
  mount_fs+0x4a/0x170
  vfs_kern_mount+0x5d/0x100
  do_mount+0x200/0xcf0
  ksys_mount+0x79/0xc0
  __x64_sys_mount+0x1c/0x20
  do_syscall_64+0x43/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

During recovery, if ofs_of_node is inconsistent in between recovered
node page and original checkpointed node page, let's just fail recovery
instead of making kernel panic.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 2878be3e448f..410354c334d7 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -413,7 +413,15 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 	get_node_info(sbi, dn.nid, &ni);
 	f2fs_bug_on(sbi, ni.ino != ino_of_node(page));
-	f2fs_bug_on(sbi, ofs_of_node(dn.node_page) != ofs_of_node(page));
+
+	if (ofs_of_node(dn.node_page) != ofs_of_node(page)) {
+		f2fs_msg(sbi->sb, KERN_WARNING,
+			"Inconsistent ofs_of_node, ino:%lu, ofs:%u, %u",
+			inode->i_ino, ofs_of_node(dn.node_page),
+			ofs_of_node(page));
+		err = -EFAULT;
+		goto err;
+	}
 
 	for (; start < end; start++, dn.ofs_in_node++) {
 		block_t src, dest;
-- 
2.20.1



