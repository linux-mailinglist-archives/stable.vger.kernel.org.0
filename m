Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB02E858A
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbhAAU2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbhAAU2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:28:45 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF7FC0613C1
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:28:04 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ce23so28869655ejb.8
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UcmlkgNOk2dFt1Fn8MkJq959qiEnwp/mWHZm27xQmUE=;
        b=C5ewZGHx4Tnx4bsOcBmzu0E6KK+dvn600PTvqcm01WhdneCYnNlznjWnY9Y1Sf06jd
         Q5HzoENTl69jbSB8UmW6vTJnYGg4+xv+XOODKgMqOLi4eINHBSrELWfKSPrsSv3ZDLS0
         Yr9vArVpDwhoE7nzAmZpsZdDF+MRhA3WH0W9fK5A/qBCwyXjzmbzNqqOSfQ5aMOwmVB0
         hLIKFAZvwEyuprdDR9g13n4cM1peRqR776UD7qgdnIu7H7yiNMVauBTN+OwrN9c3MNJF
         ZPpL32V1/h51/hLzasOFxSY+9e40RbBPLO8Y7rLp3fE2i7bCIG5LtBJnMb9j7FTvz8G/
         5ezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UcmlkgNOk2dFt1Fn8MkJq959qiEnwp/mWHZm27xQmUE=;
        b=Wh85Eo7eL4ooGMW4z0SXfGwRuAnuQqFRzqwicB5tYe/W148K5cS6b4XVba5jOmbmLU
         2xrwBsrCEngYiWcEwh+n4ll7lmKBhKj14EBKApC8JRIyGtehtKnLRB3NKa0N/U9ur89c
         +IOy4dTiKqWAM4B7iH6mElcs54KEXW8eStOe2PGSkX/b9b7HaRj9uBGDk8I7234nI8yV
         td9rMi07OpThbifHiZQwnRiCfwmi4CzoB0erAnJuDUdFGqTsAOMnvfwdvFjWJ3l0adj/
         zpowm18DQwfnsJB1cg1qpBsZEPycRfhagKiSoUti+9hVEyhqpXF4sXrYxmmRwMhU35e/
         qBdg==
X-Gm-Message-State: AOAM532Qgb5+aVORzrgr5aZp/Oa9OkLX1KglFrsGwnQMhTnTMVCsQ28D
        Mt/bPXm9TQ+MQUjhAcajKhb3JMs8QL7W6g==
X-Google-Smtp-Source: ABdhPJzX7bEHUl52y4EBHn9nmRMdabUYlczJCd2nfCgRjlClh+KR33uVUDOmbf7dxpUwszswukWTUw==
X-Received: by 2002:a17:906:edca:: with SMTP id sb10mr58996259ejb.284.1609532883659;
        Fri, 01 Jan 2021 12:28:03 -0800 (PST)
Received: from localhost.localdomain ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id ld2sm21135378ejb.73.2021.01.01.12.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:28:03 -0800 (PST)
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
Date:   Fri,  1 Jan 2021 21:27:57 +0100
Message-Id: <20210101202758.28291-1-petr.vorel@gmail.com>
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

Adjusted for stable/linux-5.10.y.

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
index 9ca87bc73c44..cde753bb2093 100644
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
index c3816ff7bfc3..3d94269bbfa8 100644
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
index 27c1ed2822e6..458179df9b27 100644
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

