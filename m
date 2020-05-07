Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121811C9802
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgEGRja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgEGRja (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:39:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA2A20A8B;
        Thu,  7 May 2020 17:39:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jWkUa-000Dld-Gb; Thu, 07 May 2020 13:39:28 -0400
Message-ID: <20200507173928.398791252@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 07 May 2020 13:39:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 1/9] bootconfig: Fix to remove bootconfig data from initrd while boot
References: <20200507173904.729935165@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

If there is a bootconfig data in the tail of initrd/initramfs,
initrd image sanity check caused an error while decompression
stage as follows.

[    0.883882] Unpacking initramfs...
[    2.696429] Initramfs unpacking failed: invalid magic at start of compressed archive

This error will be ignored if CONFIG_BLK_DEV_RAM=n,
but CONFIG_BLK_DEV_RAM=y the kernel failed to mount rootfs
and causes a panic.

To fix this issue, shrink down the initrd_end for removing
tailing bootconfig data while boot the kernel.

Link: http://lkml.kernel.org/r/158788401014.24243.17424755854115077915.stgit@devnote2

Cc: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: 7684b8582c24 ("bootconfig: Load boot config from the tail of initrd")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 init/main.c | 69 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/init/main.c b/init/main.c
index a48617f2e5e5..1a5da2c2660c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -257,6 +257,47 @@ static int __init loglevel(char *str)
 
 early_param("loglevel", loglevel);
 
+#ifdef CONFIG_BLK_DEV_INITRD
+static void * __init get_boot_config_from_initrd(u32 *_size, u32 *_csum)
+{
+	u32 size, csum;
+	char *data;
+	u32 *hdr;
+
+	if (!initrd_end)
+		return NULL;
+
+	data = (char *)initrd_end - BOOTCONFIG_MAGIC_LEN;
+	if (memcmp(data, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN))
+		return NULL;
+
+	hdr = (u32 *)(data - 8);
+	size = hdr[0];
+	csum = hdr[1];
+
+	data = ((void *)hdr) - size;
+	if ((unsigned long)data < initrd_start) {
+		pr_err("bootconfig size %d is greater than initrd size %ld\n",
+			size, initrd_end - initrd_start);
+		return NULL;
+	}
+
+	/* Remove bootconfig from initramfs/initrd */
+	initrd_end = (unsigned long)data;
+	if (_size)
+		*_size = size;
+	if (_csum)
+		*_csum = csum;
+
+	return data;
+}
+#else
+static void * __init get_boot_config_from_initrd(u32 *_size, u32 *_csum)
+{
+	return NULL;
+}
+#endif
+
 #ifdef CONFIG_BOOT_CONFIG
 
 char xbc_namebuf[XBC_KEYLEN_MAX] __initdata;
@@ -357,9 +398,12 @@ static void __init setup_boot_config(const char *cmdline)
 	int pos;
 	u32 size, csum;
 	char *data, *copy;
-	u32 *hdr;
 	int ret;
 
+	data = get_boot_config_from_initrd(&size, &csum);
+	if (!data)
+		goto not_found;
+
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	parse_args("bootconfig", tmp_cmdline, NULL, 0, 0, 0, NULL,
 		   bootconfig_params);
@@ -367,27 +411,12 @@ static void __init setup_boot_config(const char *cmdline)
 	if (!bootconfig_found)
 		return;
 
-	if (!initrd_end)
-		goto not_found;
-
-	data = (char *)initrd_end - BOOTCONFIG_MAGIC_LEN;
-	if (memcmp(data, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN))
-		goto not_found;
-
-	hdr = (u32 *)(data - 8);
-	size = hdr[0];
-	csum = hdr[1];
-
 	if (size >= XBC_DATA_MAX) {
 		pr_err("bootconfig size %d greater than max size %d\n",
 			size, XBC_DATA_MAX);
 		return;
 	}
 
-	data = ((void *)hdr) - size;
-	if ((unsigned long)data < initrd_start)
-		goto not_found;
-
 	if (boot_config_checksum((unsigned char *)data, size) != csum) {
 		pr_err("bootconfig checksum failed\n");
 		return;
@@ -420,8 +449,14 @@ static void __init setup_boot_config(const char *cmdline)
 not_found:
 	pr_err("'bootconfig' found on command line, but no bootconfig found\n");
 }
+
 #else
-#define setup_boot_config(cmdline)	do { } while (0)
+
+static void __init setup_boot_config(const char *cmdline)
+{
+	/* Remove bootconfig data from initrd */
+	get_boot_config_from_initrd(NULL, NULL);
+}
 
 static int __init warn_bootconfig(char *str)
 {
-- 
2.26.2


