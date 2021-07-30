Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345433DB33F
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbhG3GKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:10:09 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:52688 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhG3GKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 02:10:09 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 16U68MQF015935; Fri, 30 Jul 2021 15:08:22 +0900
X-Iguazu-Qid: 2wHHhCFIHKrnoxn31L
X-Iguazu-QSIG: v=2; s=0; t=1627625302; q=2wHHhCFIHKrnoxn31L; m=CQ1spBq7vH8y/x7jus5XFP829Zt2f5vcZJy3sv8JMq4=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1110) id 16U68CfA038173
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Jul 2021 15:08:14 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id D913E100138;
        Fri, 30 Jul 2021 15:08:12 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 16U68Bv0002703;
        Fri, 30 Jul 2021 15:08:11 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Matthew Wilcox <mawilcox@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Miller <davem@davemloft.net>,
        Ingo Molnar <mingo@elte.hu>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Minchan Kim <minchan@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Richard Henderson <rth@twiddle.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 1/2 for 4.4 and 4.9] lib/string.c: add multibyte memset functions
Date:   Fri, 30 Jul 2021 15:08:04 +0900
X-TSB-HOP: ON
Message-Id: <20210730060805.342577-2-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

commit 3b3c4babd898715926d24ae10aa64778ace33aae upstream.

Patch series "Multibyte memset variations", v4.

A relatively common idiom we're missing is a function to fill an area of
memory with a pattern which is larger than a single byte.  I first
noticed this with a zram patch which wanted to fill a page with an
'unsigned long' value.  There turn out to be quite a few places in the
kernel which can benefit from using an optimised function rather than a
loop; sometimes text size, sometimes speed, and sometimes both.  The
optimised PowerPC version (not included here) improves performance by
about 30% on POWER8 on just the raw memset_l().

Most of the extra lines of code come from the three testcases I added.

This patch (of 8):

memset16(), memset32() and memset64() are like memset(), but allow the
caller to fill the destination with a value larger than a single byte.
memset_l() and memset_p() allow the caller to use unsigned long and
pointer values respectively.

Link: http://lkml.kernel.org/r/20170720184539.31609-2-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 include/linux/string.h | 30 +++++++++++++++++++
 lib/string.c           | 66 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 66a91f5a344990..dd810d4739ee92 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -103,6 +103,36 @@ extern __kernel_size_t strcspn(const char *,const char *);
 #ifndef __HAVE_ARCH_MEMSET
 extern void * memset(void *,int,__kernel_size_t);
 #endif
+
+#ifndef __HAVE_ARCH_MEMSET16
+extern void *memset16(uint16_t *, uint16_t, __kernel_size_t);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET32
+extern void *memset32(uint32_t *, uint32_t, __kernel_size_t);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET64
+extern void *memset64(uint64_t *, uint64_t, __kernel_size_t);
+#endif
+
+static inline void *memset_l(unsigned long *p, unsigned long v,
+		__kernel_size_t n)
+{
+	if (BITS_PER_LONG == 32)
+		return memset32((uint32_t *)p, v, n);
+	else
+		return memset64((uint64_t *)p, v, n);
+}
+
+static inline void *memset_p(void **p, void *v, __kernel_size_t n)
+{
+	if (BITS_PER_LONG == 32)
+		return memset32((uint32_t *)p, (uintptr_t)v, n);
+	else
+		return memset64((uint64_t *)p, (uintptr_t)v, n);
+}
+
 #ifndef __HAVE_ARCH_MEMCPY
 extern void * memcpy(void *,const void *,__kernel_size_t);
 #endif
diff --git a/lib/string.c b/lib/string.c
index 8fe13371aed7ad..ec1ba61b358f21 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -754,6 +754,72 @@ void memzero_explicit(void *s, size_t count)
 }
 EXPORT_SYMBOL(memzero_explicit);
 
+#ifndef __HAVE_ARCH_MEMSET16
+/**
+ * memset16() - Fill a memory area with a uint16_t
+ * @s: Pointer to the start of the area.
+ * @v: The value to fill the area with
+ * @count: The number of values to store
+ *
+ * Differs from memset() in that it fills with a uint16_t instead
+ * of a byte.  Remember that @count is the number of uint16_ts to
+ * store, not the number of bytes.
+ */
+void *memset16(uint16_t *s, uint16_t v, size_t count)
+{
+	uint16_t *xs = s;
+
+	while (count--)
+		*xs++ = v;
+	return s;
+}
+EXPORT_SYMBOL(memset16);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET32
+/**
+ * memset32() - Fill a memory area with a uint32_t
+ * @s: Pointer to the start of the area.
+ * @v: The value to fill the area with
+ * @count: The number of values to store
+ *
+ * Differs from memset() in that it fills with a uint32_t instead
+ * of a byte.  Remember that @count is the number of uint32_ts to
+ * store, not the number of bytes.
+ */
+void *memset32(uint32_t *s, uint32_t v, size_t count)
+{
+	uint32_t *xs = s;
+
+	while (count--)
+		*xs++ = v;
+	return s;
+}
+EXPORT_SYMBOL(memset32);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET64
+/**
+ * memset64() - Fill a memory area with a uint64_t
+ * @s: Pointer to the start of the area.
+ * @v: The value to fill the area with
+ * @count: The number of values to store
+ *
+ * Differs from memset() in that it fills with a uint64_t instead
+ * of a byte.  Remember that @count is the number of uint64_ts to
+ * store, not the number of bytes.
+ */
+void *memset64(uint64_t *s, uint64_t v, size_t count)
+{
+	uint64_t *xs = s;
+
+	while (count--)
+		*xs++ = v;
+	return s;
+}
+EXPORT_SYMBOL(memset64);
+#endif
+
 #ifndef __HAVE_ARCH_MEMCPY
 /**
  * memcpy - Copy one area of memory to another
-- 
2.32.0


