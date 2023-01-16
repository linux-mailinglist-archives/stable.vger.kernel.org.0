Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752B166C5AF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjAPQIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjAPQIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:08:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0C724486
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E26D8B8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD77C433F2;
        Mon, 16 Jan 2023 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885152;
        bh=s0Hrw008Y5mWfgu2417VP5FHSLsAOjsocD+gR4QxLNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBBhrGMFWJWIKEs8cggiJHeuCCalBRYKu8GVUsDdl8h7/Uir01a+0ip4Dy/3Xjzdd
         DgvrRYo2WRZ5fBbDVNwMtbmiwXNvMdnadEfm0eQ0caoiv+YDk0BU2b3+W5rVHNOHsl
         N2w83Nez6jclhWlvEGR8gUa/nFwR1esn0yOSryrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/86] tools/nolibc/std: move the standard type definitions to std.h
Date:   Mon, 16 Jan 2023 16:51:34 +0100
Message-Id: <20230116154749.556503305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 967cce191f50090d5cbd3841ee2bbb7835afeae2 ]

The ordering of includes and definitions for now is a bit of a mess, as
for example asm/signal.h is included after int definitions, but plenty of
structures are defined later as they rely on other includes.

Let's move the standard type definitions to a dedicated file that is
included first. We also move NULL there. This way all other includes
are aware of it, and we can bring asm/signal.h back to the top of the
file.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/nolibc.h | 42 ++++--------------------------
 tools/include/nolibc/std.h    | 49 +++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 37 deletions(-)
 create mode 100644 tools/include/nolibc/std.h

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 7ba180651b17..41eb7e647238 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -81,7 +81,12 @@
  *
  */
 
+/* standard type definitions */
+#include "std.h"
+
+/* system includes */
 #include <asm/unistd.h>
+#include <asm/signal.h>  // for SIGCHLD
 #include <asm/ioctls.h>
 #include <asm/errno.h>
 #include <linux/fs.h>
@@ -104,40 +109,6 @@ static int errno;
  */
 #define MAX_ERRNO 4095
 
-/* Declare a few quite common macros and types that usually are in stdlib.h,
- * stdint.h, ctype.h, unistd.h and a few other common locations.
- */
-
-#define NULL ((void *)0)
-
-/* stdint types */
-typedef unsigned char       uint8_t;
-typedef   signed char        int8_t;
-typedef unsigned short     uint16_t;
-typedef   signed short      int16_t;
-typedef unsigned int       uint32_t;
-typedef   signed int        int32_t;
-typedef unsigned long long uint64_t;
-typedef   signed long long  int64_t;
-typedef unsigned long        size_t;
-typedef   signed long       ssize_t;
-typedef unsigned long     uintptr_t;
-typedef   signed long      intptr_t;
-typedef   signed long     ptrdiff_t;
-
-/* for stat() */
-typedef unsigned int          dev_t;
-typedef unsigned long         ino_t;
-typedef unsigned int         mode_t;
-typedef   signed int          pid_t;
-typedef unsigned int          uid_t;
-typedef unsigned int          gid_t;
-typedef unsigned long       nlink_t;
-typedef   signed long         off_t;
-typedef   signed long     blksize_t;
-typedef   signed long      blkcnt_t;
-typedef   signed long        time_t;
-
 /* for poll() */
 struct pollfd {
 	int fd;
@@ -246,9 +217,6 @@ struct stat {
 #define WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
 #define WIFEXITED(status)     (((status) & 0x7f) == 0)
 
-/* for SIGCHLD */
-#include <asm/signal.h>
-
 /* Below comes the architecture-specific code. For each architecture, we have
  * the syscall declarations and the _start code definition. This is the only
  * global part. On all architectures the kernel puts everything in the stack
diff --git a/tools/include/nolibc/std.h b/tools/include/nolibc/std.h
new file mode 100644
index 000000000000..1747ae125392
--- /dev/null
+++ b/tools/include/nolibc/std.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * Standard definitions and types for NOLIBC
+ * Copyright (C) 2017-2021 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_STD_H
+#define _NOLIBC_STD_H
+
+/* Declare a few quite common macros and types that usually are in stdlib.h,
+ * stdint.h, ctype.h, unistd.h and a few other common locations. Please place
+ * integer type definitions and generic macros here, but avoid OS-specific and
+ * syscall-specific stuff, as this file is expected to be included very early.
+ */
+
+/* note: may already be defined */
+#ifndef NULL
+#define NULL ((void *)0)
+#endif
+
+/* stdint types */
+typedef unsigned char       uint8_t;
+typedef   signed char        int8_t;
+typedef unsigned short     uint16_t;
+typedef   signed short      int16_t;
+typedef unsigned int       uint32_t;
+typedef   signed int        int32_t;
+typedef unsigned long long uint64_t;
+typedef   signed long long  int64_t;
+typedef unsigned long        size_t;
+typedef   signed long       ssize_t;
+typedef unsigned long     uintptr_t;
+typedef   signed long      intptr_t;
+typedef   signed long     ptrdiff_t;
+
+/* those are commonly provided by sys/types.h */
+typedef unsigned int          dev_t;
+typedef unsigned long         ino_t;
+typedef unsigned int         mode_t;
+typedef   signed int          pid_t;
+typedef unsigned int          uid_t;
+typedef unsigned int          gid_t;
+typedef unsigned long       nlink_t;
+typedef   signed long         off_t;
+typedef   signed long     blksize_t;
+typedef   signed long      blkcnt_t;
+typedef   signed long        time_t;
+
+#endif /* _NOLIBC_STD_H */
-- 
2.35.1



