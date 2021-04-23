Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A312C36921D
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhDWMaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 08:30:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17398 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhDWMae (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 08:30:34 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FRYTp49TlzlZHb;
        Fri, 23 Apr 2021 20:27:58 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Fri, 23 Apr 2021
 20:29:47 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <tytso@mit.edu>, <sashal@kernel.org>,
        <yi.zhang@huawei.com>
Subject: [PATCH 4.9] ext4: correct error label in ext4_rename()
Date:   Fri, 23 Apr 2021 20:37:50 +0800
Message-ID: <20210423123750.1946580-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The backport of upstream patch 5dccdc5a1916 ("ext4: do not iput inode
under running transaction in ext4_rename()") introduced a regression on
the stable kernels 4.14 and older. One of the end_rename error label was
forgetting to change to release_bh, which may trigger below bug.

 ------------[ cut here ]------------
 kernel BUG at /home/zhangyi/hulk-4.4/fs/ext4/ext4_jbd2.c:30!
 ...
 Call Trace:
  [<ffffffff8b4207b2>] ext4_rename+0x9e2/0x10c0
  [<ffffffff8b331324>] ? unlazy_walk+0x124/0x2a0
  [<ffffffff8b420eb5>] ext4_rename2+0x25/0x60
  [<ffffffff8b335104>] vfs_rename+0x3a4/0xed0
  [<ffffffff8b33a7ad>] SYSC_renameat2+0x57d/0x7f0
  [<ffffffff8b33c119>] SyS_renameat+0x19/0x30
  [<ffffffff8bc57bb8>] entry_SYSCALL_64_fastpath+0x18/0x78
 ...
 ---[ end trace 75346ce7c76b9f06 ]---

Fixes: f5337ec530a6 ("ext4: do not iput inode under running transaction in ext4_rename()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index bbda3ea7039f..4d9901a18b97 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3621,7 +3621,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	    ext4_encrypted_inode(new.dir) &&
 	    !fscrypt_has_permitted_context(new.dir, old.inode)) {
 		retval = -EXDEV;
-		goto end_rename;
+		goto release_bh;
 	}
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
-- 
2.25.4

