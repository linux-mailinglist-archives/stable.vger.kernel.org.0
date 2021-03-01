Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6462D327670
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 04:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhCADgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 22:36:00 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56662 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231614AbhCADf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 22:35:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tao.peng@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UPsbDNs_1614569716;
Received: from localhost(mailfrom:tao.peng@linux.alibaba.com fp:SMTPD_---0UPsbDNs_1614569716)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Mar 2021 11:35:16 +0800
From:   Peng Tao <tao.peng@linux.alibaba.com>
To:     alikernel-developer@linux.alibaba.com
Cc:     Liu Bo <bo.liu@linux.alibaba.com>,
        Ma Jie Yue <majieyue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eryu Guan <eguan@linux.alibaba.com>,
        Chirantan Ekbote <chirantan@chromium.org>,
        <stable@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <tao.peng@linux.alibaba.com>
Subject: [PATCH CK 4.19 4/4] fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS
Date:   Mon,  1 Mar 2021 11:36:19 +0800
Message-Id: <1614569779-12114-5-git-send-email-tao.peng@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614569779-12114-1-git-send-email-tao.peng@linux.alibaba.com>
References: <1614569779-12114-1-git-send-email-tao.peng@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chirantan Ekbote <chirantan@chromium.org>

commit 31070f6ccec09f3bd4f1e28cd1e592fa4f3ba0b6 upstream.

fix #32833505

The ioctl encoding for this parameter is a long but the documentation says
it should be an int and the kernel drivers expect it to be an int.  If the
fuse driver treats this as a long it might end up scribbling over the stack
of a userspace process that only allocated enough space for an int.

This was previously discussed in [1] and a patch for fuse was proposed in
[2].  From what I can tell the patch in [2] was nacked in favor of adding
new, "fixed" ioctls and using those from userspace.  However there is still
no "fixed" version of these ioctls and the fact is that it's sometimes
infeasible to change all userspace to use the new one.

Handling the ioctls specially in the fuse driver seems like the most
pragmatic way for fuse servers to support them without causing crashes in
userspace applications that call them.

[1]: https://lore.kernel.org/linux-fsdevel/20131126200559.GH20559@hall.aurel32.net/T/
[2]: https://sourceforge.net/p/fuse/mailman/message/31771759/

Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
Fixes: 59efec7b9039 ("fuse: implement ioctl support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 fs/fuse/file.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e02fafc..441e154 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -18,6 +18,7 @@
 #include <linux/swap.h>
 #include <linux/falloc.h>
 #include <linux/uio.h>
+#include <linux/fs.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -2544,7 +2545,16 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		struct iovec *iov = iov_page;
 
 		iov->iov_base = (void __user *)arg;
-		iov->iov_len = _IOC_SIZE(cmd);
+
+		switch (cmd) {
+		case FS_IOC_GETFLAGS:
+		case FS_IOC_SETFLAGS:
+			iov->iov_len = sizeof(int);
+			break;
+		default:
+			iov->iov_len = _IOC_SIZE(cmd);
+			break;
+		}
 
 		if (_IOC_DIR(cmd) & _IOC_WRITE) {
 			in_iov = iov;
-- 
1.8.3.1

