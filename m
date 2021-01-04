Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC7B2E9AC8
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbhADP7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727971AbhADP7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F2662250F;
        Mon,  4 Jan 2021 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775910;
        bh=hwUyeNb9NGkxfnDkBWhFxs4Fh1afjms4BVH6fV3Jk0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yfj3YR/FCoVLitocwoucsCup9+3vcDFKXaZzFF+kQ5VOib18orfHRpdUqIdoRS6kM
         qCiT/ejTKPzNByU1DSMCRqnGGeUOBcKzGx4B5PwlX8hc8tMDzFjFO3RlQPgz6ionYI
         lgrTS7UY8bhEb+Mz+gX0sPoIK8DxIah5PTyvzyRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <petr.vorel@gmail.com>,
        Rich Felker <dalias@aerifal.cx>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 08/35] uapi: move constants from <linux/kernel.h> to <linux/const.h>
Date:   Mon,  4 Jan 2021 16:57:11 +0100
Message-Id: <20210104155703.796490875@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <petr.vorel@gmail.com>

commit a85cbe6159ffc973e5702f70a3bd5185f8f3c38d upstream.

and include <linux/const.h> in UAPI headers instead of <linux/kernel.h>.

The reason is to avoid indirect <linux/sysinfo.h> include when using
some network headers: <linux/netlink.h> or others -> <linux/kernel.h>
-> <linux/sysinfo.h>.

This indirect include causes on MUSL redefinition of struct sysinfo when
included both <sys/sysinfo.h> and some of UAPI headers:

    In file included from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/kernel.h:5,
                     from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/netlink.h:5,
                     from ../include/tst_netlink.h:14,
                     from tst_crypto.c:13:
    x86_64-buildroot-linux-musl/sysroot/usr/include/linux/sysinfo.h:8:8: error: redefinition of `struct sysinfo'
     struct sysinfo {
            ^~~~~~~
    In file included from ../include/tst_safe_macros.h:15,
                     from ../include/tst_test.h:93,
                     from tst_crypto.c:11:
    x86_64-buildroot-linux-musl/sysroot/usr/include/sys/sysinfo.h:10:8: note: originally defined here

Link: https://lkml.kernel.org/r/20201015190013.8901-1-petr.vorel@gmail.com
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Suggested-by: Rich Felker <dalias@aerifal.cx>
Acked-by: Rich Felker <dalias@libc.org>
Cc: Peter Korsgaard <peter@korsgaard.com>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/const.h              |    5 +++++
 include/uapi/linux/ethtool.h            |    2 +-
 include/uapi/linux/kernel.h             |    9 +--------
 include/uapi/linux/lightnvm.h           |    2 +-
 include/uapi/linux/mroute6.h            |    2 +-
 include/uapi/linux/netfilter/x_tables.h |    2 +-
 include/uapi/linux/netlink.h            |    2 +-
 include/uapi/linux/sysctl.h             |    2 +-
 8 files changed, 12 insertions(+), 14 deletions(-)

--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -28,4 +28,9 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 #endif /* _UAPI_LINUX_CONST_H */
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -14,7 +14,7 @@
 #ifndef _UAPI_LINUX_ETHTOOL_H
 #define _UAPI_LINUX_ETHTOOL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
--- a/include/uapi/linux/kernel.h
+++ b/include/uapi/linux/kernel.h
@@ -3,13 +3,6 @@
 #define _UAPI_LINUX_KERNEL_H
 
 #include <linux/sysinfo.h>
-
-/*
- * 'kernel.h' contains some often-used function prototypes etc
- */
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
-#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
-
-#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+#include <linux/const.h>
 
 #endif /* _UAPI_LINUX_KERNEL_H */
--- a/include/uapi/linux/lightnvm.h
+++ b/include/uapi/linux/lightnvm.h
@@ -21,7 +21,7 @@
 #define _UAPI_LINUX_LIGHTNVM_H
 
 #ifdef __KERNEL__
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/ioctl.h>
 #else /* __KERNEL__ */
 #include <stdio.h>
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI__LINUX_MROUTE6_H
 #define _UAPI__LINUX_MROUTE6_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/sockios.h>
 #include <linux/in6.h>		/* For struct sockaddr_in6. */
--- a/include/uapi/linux/netfilter/x_tables.h
+++ b/include/uapi/linux/netfilter/x_tables.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _UAPI_X_TABLES_H
 #define _UAPI_X_TABLES_H
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI__LINUX_NETLINK_H
 #define _UAPI__LINUX_NETLINK_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
 
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -23,7 +23,7 @@
 #ifndef _UAPI_LINUX_SYSCTL_H
 #define _UAPI_LINUX_SYSCTL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 


