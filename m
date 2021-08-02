Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3C03DD7E2
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhHBNs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234359AbhHBNsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5585B60527;
        Mon,  2 Aug 2021 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912077;
        bh=IdsctHln3L3h4CE1F5Ksk5EmzdsNzY+kCctty/2yTnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJ0Fc593cI38Ie516lYgDUP2s3Z7KOejzH5hgzV/SY33gSaDnMKkisKr/bvBP6gmU
         enPayxBsWh/Mjd6nFMHT3gq71JAStq7WM0De2GCP/oApeUyeF558ftWZqpT9NbXtnC
         /tx2qfbn6HOxICIMkdZawEkeXo8spkplOqCqhnsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>,
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
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.9 13/32] lib/string.c: add multibyte memset functions
Date:   Mon,  2 Aug 2021 15:44:33 +0200
Message-Id: <20210802134333.346882923@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/string.h |   30 ++++++++++++++++++++++
 lib/string.c           |   66 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -103,6 +103,36 @@ extern __kernel_size_t strcspn(const cha
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
--- a/lib/string.c
+++ b/lib/string.c
@@ -754,6 +754,72 @@ void memzero_explicit(void *s, size_t co
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


