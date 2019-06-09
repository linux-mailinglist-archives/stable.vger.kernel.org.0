Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC343A99B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbfFIRAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387863AbfFIRAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:00:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD201206C3;
        Sun,  9 Jun 2019 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099631;
        bh=G80n0F+Jub0Dma2VG5Z03qSubqqOxsxpa/eWRIWiUCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YB5G3BQPps30ni1tZqi3PRCzlLkuOjsVa9J8a3D7PQHwN/af7RvKtI4H5J+/qph/m
         6R/16KLlEGLExGoud5kE9mhVEGxZx6eprm0sMvRRPvTDPauobWZHV5Ksoojhbw92/y
         sv7CeFUg9uLMmi69Xe1BkKYNjC55+lA85SDIsncQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 092/241] tools include: Adopt linux/bits.h
Date:   Sun,  9 Jun 2019 18:40:34 +0200
Message-Id: <20190609164150.446129635@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit ba4aa02b417f08a0bee5e7b8ed70cac788a7c854 upstream.

So that we reduce the difference of tools/include/linux/bitops.h to the
original kernel file, include/linux/bitops.h, trying to remove the need
to define BITS_PER_LONG, to avoid clashes with asm/bitsperlong.h.

And the things removed from tools/include/linux/bitops.h are really in
linux/bits.h, so that we can have a copy and then
tools/perf/check_headers.sh will tell us when new stuff gets added to
linux/bits.h so that we can check if it is useful and if any adjustment
needs to be done to the tools/{include,arch}/ copies.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: https://lkml.kernel.org/n/tip-y1sqyydvfzo0bjjoj4zsl562@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[bwh: Backported to 4.4 as dependency of "x86/msr-index: Cleanup bit defines":
 - Drop change in check-headers.sh
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/bitops.h |    7 ++-----
 tools/include/linux/bits.h   |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 5 deletions(-)
 create mode 100644 tools/include/linux/bits.h

--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -3,17 +3,14 @@
 
 #include <asm/types.h>
 #include <linux/kernel.h>
-#include <linux/compiler.h>
-
 #ifndef __WORDSIZE
 #define __WORDSIZE (__SIZEOF_LONG__ * 8)
 #endif
 
 #define BITS_PER_LONG __WORDSIZE
+#include <linux/bits.h>
+#include <linux/compiler.h>
 
-#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_PER_BYTE		8
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #define BITS_TO_U64(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
--- /dev/null
+++ b/tools/include/linux/bits.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_BITS_H
+#define __LINUX_BITS_H
+#include <asm/bitsperlong.h>
+
+#define BIT(nr)			(1UL << (nr))
+#define BIT_ULL(nr)		(1ULL << (nr))
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BIT_ULL_MASK(nr)	(1ULL << ((nr) % BITS_PER_LONG_LONG))
+#define BIT_ULL_WORD(nr)	((nr) / BITS_PER_LONG_LONG)
+#define BITS_PER_BYTE		8
+
+/*
+ * Create a contiguous bitmask starting at bit position @l and ending at
+ * position @h. For example
+ * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
+ */
+#define GENMASK(h, l) \
+	(((~0UL) - (1UL << (l)) + 1) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
+
+#define GENMASK_ULL(h, l) \
+	(((~0ULL) - (1ULL << (l)) + 1) & \
+	 (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
+
+#endif	/* __LINUX_BITS_H */


