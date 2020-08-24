Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6C24F788
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgHXJPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730444AbgHXI4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865EA2072D;
        Mon, 24 Aug 2020 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259360;
        bh=Nsx1/QnVpUDV33+SrioDmlhfg5tkM9R+Pa91bvw0w0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZL9XanfOWUYS2qawffEXVrNil69tPIgTz6vJS5PkKOEGpCv9OZPix+5s2STDnpLo
         O+hSS8cKduBmVj/rlIaqJWhud2/AXjHV0+p++2m4wGTSC6FWPHdmJwKgUq7xxkYBzR
         3AvZ0tcL/EVTTti5Dnh+xw77jUYDCSiRVQXUy620=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhe Li <lizhe67@huawei.com>,
        Hou Tao <houtao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/71] jffs2: fix UAF problem
Date:   Mon, 24 Aug 2020 10:31:21 +0200
Message-Id: <20200824082357.391119905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhe Li <lizhe67@huawei.com>

[ Upstream commit 798b7347e4f29553db4b996393caf12f5b233daf ]

The log of UAF problem is listed below.
BUG: KASAN: use-after-free in jffs2_rmdir+0xa4/0x1cc [jffs2] at addr c1f165fc
Read of size 4 by task rm/8283
=============================================================================
BUG kmalloc-32 (Tainted: P    B      O   ): kasan: bad access detected
-----------------------------------------------------------------------------

INFO: Allocated in 0xbbbbbbbb age=3054364 cpu=0 pid=0
        0xb0bba6ef
        jffs2_write_dirent+0x11c/0x9c8 [jffs2]
        __slab_alloc.isra.21.constprop.25+0x2c/0x44
        __kmalloc+0x1dc/0x370
        jffs2_write_dirent+0x11c/0x9c8 [jffs2]
        jffs2_do_unlink+0x328/0x5fc [jffs2]
        jffs2_rmdir+0x110/0x1cc [jffs2]
        vfs_rmdir+0x180/0x268
        do_rmdir+0x2cc/0x300
        ret_from_syscall+0x0/0x3c
INFO: Freed in 0x205b age=3054364 cpu=0 pid=0
        0x2e9173
        jffs2_add_fd_to_list+0x138/0x1dc [jffs2]
        jffs2_add_fd_to_list+0x138/0x1dc [jffs2]
        jffs2_garbage_collect_dirent.isra.3+0x21c/0x288 [jffs2]
        jffs2_garbage_collect_live+0x16bc/0x1800 [jffs2]
        jffs2_garbage_collect_pass+0x678/0x11d4 [jffs2]
        jffs2_garbage_collect_thread+0x1e8/0x3b0 [jffs2]
        kthread+0x1a8/0x1b0
        ret_from_kernel_thread+0x5c/0x64
Call Trace:
[c17ddd20] [c02452d4] kasan_report.part.0+0x298/0x72c (unreliable)
[c17ddda0] [d2509680] jffs2_rmdir+0xa4/0x1cc [jffs2]
[c17dddd0] [c026da04] vfs_rmdir+0x180/0x268
[c17dde00] [c026f4e4] do_rmdir+0x2cc/0x300
[c17ddf40] [c001a658] ret_from_syscall+0x0/0x3c

The root cause is that we don't get "jffs2_inode_info.sem" before
we scan list "jffs2_inode_info.dents" in function jffs2_rmdir.
This patch add codes to get "jffs2_inode_info.sem" before we scan
"jffs2_inode_info.dents" to slove the UAF problem.

Signed-off-by: Zhe Li <lizhe67@huawei.com>
Reviewed-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index f20cff1194bb6..776493713153f 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -590,10 +590,14 @@ static int jffs2_rmdir (struct inode *dir_i, struct dentry *dentry)
 	int ret;
 	uint32_t now = JFFS2_NOW();
 
+	mutex_lock(&f->sem);
 	for (fd = f->dents ; fd; fd = fd->next) {
-		if (fd->ino)
+		if (fd->ino) {
+			mutex_unlock(&f->sem);
 			return -ENOTEMPTY;
+		}
 	}
+	mutex_unlock(&f->sem);
 
 	ret = jffs2_do_unlink(c, dir_f, dentry->d_name.name,
 			      dentry->d_name.len, f, now);
-- 
2.25.1



