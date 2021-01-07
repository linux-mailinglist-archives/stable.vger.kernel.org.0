Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4442ED19C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbhAGORE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:17:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbhAGORE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B68D23381;
        Thu,  7 Jan 2021 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028970;
        bh=ZrJG1CK5QLyokx63d8Gk23TMDUVVoJlyI2g6KI7N+2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoNj4fQLP0U5rHRig8zA/rrDITElmSqy0HHCQRrWN1Ha5eZEE8s5IebDl7Ll2K4qq
         S8BKUA4JPXIjQsrDTnXi5JQKccs3APhSIOa6T1c8pUL0i8scvwbg3Glpb8nzvk9oCJ
         axbiXcAymxCiGLZj+EjMFbq3+b/lc46OFzWb+Crk=
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
Subject: [PATCH 4.4 09/19] uapi: move constants from <linux/kernel.h> to <linux/const.h>
Date:   Thu,  7 Jan 2021 15:16:34 +0100
Message-Id: <20210107140828.015078407@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
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
 include/uapi/linux/lightnvm.h           |    2 +-
 include/uapi/linux/netfilter/x_tables.h |    2 +-
 include/uapi/linux/netlink.h            |    2 +-
 include/uapi/linux/sysctl.h             |    2 +-
 5 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -24,4 +24,9 @@
 #define _BITUL(x)	(_AC(1,UL) << (x))
 #define _BITULL(x)	(_AC(1,ULL) << (x))
 
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 #endif /* !(_LINUX_CONST_H) */
--- a/include/uapi/linux/lightnvm.h
+++ b/include/uapi/linux/lightnvm.h
@@ -20,7 +20,7 @@
 #define _UAPI_LINUX_LIGHTNVM_H
 
 #ifdef __KERNEL__
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/ioctl.h>
 #else /* __KERNEL__ */
 #include <stdio.h>
--- a/include/uapi/linux/netfilter/x_tables.h
+++ b/include/uapi/linux/netfilter/x_tables.h
@@ -1,6 +1,6 @@
 #ifndef _UAPI_X_TABLES_H
 #define _UAPI_X_TABLES_H
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -1,7 +1,7 @@
 #ifndef _UAPI__LINUX_NETLINK_H
 #define _UAPI__LINUX_NETLINK_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
 
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -22,7 +22,7 @@
 #ifndef _UAPI_LINUX_SYSCTL_H
 #define _UAPI_LINUX_SYSCTL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 


