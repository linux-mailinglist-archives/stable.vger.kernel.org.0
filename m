Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7867436ADAC
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhDZHhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232710AbhDZHhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F21E613B3;
        Mon, 26 Apr 2021 07:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422499;
        bh=cF416N0V2tSCttz05ikvSHuSRAXfSfnmZXUNW/7Vgmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSm779GW7N/0cgypN1+5Y0p0MINzK27m8O5Q6qbM6+7i+SibSwlpLB8s5bvrHg6c4
         Thg6Wu7PLxUigTnyd20hi4EMO9WOUGJbHZfU8mG8YqL6CjjCb0CLi+EhScWLDuUHCQ
         ZBWw85rBbwqstdgafc1/sBq6sWT7ks/hLqSVucnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 4.14 38/49] ext4: correct error label in ext4_rename()
Date:   Mon, 26 Apr 2021 09:29:34 +0200
Message-Id: <20210426072821.019056109@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
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

Fixes: d962f1b4ef54 ("ext4: do not iput inode under running transaction in ext4_rename()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3641,7 +3641,7 @@ static int ext4_rename(struct inode *old
 	    ext4_encrypted_inode(new.dir) &&
 	    !fscrypt_has_permitted_context(new.dir, old.inode)) {
 		retval = -EXDEV;
-		goto end_rename;
+		goto release_bh;
 	}
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,


