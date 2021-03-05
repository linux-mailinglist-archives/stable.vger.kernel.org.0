Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5482D32EA1F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhCEMgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232187AbhCEMgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:36:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96A9E65012;
        Fri,  5 Mar 2021 12:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947769;
        bh=9Vb74CyfXCeEeqp2+6MZ1+Pmi+kfzIRIdb8cWW/WKmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEyf+6S7d8w7MIuwn8Z0UhAnD8ZXaZ5Y2EsgiWEppXdNUkjw5CPy+kkggfguloHlo
         rE4zrFDEBaFY/DKzps2endYecE32eHbwbbklXzkTCt4tFAVN+/dOL2eXObynJn979o
         /zLEykyaAyYba9i74c+KjuPJhrmfiqGVVerdOcbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH 5.4 62/72] sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output
Date:   Fri,  5 Mar 2021 13:22:04 +0100
Message-Id: <20210305120900.372355512@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

commit 2efc459d06f1630001e3984854848a5647086232 upstream.

Output defects can exist in sysfs content using sprintf and snprintf.

sprintf does not know the PAGE_SIZE maximum of the temporary buffer
used for outputting sysfs content and it's possible to overrun the
PAGE_SIZE buffer length.

Add a generic sysfs_emit function that knows that the size of the
temporary buffer and ensures that no overrun is done.

Add a generic sysfs_emit_at function that can be used in multiple
call situations that also ensures that no overrun is done.

Validate the output buffer argument to be page aligned.
Validate the offset len argument to be within the PAGE_SIZE buf.

Signed-off-by: Joe Perches <joe@perches.com>
Link: https://lore.kernel.org/r/884235202216d464d61ee975f7465332c86f76b2.1600285923.git.joe@perches.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/sysfs.txt |    8 +----
 fs/sysfs/file.c                     |   55 ++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h               |   16 ++++++++++
 3 files changed, 74 insertions(+), 5 deletions(-)

--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -232,12 +232,10 @@ Other notes:
   is 4096. 
 
 - show() methods should return the number of bytes printed into the
-  buffer. This is the return value of scnprintf().
+  buffer.
 
-- show() must not use snprintf() when formatting the value to be
-  returned to user space. If you can guarantee that an overflow
-  will never happen you can use sprintf() otherwise you must use
-  scnprintf().
+- show() should only use sysfs_emit() or sysfs_emit_at() when formatting
+  the value to be returned to user space.
 
 - store() should return the number of bytes used from the buffer. If the
   entire buffer has been used, just return the count argument.
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
+#include <linux/mm.h>
 
 #include "sysfs.h"
 
@@ -558,3 +559,57 @@ void sysfs_remove_bin_file(struct kobjec
 	kernfs_remove_by_name(kobj->sd, attr->attr.name);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
+
+/**
+ *	sysfs_emit - scnprintf equivalent, aware of PAGE_SIZE buffer.
+ *	@buf:	start of PAGE_SIZE buffer.
+ *	@fmt:	format
+ *	@...:	optional arguments to @format
+ *
+ *
+ * Returns number of characters written to @buf.
+ */
+int sysfs_emit(char *buf, const char *fmt, ...)
+{
+	va_list args;
+	int len;
+
+	if (WARN(!buf || offset_in_page(buf),
+		 "invalid sysfs_emit: buf:%p\n", buf))
+		return 0;
+
+	va_start(args, fmt);
+	len = vscnprintf(buf, PAGE_SIZE, fmt, args);
+	va_end(args);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(sysfs_emit);
+
+/**
+ *	sysfs_emit_at - scnprintf equivalent, aware of PAGE_SIZE buffer.
+ *	@buf:	start of PAGE_SIZE buffer.
+ *	@at:	offset in @buf to start write in bytes
+ *		@at must be >= 0 && < PAGE_SIZE
+ *	@fmt:	format
+ *	@...:	optional arguments to @fmt
+ *
+ *
+ * Returns number of characters written starting at &@buf[@at].
+ */
+int sysfs_emit_at(char *buf, int at, const char *fmt, ...)
+{
+	va_list args;
+	int len;
+
+	if (WARN(!buf || offset_in_page(buf) || at < 0 || at >= PAGE_SIZE,
+		 "invalid sysfs_emit_at: buf:%p at:%d\n", buf, at))
+		return 0;
+
+	va_start(args, fmt);
+	len = vscnprintf(buf + at, PAGE_SIZE - at, fmt, args);
+	va_end(args);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(sysfs_emit_at);
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -310,6 +310,11 @@ static inline void sysfs_enable_ns(struc
 	return kernfs_enable_ns(kn);
 }
 
+__printf(2, 3)
+int sysfs_emit(char *buf, const char *fmt, ...);
+__printf(3, 4)
+int sysfs_emit_at(char *buf, int at, const char *fmt, ...);
+
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
@@ -522,6 +527,17 @@ static inline void sysfs_enable_ns(struc
 {
 }
 
+__printf(2, 3)
+static inline int sysfs_emit(char *buf, const char *fmt, ...)
+{
+	return 0;
+}
+
+__printf(3, 4)
+static inline int sysfs_emit_at(char *buf, int at, const char *fmt, ...)
+{
+	return 0;
+}
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,


