Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4243F2012D9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404011AbgFSPOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404004AbgFSPOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:14:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39634206FA;
        Fri, 19 Jun 2020 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579684;
        bh=Hf60rp90HUWVUFIFfuZLNvDgjwt/PHZip1HVKzN5zcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHIX1tTdKkJyVaH6dC9R5XMPmMkIoHL/qDgRm6K1QjKB4H023ZSdNE3i5DN0BC+KH
         0PH/qWssnrq4NIysZ6AKbYd1MHd+sbBar5iyJsmNRr5y5l7FPfSJtEAGtPJje2agRy
         S3v27Sn4dirxuCxOtPm5acoU7E8UZE9dfrNXNwes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 5.4 220/261] alpha: fix memory barriers so that they conform to the specification
Date:   Fri, 19 Jun 2020 16:33:51 +0200
Message-Id: <20200619141700.418471608@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 54505a1e2083fc54cbe8779b97479f969cd30a00 upstream.

The commits cd0e00c10672 and 92d7223a7423 broke boot on the Alpha Avanti
platform. The patches move memory barriers after a write before the write.
The result is that if there's iowrite followed by ioread, there is no
barrier between them.

The Alpha architecture allows reordering of the accesses to the I/O space,
and the missing barrier between write and read causes hang with serial
port and real time clock.

This patch makes barriers confiorm to the specification.

1. We add mb() before readX_relaxed and writeX_relaxed -
   memory-barriers.txt claims that these functions must be ordered w.r.t.
   each other. Alpha doesn't order them, so we need an explicit barrier.
2. We add mb() before reads from the I/O space - so that if there's a
   write followed by a read, there should be a barrier between them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: cd0e00c10672 ("alpha: io: reorder barriers to guarantee writeX() and iowriteX() ordering")
Fixes: 92d7223a7423 ("alpha: io: reorder barriers to guarantee writeX() and iowriteX() ordering #2")
Cc: stable@vger.kernel.org      # v4.17+
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Reviewed-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/include/asm/io.h |   74 +++++++++++++++++++++++++++++++++++---------
 arch/alpha/kernel/io.c      |   60 +++++++++++++++++++++++++++++++----
 2 files changed, 112 insertions(+), 22 deletions(-)

