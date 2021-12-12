Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C985D47196D
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 10:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhLLJQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 04:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhLLJQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 04:16:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792A3C061714;
        Sun, 12 Dec 2021 01:16:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AB51FCE0B21;
        Sun, 12 Dec 2021 09:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F02AC341C6;
        Sun, 12 Dec 2021 09:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639300595;
        bh=FcCfq4bNjl8T6b/+8viEc5WUfvmEh89NrvoiU1a3sYo=;
        h=From:To:Cc:Subject:Date:From;
        b=nSylLWdl/51/bEM84CdSYtjLlUdiW90rNo5EfAtj691K6sfdOePWpG6Z8ekFpGEyE
         /xHtJVf+ui8eTKgyk3u6m8CK1EkoSA8R3xpyCX/dFa/Tnj4E4utDyqLaGi9uQ8Qkvu
         N6qCSEP4MR3oE7uXW4TOczO5b1FeJmxaQU7GZpRQgzDxrqvoGGqQVpwb+dYjjvxc3Q
         E0FmRVL/ICLoC6IWHg00wdqNNSA9zRjVO+R9eMsYKj+eeLlW/UeztUCtNof5Wh1ei3
         jvA3+EA5Ab7wRVqYUzAWrJgmrufy6MhvcYi4sYB2WpwulS+z5HBAIrSycwzMYWaW2j
         R43Bffk254rKQ==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>
Subject: [PATCH v3] f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()
Date:   Sun, 12 Dec 2021 17:16:30 +0800
Message-Id: <20211212091630.6325-1-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
v3:
- fix compile warning:
warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘long unsigned int’ [-Wformat=]
 fs/f2fs/xattr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index e348f33bcb2b..797ac505a075 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -684,8 +684,17 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	}
 
 	last = here;
-	while (!IS_XATTR_LAST_ENTRY(last))
+	while (!IS_XATTR_LAST_ENTRY(last)) {
+		if ((void *)(last) + sizeof(__u32) > last_base_addr ||
+			(void *)XATTR_NEXT_ENTRY(last) > last_base_addr) {
+			f2fs_err(F2FS_I_SB(inode), "inode (%lu) has invalid last xattr entry, entry_size: %zu",
+					inode->i_ino, ENTRY_SIZE(last));
+			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
+			error = -EFSCORRUPTED;
+			goto exit;
+		}
 		last = XATTR_NEXT_ENTRY(last);
+	}
 
 	newsize = XATTR_ALIGN(sizeof(struct f2fs_xattr_entry) + len + size);
 
-- 
2.32.0

