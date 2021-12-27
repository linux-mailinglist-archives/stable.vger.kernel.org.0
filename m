Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C518B47FEF8
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbhL0PeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbhL0Pd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0943C061395;
        Mon, 27 Dec 2021 07:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D69B610B1;
        Mon, 27 Dec 2021 15:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A9AC36AEA;
        Mon, 27 Dec 2021 15:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619207;
        bh=TYv54ABICqyMaUhihBpGvRdfRiczI5DeUZfqcQ38I1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neSUzgc7ZyCkhKRTQOxaFq6ZHpH6aFNqbOk6B2ziqcjvzSRiExZNrTwljFsFB8VzX
         ZId1QqNpiEuzmfnzgASWTUPO/ZWBBtRnEubR+ao1cS3oBd9iRhenONlFmuxOlZYii/
         mtD2kbCMqLk6zgKy5GHh8BlkX6WNBOV6BhBdXHWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 30/38] f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()
Date:   Mon, 27 Dec 2021 16:31:07 +0100
Message-Id: <20211227151320.383972525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 5598b24efaf4892741c798b425d543e4bed357a1 upstream.

As Wenqing Liu reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215235

- Overview
page fault in f2fs_setxattr() when mount and operate on corrupted image

- Reproduce
tested on kernel 5.16-rc3, 5.15.X under root

1. unzip tmp7.zip
2. ./single.sh f2fs 7

Sometimes need to run the script several times

- Kernel dump
loop0: detected capacity change from 0 to 131072
F2FS-fs (loop0): Found nat_bits in checkpoint
F2FS-fs (loop0): Mounted with checkpoint version = 7548c2ee
BUG: unable to handle page fault for address: ffffe47bc7123f48
RIP: 0010:kfree+0x66/0x320
Call Trace:
 __f2fs_setxattr+0x2aa/0xc00 [f2fs]
 f2fs_setxattr+0xfa/0x480 [f2fs]
 __f2fs_set_acl+0x19b/0x330 [f2fs]
 __vfs_removexattr+0x52/0x70
 __vfs_removexattr_locked+0xb1/0x140
 vfs_removexattr+0x56/0x100
 removexattr+0x57/0x80
 path_removexattr+0xa3/0xc0
 __x64_sys_removexattr+0x17/0x20
 do_syscall_64+0x37/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The root cause is in __f2fs_setxattr(), we missed to do sanity check on
last xattr entry, result in out-of-bound memory access during updating
inconsistent xattr data of target inode.

After the fix, it can detect such xattr inconsistency as below:

F2FS-fs (loop11): inode (7) has invalid last xattr entry, entry_size: 60676
F2FS-fs (loop11): inode (8) has corrupted xattr
F2FS-fs (loop11): inode (8) has corrupted xattr
F2FS-fs (loop11): inode (8) has invalid last xattr entry, entry_size: 47736

Cc: stable@vger.kernel.org
Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[delete f2fs_err() call as it's not in older kernels - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -658,8 +658,15 @@ static int __f2fs_setxattr(struct inode
 	}
 
 	last = here;
-	while (!IS_XATTR_LAST_ENTRY(last))
+	while (!IS_XATTR_LAST_ENTRY(last)) {
+		if ((void *)(last) + sizeof(__u32) > last_base_addr ||
+			(void *)XATTR_NEXT_ENTRY(last) > last_base_addr) {
+			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
+			error = -EFSCORRUPTED;
+			goto exit;
+		}
 		last = XATTR_NEXT_ENTRY(last);
+	}
 
 	newsize = XATTR_ALIGN(sizeof(struct f2fs_xattr_entry) + len + size);
 


