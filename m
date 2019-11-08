Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B553F543C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbfKHSz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387450AbfKHSzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:55:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81A8221D7B;
        Fri,  8 Nov 2019 18:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239325;
        bh=cf4fThauuWxzmQyRZyubd1OD81i0Gk+jhsiMiQj+k+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upDs/OkAlHv95wWVd3Drv64qTdVOmlsuW4Wut7lIkJR7Pe7xlhlahxU5U8MXaHgra
         6v5DFoGdT9H17GLkfqhKkxi21CMhZH3u2ghKsKAs03uaIbx/B7XJBP6skX23VuFNp8
         PmN6VoIjByYosQpQMvhd+VjDHZoaz7M6nIIvPy0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH 4.4 75/75] fs/dcache: move security_d_instantiate() behind attaching dentry to inode
Date:   Fri,  8 Nov 2019 19:50:32 +0100
Message-Id: <20191108174814.283185120@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1903,7 +1903,6 @@ void d_instantiate_new(struct dentry *en
 	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
 	BUG_ON(!inode);
 	lockdep_annotate_inode_mutex_key(inode);
-	security_d_instantiate(entry, inode);
 	spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
 	WARN_ON(!(inode->i_state & I_NEW));
@@ -1911,6 +1910,7 @@ void d_instantiate_new(struct dentry *en
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_NEW);
 	spin_unlock(&inode->i_lock);
+	security_d_instantiate(entry, inode);
 }
 EXPORT_SYMBOL(d_instantiate_new);
 


