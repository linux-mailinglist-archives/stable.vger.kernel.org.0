Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4536AD1E
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhDZHce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232469AbhDZHcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E9461041;
        Mon, 26 Apr 2021 07:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422312;
        bh=SejpZkOvEuNxy9DWg7cF9cEJ/0LLrSRzIr1jM0+6QHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uikXMk2UdFyCQf0QZHwlFKUw+J0y/5Ctgm4j8oSHz1ezpMB8hJ2UHrA+C3DTmQdSo
         kTWTjm4UHJIJnSgVNPNuzuNXfhfGzn0BUTZQlpzdrp8mfNPtkqRobbt4xSNlaQuO1Q
         cTC7csMP71dJF1uAw0cuwvW1PhMDLnmhbyJgJv7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 4.4 23/32] ext4: correct error label in ext4_rename()
Date:   Mon, 26 Apr 2021 09:29:21 +0200
Message-Id: <20210426072817.357814706@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

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

Fixes: 2fc8ce56985d ("ext4: do not iput inode under running transaction in ext4_rename()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3561,7 +3561,7 @@ static int ext4_rename(struct inode *old
 	    !ext4_is_child_context_consistent_with_parent(new.dir,
 							  old.inode)) {
 		retval = -EXDEV;
-		goto end_rename;
+		goto release_bh;
 	}
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,


