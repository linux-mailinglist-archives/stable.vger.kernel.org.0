Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824AEF120F
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 10:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfKFJWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 04:22:35 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:56736 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726891AbfKFJWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 04:22:35 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D30E2F0AD12F01B1D662;
        Wed,  6 Nov 2019 17:22:32 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 6 Nov 2019
 17:22:26 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <yi.zhang@huawei.com>
Subject: [PATCH for linux 4.4.y/3.16.y] fs/dcache: move security_d_instantiate() behind attaching dentry to inode
Date:   Wed, 6 Nov 2019 17:43:52 +0800
Message-ID: <20191106094352.9665-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During backport 1e2e547a93a "do d_instantiate/unlock_new_inode
combinations safely", there was a error instantiating sequence of
attaching dentry to inode and calling security_d_instantiate().

Before commit ce23e640133 "->getxattr(): pass dentry and inode as
separate arguments" and b96809173e9 "security_d_instantiate(): move to
the point prior to attaching dentry to inode", security_d_instantiate()
should be called beind __d_instantiate(), otherwise it will trigger
below problem when CONFIG_SECURITY_SMACK on ext4 was enabled because
d_inode(dentry) used by ->getxattr() is NULL before __d_instantiate()
instantiate inode.

[   31.858026] BUG: unable to handle kernel paging request at ffffffffffffff70
...
[   31.882024] Call Trace:
[   31.882378]  [<ffffffffa347f75c>] ext4_xattr_get+0x8c/0x3e0
[   31.883195]  [<ffffffffa3489454>] ext4_xattr_security_get+0x24/0x40
[   31.884086]  [<ffffffffa336a56b>] generic_getxattr+0x5b/0x90
[   31.884907]  [<ffffffffa3700514>] smk_fetch+0xb4/0x150
[   31.885634]  [<ffffffffa3700772>] smack_d_instantiate+0x1c2/0x550
[   31.886508]  [<ffffffffa36f9a5a>] security_d_instantiate+0x3a/0x80
[   31.887389]  [<ffffffffa3353b26>] d_instantiate_new+0x36/0x130
[   31.888223]  [<ffffffffa342b1ef>] ext4_mkdir+0x4af/0x6a0
[   31.888928]  [<ffffffffa3343470>] vfs_mkdir+0x100/0x280
[   31.889536]  [<ffffffffa334b086>] SyS_mkdir+0xb6/0x170
[   31.890255]  [<ffffffffa307c855>] ? trace_do_page_fault+0x95/0x2b0
[   31.891134]  [<ffffffffa3c5e078>] entry_SYSCALL_64_fastpath+0x18/0x73

Cc: <stable@vger.kernel.org> # 3.16, 4.4
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 5a1c36dc5d65..baa00718d8d1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1900,7 +1900,6 @@ void d_instantiate_new(struct dentry *entry, struct inode *inode)
 	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
 	BUG_ON(!inode);
 	lockdep_annotate_inode_mutex_key(inode);
-	security_d_instantiate(entry, inode);
 	spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
 	WARN_ON(!(inode->i_state & I_NEW));
@@ -1908,6 +1907,7 @@ void d_instantiate_new(struct dentry *entry, struct inode *inode)
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_NEW);
 	spin_unlock(&inode->i_lock);
+	security_d_instantiate(entry, inode);
 }
 EXPORT_SYMBOL(d_instantiate_new);
 
-- 
2.17.2

