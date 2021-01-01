Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A8F2E8586
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbhAAUXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbhAAUXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:23:34 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A955C061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:22:53 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n26so28859705eju.6
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XFRO8dWkqZuNx2+BqBM7nkOyVcjRycuuFLB3OQd4b5s=;
        b=tR23Gmq7X4rzYqjBoQlyqiDcJ0i3QGeYVRejZG9ZnGfeHxhZz6M6mZo7/8OK6qF+Vw
         cLuvHbBwZfWnrPSqtOeHMj+/o7YUQE43bWu/+mTNFY1kq9RxZZjZEJN08vHpxct/jN2c
         LDyAFW46lLrH1hahOkLTRnRjxI1QCv/o7oaD6EHHcfQzBB9bDN5ZZvAENpoGbiyvMq+N
         l7P6UdF1dX+rjTxuT8XUkMQSUVjrnqpcXn06Gbwb3c+62LWHA8YmnyvmLt5CYDu1izSY
         SIXvnnamrWatQQqjQZ3qwsf6IzvbRqzxJ4kA8F0OiSwkWSK2/F9XybNDqpHWTtLuMckB
         5BuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XFRO8dWkqZuNx2+BqBM7nkOyVcjRycuuFLB3OQd4b5s=;
        b=gFYsmdiOw6GzyaPRA6leEYAuMojSFNnmkFtUZMhgsugNJpnaVwqJoRcOHPco8gDTUT
         /sy7EApZ2Rtkyqrs95gM5IjcuXHubU7LW1dLFWr7B792iXCcF8MBexZfxEg7TPzNslFq
         yLjHyUgDjnFS59s3Ydz1hXT3csjf5rYAh9a+gPqeEX2L2mNABoxQ06OtVWKdG1+F0LlU
         AcXAzvtGmSR8twvkHw3obAZHeY5+1KG4I70CmajXhWup7V/j1PYEzcLC/dntALv7xAZT
         8HyYeFdTIJEbSw82yNcT1FgPkkzY7b00Ev+n0NaEb2VrlcObNWhf2KXHj2jloEbFhWQu
         eUvQ==
X-Gm-Message-State: AOAM5319zy5Ou8+iMudPqrbU+uPwkyxl5TKWE8r4+eTN3x28jE9G7G7E
        +hS7bBNfnUJlfZeBKZQI8Yei0Qdc9BspyA==
X-Google-Smtp-Source: ABdhPJxo/NUA5Ho1tEOZOCg7Q6G6Npp+a9JjZKenJ/wLisTBc4JCzHNg1xJnCca0Ouhg6uSE8qu1Cg==
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr5256999ejc.462.1609532572266;
        Fri, 01 Jan 2021 12:22:52 -0800 (PST)
Received: from localhost.localdomain ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id e27sm21214898ejm.60.2021.01.01.12.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:22:51 -0800 (PST)
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] uapi: move constants from <linux/kernel.h> to <linux/const.h>
Date:   Fri,  1 Jan 2021 21:22:44 +0100
Message-Id: <20210101202245.27409-1-petr.vorel@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

and include <linux/const.h> in UAPI headers instead of <linux/kernel.h>.

commit a85cbe6159ffc973e5702f70a3bd5185f8f3c38d upstream.

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
---
Hi,

could this fix be backported to stable releases?
Maybe safer to wait till v5.11 release.

Adjusted for stable/linux-5.4.y.

Kind regards,
Petr


 include/uapi/linux/const.h              | 5 +++++
 include/uapi/linux/ethtool.h            | 2 +-
 include/uapi/linux/kernel.h             | 9 +--------
 include/uapi/linux/lightnvm.h           | 2 +-
 include/uapi/linux/mroute6.h            | 2 +-
 include/uapi/linux/netfilter/x_tables.h | 2 +-
 include/uapi/linux/netlink.h            | 2 +-
 include/uapi/linux/sysctl.h             | 2 +-
 8 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/const.h b/include/uapi/linux/const.h
index 5ed721ad5b19..af2a44c08683 100644
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
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 8938b76c4ee3..7857aa413627 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -14,7 +14,7 @@
 #ifndef _UAPI_LINUX_ETHTOOL_H
 #define _UAPI_LINUX_ETHTOOL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
diff --git a/include/uapi/linux/kernel.h b/include/uapi/linux/kernel.h
index 0ff8f7477847..fadf2db71fe8 100644
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
diff --git a/include/uapi/linux/lightnvm.h b/include/uapi/linux/lightnvm.h
index f9a1be7fc696..ead2e72e5c88 100644
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
diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h
index c36177a86516..a1fd6173e2db 100644
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
diff --git a/include/uapi/linux/netfilter/x_tables.h b/include/uapi/linux/netfilter/x_tables.h
index a8283f7dbc51..b8c6bb233ac1 100644
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
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 0a4d73317759..622c78c821aa 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI__LINUX_NETLINK_H
 #define _UAPI__LINUX_NETLINK_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 87aa2a6d9125..cc453ed0e65e 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -23,7 +23,7 @@
 #ifndef _UAPI_LINUX_SYSCTL_H
 #define _UAPI_LINUX_SYSCTL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-- 
2.29.2

