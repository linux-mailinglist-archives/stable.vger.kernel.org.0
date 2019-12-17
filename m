Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFB8122029
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfLQAwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:52:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35632 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727256AbfLQAvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15O-0003Py-Gh; Tue, 17 Dec 2019 00:51:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15M-0005gV-1t; Tue, 17 Dec 2019 00:51:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "" <stable@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>
Date:   Tue, 17 Dec 2019 00:47:50 +0000
Message-ID: <lsq.1576543535.856402608@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 136/136] fs/dcache: move  security_d_instantiate()
 behind attaching dentry to inode
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangyi (F)" <yi.zhang@huawei.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1685,7 +1685,6 @@ void d_instantiate_new(struct dentry *en
 	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
 	BUG_ON(!inode);
 	lockdep_annotate_inode_mutex_key(inode);
-	security_d_instantiate(entry, inode);
 	spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
 	WARN_ON(!(inode->i_state & I_NEW));
@@ -1693,6 +1692,7 @@ void d_instantiate_new(struct dentry *en
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_NEW);
 	spin_unlock(&inode->i_lock);
+	security_d_instantiate(entry, inode);
 }
 EXPORT_SYMBOL(d_instantiate_new);
 

