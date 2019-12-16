Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B651214C9
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbfLPSOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731274AbfLPSOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00968206B7;
        Mon, 16 Dec 2019 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520086;
        bh=7yDn2V6zu56CJCV4PFrB+CcvjiJrjdv3u4o/Atw8PsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNApgVVBC7mKVFKUf9rRMSfW+CFYeZqJKYiJ389noSEENbxzejYL8sml/NF/c+tyB
         fS25xpJi0VhNO+GNMUDQUtYbSkjWJ/q/dMqNJAv+gea0W82W0En4POtL6onRfdtn3Y
         M+YsTSMR0VoLe7x9VlNrfPeXKnm8vctzHHvFGvp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 011/177] compat_ioctl: add compat_ptr_ioctl()
Date:   Mon, 16 Dec 2019 18:47:47 +0100
Message-Id: <20191216174815.127036832@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 2952db0fd51b0890f728df94ac563c21407f4f43 upstream.

Many drivers have ioctl() handlers that are completely compatible between
32-bit and 64-bit architectures, except for the argument that is passed
down from user space and may have to be passed through compat_ptr()
in order to become a valid 64-bit pointer.

Using ".compat_ptr = compat_ptr_ioctl" in file operations should let
us simplify a lot of those drivers to avoid #ifdef checks, and convert
additional drivers that don't have proper compat handling yet.

On most architectures, the compat_ptr_ioctl() just passes all arguments
to the corresponding ->ioctl handler. The exception is arch/s390, where
compat_ptr() clears the top bit of a 32-bit pointer value, so user space
pointers to the second 2GB alias the first 2GB, as is the case for native
32-bit s390 user space.

The compat_ptr_ioctl() function must therefore be used only with
ioctl functions that either ignore the argument or pass a pointer to a
compatible data type.

If any ioctl command handled by fops->unlocked_ioctl passes a plain
integer instead of a pointer, or any of the passed data types is
incompatible between 32-bit and 64-bit architectures, a proper handler
is required instead of compat_ptr_ioctl.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v3: add a better description
v2: use compat_ptr_ioctl instead of generic_compat_ioctl_ptrarg,
as suggested by Al Viro
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ioctl.c         |   35 +++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    7 +++++++
 2 files changed, 42 insertions(+)

--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -8,6 +8,7 @@
 #include <linux/syscalls.h>
 #include <linux/mm.h>
 #include <linux/capability.h>
+#include <linux/compat.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/security.h>
@@ -719,3 +720,37 @@ SYSCALL_DEFINE3(ioctl, unsigned int, fd,
 {
 	return ksys_ioctl(fd, cmd, arg);
 }
+
+#ifdef CONFIG_COMPAT
+/**
+ * compat_ptr_ioctl - generic implementation of .compat_ioctl file operation
+ *
+ * This is not normally called as a function, but instead set in struct
+ * file_operations as
+ *
+ *     .compat_ioctl = compat_ptr_ioctl,
+ *
+ * On most architectures, the compat_ptr_ioctl() just passes all arguments
+ * to the corresponding ->ioctl handler. The exception is arch/s390, where
+ * compat_ptr() clears the top bit of a 32-bit pointer value, so user space
+ * pointers to the second 2GB alias the first 2GB, as is the case for
+ * native 32-bit s390 user space.
+ *
+ * The compat_ptr_ioctl() function must therefore be used only with ioctl
+ * functions that either ignore the argument or pass a pointer to a
+ * compatible data type.
+ *
+ * If any ioctl command handled by fops->unlocked_ioctl passes a plain
+ * integer instead of a pointer, or any of the passed data types
+ * is incompatible between 32-bit and 64-bit architectures, a proper
+ * handler is required instead of compat_ptr_ioctl.
+ */
+long compat_ptr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	if (!file->f_op->unlocked_ioctl)
+		return -ENOIOCTLCMD;
+
+	return file->f_op->unlocked_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+EXPORT_SYMBOL(compat_ptr_ioctl);
+#endif
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1727,6 +1727,13 @@ int vfs_mkobj(struct dentry *, umode_t,
 
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
+#ifdef CONFIG_COMPAT
+extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
+					unsigned long arg);
+#else
+#define compat_ptr_ioctl NULL
+#endif
+
 /*
  * VFS file helper functions.
  */


