Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46746226B96
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgGTPmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgGTPmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:42:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8A7320773;
        Mon, 20 Jul 2020 15:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259769;
        bh=k2UT7uagiliQDfjyRsMa9yjUVZz/9q3qcrZoCBnozWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKYKZeTuKuMe1CLngheOirndc7bdLvqTux7riM+ptfnV2fz1qDvZMXqSUi8W2tRZG
         eQXyXfZeUaJ3XSufOyPNrmk7Z7SOIogITGuEMdPg1ZPXSFTaNCWSxieeuTer/ejgyv
         pIZYsc9orULUlu7jGLUSMnuaWx7GkbzGd8KCneYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chirantan Ekbote <chirantan@chromium.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.9 74/86] fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS
Date:   Mon, 20 Jul 2020 17:37:10 +0200
Message-Id: <20200720152756.924482252@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chirantan Ekbote <chirantan@chromium.org>

commit 31070f6ccec09f3bd4f1e28cd1e592fa4f3ba0b6 upstream.

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

---
 fs/fuse/file.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -17,6 +17,7 @@
 #include <linux/swap.h>
 #include <linux/falloc.h>
 #include <linux/uio.h>
+#include <linux/fs.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -2520,7 +2521,16 @@ long fuse_do_ioctl(struct file *file, un
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


