Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96B12013AF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392863AbgFSQC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403893AbgFSPMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:12:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0678206FA;
        Fri, 19 Jun 2020 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579563;
        bh=X3PS0/wxR6yCVnl4QRI7pF8veBWqdjftrrWWgoB0L+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMN+WL83I75bTUNnftWgFr/MwN8LX3a9mCUne0Xp0PaQK5sz7L/wbR+3n0bEwcKDI
         WGp6vSnYG/dXgPHu0f60u1tVR9PZyP7gGU+a7qlaDll+iWHyU14kYvz61jTQ3gDZR1
         pamrgwtKNyDgkSNc2T92R6Y6/cMfsLV16ZjHgJic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.4 182/261] ext4: fix error pointer dereference
Date:   Fri, 19 Jun 2020 16:33:13 +0200
Message-Id: <20200619141658.643736204@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

commit 8418897f1bf87da0cb6936489d57a4320c32c0af upstream.

Don't pass error pointers to brelse().

commit 7159a986b420 ("ext4: fix some error pointer dereferences") has fixed
some cases, fix the remaining one case.

Once ext4_xattr_block_find()->ext4_sb_bread() failed, error pointer is
stored in @bs->bh, which will be passed to brelse() in the cleanup
routine of ext4_xattr_set_handle(). This will then cause a NULL panic
crash in __brelse().

BUG: unable to handle kernel NULL pointer dereference at 000000000000005b
RIP: 0010:__brelse+0x1b/0x50
Call Trace:
 ext4_xattr_set_handle+0x163/0x5d0
 ext4_xattr_set+0x95/0x110
 __vfs_setxattr+0x6b/0x80
 __vfs_setxattr_noperm+0x68/0x1b0
 vfs_setxattr+0xa0/0xb0
 setxattr+0x12c/0x1a0
 path_setxattr+0x8d/0xc0
 __x64_sys_setxattr+0x27/0x30
 do_syscall_64+0x60/0x250
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

In this case, @bs->bh stores '-EIO' actually.

Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: stable@kernel.org # 2.6.19
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/1587628004-95123-1-git-send-email-jefflexu@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1820,8 +1820,11 @@ ext4_xattr_block_find(struct inode *inod
 	if (EXT4_I(inode)->i_file_acl) {
 		/* The inode already has an extended attribute block. */
 		bs->bh = ext4_sb_bread(sb, EXT4_I(inode)->i_file_acl, REQ_PRIO);
-		if (IS_ERR(bs->bh))
-			return PTR_ERR(bs->bh);
+		if (IS_ERR(bs->bh)) {
+			error = PTR_ERR(bs->bh);
+			bs->bh = NULL;
+			return error;
+		}
 		ea_bdebug(bs->bh, "b_count=%d, refcount=%d",
 			atomic_read(&(bs->bh->b_count)),
 			le32_to_cpu(BHDR(bs->bh)->h_refcount));


