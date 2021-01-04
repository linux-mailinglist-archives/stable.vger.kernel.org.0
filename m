Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A22E9A15
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbhADQCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbhADQCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3813207AE;
        Mon,  4 Jan 2021 16:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776109;
        bh=q9Q+DvzxGEMeJy831KMmzBCzYUFwM4Mf+Q89Q/DnXnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3O6TGq3LF1HvVLR9oVeKzWEP5AQH6MO+knnBeX0Q8xkwJFuOYF6cMP6Tqe3JqvTK
         miaIxuPhz0NqlAB8rBolRnywsa3u3ya/SqhRcAnCRIH1/sHX67877k2xtWZjzmJfGx
         ag4+/nbmkk5LMNk0A3+16aCGSEp1WAEoWYrCrUNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Acked-by: Ilya Leoshkevich" <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Zaslonko Mikhail <zaslonko@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 25/63] zlib: move EXPORT_SYMBOL() and MODULE_LICENSE() out of dfltcc_syms.c
Date:   Mon,  4 Jan 2021 16:57:18 +0100
Message-Id: <20210104155710.042752544@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 605cc30dea249edf1b659e7d0146a2cf13cbbf71 upstream.

In commit 11fb479ff5d9 ("zlib: export S390 symbols for zlib modules"), I
added EXPORT_SYMBOL()s to dfltcc_inflate.c but then Mikhail said that
these should probably be in dfltcc_syms.c with the other
EXPORT_SYMBOL()s.

However, that is contrary to the current kernel style, which places
EXPORT_SYMBOL() immediately after the function that it applies to, so
move all EXPORT_SYMBOL()s to their respective function locations and
drop the dfltcc_syms.c file.  Also move MODULE_LICENSE() from the
deleted file to dfltcc.c.

[rdunlap@infradead.org: remove dfltcc_syms.o from Makefile]
  Link: https://lkml.kernel.org/r/20201227171837.15492-1-rdunlap@infradead.org

Link: https://lkml.kernel.org/r/20201219052530.28461-1-rdunlap@infradead.org
Fixes: 11fb479ff5d9 ("zlib: export S390 symbols for zlib modules")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Zaslonko Mikhail <zaslonko@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/zlib_dfltcc/Makefile         |    2 +-
 lib/zlib_dfltcc/dfltcc.c         |    6 +++++-
 lib/zlib_dfltcc/dfltcc_deflate.c |    3 +++
 lib/zlib_dfltcc/dfltcc_syms.c    |   17 -----------------
 4 files changed, 9 insertions(+), 19 deletions(-)

--- a/lib/zlib_dfltcc/Makefile
+++ b/lib/zlib_dfltcc/Makefile
@@ -8,4 +8,4 @@
 
 obj-$(CONFIG_ZLIB_DFLTCC) += zlib_dfltcc.o
 
-zlib_dfltcc-objs := dfltcc.o dfltcc_deflate.o dfltcc_inflate.o dfltcc_syms.o
+zlib_dfltcc-objs := dfltcc.o dfltcc_deflate.o dfltcc_inflate.o
--- a/lib/zlib_dfltcc/dfltcc.c
+++ b/lib/zlib_dfltcc/dfltcc.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: Zlib
 /* dfltcc.c - SystemZ DEFLATE CONVERSION CALL support. */
 
-#include <linux/zutil.h>
+#include <linux/export.h>
+#include <linux/module.h>
 #include "dfltcc_util.h"
 #include "dfltcc.h"
 
@@ -53,3 +54,6 @@ void dfltcc_reset(
     dfltcc_state->dht_threshold = DFLTCC_DHT_MIN_SAMPLE_SIZE;
     dfltcc_state->param.ribm = DFLTCC_RIBM;
 }
+EXPORT_SYMBOL(dfltcc_reset);
+
+MODULE_LICENSE("GPL");
--- a/lib/zlib_dfltcc/dfltcc_deflate.c
+++ b/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -4,6 +4,7 @@
 #include "dfltcc_util.h"
 #include "dfltcc.h"
 #include <asm/setup.h>
+#include <linux/export.h>
 #include <linux/zutil.h>
 
 /*
@@ -34,6 +35,7 @@ int dfltcc_can_deflate(
 
     return 1;
 }
+EXPORT_SYMBOL(dfltcc_can_deflate);
 
 static void dfltcc_gdht(
     z_streamp strm
@@ -277,3 +279,4 @@ again:
         goto again; /* deflate() must use all input or all output */
     return 1;
 }
+EXPORT_SYMBOL(dfltcc_deflate);
--- a/lib/zlib_dfltcc/dfltcc_syms.c
+++ /dev/null
@@ -1,17 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * linux/lib/zlib_dfltcc/dfltcc_syms.c
- *
- * Exported symbols for the s390 zlib dfltcc support.
- *
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/zlib.h>
-#include "dfltcc.h"
-
-EXPORT_SYMBOL(dfltcc_can_deflate);
-EXPORT_SYMBOL(dfltcc_deflate);
-EXPORT_SYMBOL(dfltcc_reset);
-MODULE_LICENSE("GPL");