--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -322,14 +322,18 @@ static inline int __is_mmio(const volati
 #if IO_CONCAT(__IO_PREFIX,trivial_io_bw)
 extern inline unsigned int ioread8(void __iomem *addr)
 {
-	unsigned int ret = IO_CONCAT(__IO_PREFIX,ioread8)(addr);
+	unsigned int ret;
+	mb();
+	ret = IO_CONCAT(__IO_PREFIX,ioread8)(addr);
 	mb();
 	return ret;
 }
 
 extern inline unsigned int ioread16(void __iomem *addr)
 {
-	unsigned int ret = IO_CONCAT(__IO_PREFIX,ioread16)(addr);
+	unsigned int ret;
+	mb();
+	ret = IO_CONCAT(__IO_PREFIX,ioread16)(addr);
 	mb();
 	return ret;
 }
@@ -370,7 +374,9 @@ extern inline void outw(u16 b, unsigned
 #if IO_CONCAT(__IO_PREFIX,trivial_io_lq)
 extern inline unsigned int ioread32(void __iomem *addr)
 {
-	unsigned int ret = IO_CONCAT(__IO_PREFIX,ioread32)(addr);
+	unsigned int ret;
+	mb();
+	ret = IO_CONCAT(__IO_PREFIX,ioread32)(addr);
 	mb();
 	return ret;
 }
@@ -415,14 +421,18 @@ extern inline void __raw_writew(u16 b, v
 
 extern inline u8 readb(const volatile void __iomem *addr)
 {
-	u8 ret = __raw_readb(addr);
+	u8 ret;
+	mb();
+	ret = __raw_readb(addr);
 	mb();
 	return ret;
 }
 
 extern inline u16 readw(const volatile void __iomem *addr)
 {
-	u16 ret = __raw_readw(addr);
+	u16 ret;
+	mb();
+	ret = __raw_readw(addr);
 	mb();
 	return ret;
 }
@@ -463,14 +473,18 @@ extern inline void __raw_writeq(u64 b, v
 
 extern inline u32 readl(const volatile void __iomem *addr)
 {
-	u32 ret = __raw_readl(addr);
+	u32 ret;
+	mb();
+	ret = __raw_readl(addr);
 	mb();
 	return ret;
 }
 
 extern inline u64 readq(const volatile void __iomem *addr)
 {
-	u64 ret = __raw_readq(addr);
+	u64 ret;
+	mb();
+	ret = __raw_readq(addr);
 	mb();
 	return ret;
 }
@@ -499,14 +513,44 @@ extern inline void writeq(u64 b, volatil
 #define outb_p		outb
 #define outw_p		outw
 #define outl_p		outl
-#define readb_relaxed(addr)	__raw_readb(addr)
-#define readw_relaxed(addr)	__raw_readw(addr)
-#define readl_relaxed(addr)	__raw_readl(addr)
-#define readq_relaxed(addr)	__raw_readq(addr)
-#define writeb_relaxed(b, addr)	__raw_writeb(b, addr)
-#define writew_relaxed(b, addr)	__raw_writew(b, addr)
-#define writel_relaxed(b, addr)	__raw_writel(b, addr)
-#define writeq_relaxed(b, addr)	__raw_writeq(b, addr)
+
+extern u8 readb_relaxed(const volatile void __iomem *addr);
+extern u16 readw_relaxed(const volatile void __iomem *addr);
+extern u32 readl_relaxed(const volatile void __iomem *addr);
+extern u64 readq_relaxed(const volatile void __iomem *addr);
+
+#if IO_CONCAT(__IO_PREFIX,trivial_io_bw)
+extern inline u8 readb_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readb(addr);
+}
+
+extern inline u16 readw_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readw(addr);
+}
+#endif
+
+#if IO_CONCAT(__IO_PREFIX,trivial_io_lq)
+extern inline u32 readl_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readl(addr);
+}
+
+extern inline u64 readq_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readq(addr);
+}
+#endif
+
+#define writeb_relaxed	writeb
+#define writew_relaxed	writew
+#define writel_relaxed	writel
+#define writeq_relaxed	writeq
 
 /*
  * String version of IO memory access ops:
--- a/arch/alpha/kernel/io.c
+++ b/arch/alpha/kernel/io.c
@@ -16,21 +16,27 @@
 unsigned int
 ioread8(void __iomem *addr)
 {
-	unsigned int ret = IO_CONCAT(__IO_PREFIX,ioread8)(addr);
+	unsigned int ret;
+	mb();
+	ret = IO_CONCAT(__IO_PREFIX,ioread8)(addr);
 	mb();
 	return ret;
 }
 
 unsigned int ioread16(void __iomem *addr)
 {
-	unsigned int ret = IO_CONCAT(__IO_PREFIX,ioread16)(addr);
+	unsigned int ret;
+	mb();
+	ret = IO_CONCAT(__IO_PREFIX,ioread16)(addr);
 	mb();
 	return ret;
 }
 
 unsigned int ioread32(void __iomem *addr)
 {
-	unsigned int ret = IO_CONCAT(__IO_PREFIX,ioread32)(addr);
+	unsigned int ret;
+	mb();
+	ret = IO_CONCAT(__IO_PREFIX,ioread32)(addr);
 	mb();
 	return ret;
 }
@@ -148,28 +154,36 @@ EXPORT_SYMBOL(__raw_writeq);
 
 u8 readb(const volatile void __iomem *addr)
 {
-	u8 ret = __raw_readb(addr);
+	u8 ret;
+	mb();
+	ret = __raw_readb(addr);
 	mb();
 	return ret;
 }
 
 u16 readw(const volatile void __iomem *addr)
 {
-	u16 ret = __raw_readw(addr);
+	u16 ret;
+	mb();
+	ret = __raw_readw(addr);
 	mb();
 	return ret;
 }
 
 u32 readl(const volatile void __iomem *addr)
 {
-	u32 ret = __raw_readl(addr);
+	u32 ret;
+	mb();
+	ret = __raw_readl(addr);
 	mb();
 	return ret;
 }
 
 u64 readq(const volatile void __iomem *addr)
 {
-	u64 ret = __raw_readq(addr);
+	u64 ret;
+	mb();
+	ret = __raw_readq(addr);
 	mb();
 	return ret;
 }
@@ -207,6 +221,38 @@ EXPORT_SYMBOL(writew);
 EXPORT_SYMBOL(writel);
 EXPORT_SYMBOL(writeq);
 
+/*
+ * The _relaxed functions must be ordered w.r.t. each other, but they don't
+ * have to be ordered w.r.t. other memory accesses.
+ */
+u8 readb_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readb(addr);
+}
+
+u16 readw_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readw(addr);
+}
+
+u32 readl_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readl(addr);
+}
+
+u64 readq_relaxed(const volatile void __iomem *addr)
+{
+	mb();
+	return __raw_readq(addr);
+}
+
+EXPORT_SYMBOL(readb_relaxed);
+EXPORT_SYMBOL(readw_relaxed);
+EXPORT_SYMBOL(readl_relaxed);
+EXPORT_SYMBOL(readq_relaxed);
 
 /*
  * Read COUNT 8-bit bytes from port PORT into memory starting at SRC.


