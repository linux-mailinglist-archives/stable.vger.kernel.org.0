Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41B9428EA6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbhJKNvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237273AbhJKNuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7081C60E78;
        Mon, 11 Oct 2021 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960101;
        bh=TlsljXNSGTRmUJEi2e28lyCPPXlU3cElKlNwMKMhxEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RakoWLwfTtBYiZUybaHzehihISxE/nwEev+0Sb4zbkVt3VDWr2gS7LsqXyHLe3OfZ
         Yso/2yJonhGueg3PaRl1SyLmhYrPahDjYqDe/EVncXJqHCPk8dpZeTcXhh/+jXlzlr
         NFfbZG0d+Gy5PhJKaznFDUmwJU1h79zRPG41cPXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/52] xtensa: move XCHAL_KIO_* definitions to kmem_layout.h
Date:   Mon, 11 Oct 2021 15:45:50 +0200
Message-Id: <20211011134504.449751617@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 6591685d50043f615a1ad7ddd5bb263ef54808fc ]

These address and size definitions define xtensa kernel memory layout,
move them from vectors.h to the kmem_layout.h

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/include/asm/kmem_layout.h | 29 ++++++++++++++++++
 arch/xtensa/include/asm/vectors.h     | 42 ++-------------------------
 2 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/arch/xtensa/include/asm/kmem_layout.h b/arch/xtensa/include/asm/kmem_layout.h
index 9c12babc016c..7cbf68ca7106 100644
--- a/arch/xtensa/include/asm/kmem_layout.h
+++ b/arch/xtensa/include/asm/kmem_layout.h
@@ -11,6 +11,7 @@
 #ifndef _XTENSA_KMEM_LAYOUT_H
 #define _XTENSA_KMEM_LAYOUT_H
 
+#include <asm/core.h>
 #include <asm/types.h>
 
 #ifdef CONFIG_MMU
@@ -65,6 +66,34 @@
 
 #endif
 
+/* KIO definition */
+
+#if XCHAL_HAVE_PTP_MMU
+#define XCHAL_KIO_CACHED_VADDR		0xe0000000
+#define XCHAL_KIO_BYPASS_VADDR		0xf0000000
+#define XCHAL_KIO_DEFAULT_PADDR		0xf0000000
+#else
+#define XCHAL_KIO_BYPASS_VADDR		XCHAL_KIO_PADDR
+#define XCHAL_KIO_DEFAULT_PADDR		0x90000000
+#endif
+#define XCHAL_KIO_SIZE			0x10000000
+
+#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_OF)
+#define XCHAL_KIO_PADDR			xtensa_get_kio_paddr()
+#ifndef __ASSEMBLY__
+extern unsigned long xtensa_kio_paddr;
+
+static inline unsigned long xtensa_get_kio_paddr(void)
+{
+	return xtensa_kio_paddr;
+}
+#endif
+#else
+#define XCHAL_KIO_PADDR			XCHAL_KIO_DEFAULT_PADDR
+#endif
+
+/* KERNEL_STACK definition */
+
 #ifndef CONFIG_KASAN
 #define KERNEL_STACK_SHIFT	13
 #else
diff --git a/arch/xtensa/include/asm/vectors.h b/arch/xtensa/include/asm/vectors.h
index 79fe3007919e..4220c6dac44f 100644
--- a/arch/xtensa/include/asm/vectors.h
+++ b/arch/xtensa/include/asm/vectors.h
@@ -21,50 +21,14 @@
 #include <asm/core.h>
 #include <asm/kmem_layout.h>
 
-#if XCHAL_HAVE_PTP_MMU
-#define XCHAL_KIO_CACHED_VADDR		0xe0000000
-#define XCHAL_KIO_BYPASS_VADDR		0xf0000000
-#define XCHAL_KIO_DEFAULT_PADDR		0xf0000000
-#else
-#define XCHAL_KIO_BYPASS_VADDR		XCHAL_KIO_PADDR
-#define XCHAL_KIO_DEFAULT_PADDR		0x90000000
-#endif
-#define XCHAL_KIO_SIZE			0x10000000
-
-#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_OF)
-#define XCHAL_KIO_PADDR			xtensa_get_kio_paddr()
-#ifndef __ASSEMBLY__
-extern unsigned long xtensa_kio_paddr;
-
-static inline unsigned long xtensa_get_kio_paddr(void)
-{
-	return xtensa_kio_paddr;
-}
-#endif
-#else
-#define XCHAL_KIO_PADDR			XCHAL_KIO_DEFAULT_PADDR
-#endif
-
-#if defined(CONFIG_MMU)
-
-#if XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY
-/* Image Virtual Start Address */
-#define KERNELOFFSET			(XCHAL_KSEG_CACHED_VADDR + \
-					 CONFIG_KERNEL_LOAD_ADDRESS - \
+#if defined(CONFIG_MMU) && XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY
+#define KERNELOFFSET			(CONFIG_KERNEL_LOAD_ADDRESS + \
+					 XCHAL_KSEG_CACHED_VADDR - \
 					 XCHAL_KSEG_PADDR)
 #else
 #define KERNELOFFSET			CONFIG_KERNEL_LOAD_ADDRESS
 #endif
 
-#else /* !defined(CONFIG_MMU) */
-  /* MMU Not being used - Virtual == Physical */
-
-/* Location of the start of the kernel text, _start */
-#define KERNELOFFSET			CONFIG_KERNEL_LOAD_ADDRESS
-
-
-#endif /* CONFIG_MMU */
-
 #define RESET_VECTOR1_VADDR		(XCHAL_RESET_VECTOR1_VADDR)
 #ifdef CONFIG_VECTORS_OFFSET
 #define VECBASE_VADDR			(KERNELOFFSET - CONFIG_VECTORS_OFFSET)
-- 
2.33.0



