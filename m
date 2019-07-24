Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D586A73987
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388088AbfGXTlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390125AbfGXTlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2726520665;
        Wed, 24 Jul 2019 19:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997262;
        bh=5pYMZi43cfgf5K/yk6QuHCzJcaNc+Pw8Os70RoTAy1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jU5pn9Xg3+hNcpgQapBwvk+JGK271R7DjEK8/kqA/s0X6v74/7gB8/xw6MFtE+blv
         XvgfaFUMXog4LoJGN6svRXwcYvwFH/RvXiPLfA/byK/H6zuR7EVelpHZLG77tJ4lSd
         QH1utAs/uZW/I0LLGHJ6FHjGQpkNUYHClUglHj50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 376/413] mm/nvdimm: add is_ioremap_addr and use that to check ioremap address
Date:   Wed, 24 Jul 2019 21:21:07 +0200
Message-Id: <20190724191802.102043273@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 9bd3bb6703d8c0a5fb8aec8e3287bd55b7341dcd upstream.

Architectures like powerpc use different address range to map ioremap
and vmalloc range.  The memunmap() check used by the nvdimm layer was
wrongly using is_vmalloc_addr() to check for ioremap range which fails
for ppc64.  This result in ppc64 not freeing the ioremap mapping.  The
side effect of this is an unbind failure during module unload with
papr_scm nvdimm driver

Link: http://lkml.kernel.org/r/20190701134038.14165-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/pgtable.h |   14 ++++++++++++++
 include/linux/mm.h                 |    5 +++++
 kernel/iomem.c                     |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -140,6 +140,20 @@ static inline void pte_frag_set(mm_conte
 }
 #endif
 
+#ifdef CONFIG_PPC64
+#define is_ioremap_addr is_ioremap_addr
+static inline bool is_ioremap_addr(const void *x)
+{
+#ifdef CONFIG_MMU
+	unsigned long addr = (unsigned long)x;
+
+	return addr >= IOREMAP_BASE && addr < IOREMAP_END;
+#else
+	return false;
+#endif
+}
+#endif /* CONFIG_PPC64 */
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -633,6 +633,11 @@ static inline bool is_vmalloc_addr(const
 	return false;
 #endif
 }
+
+#ifndef is_ioremap_addr
+#define is_ioremap_addr(x) is_vmalloc_addr(x)
+#endif
+
 #ifdef CONFIG_MMU
 extern int is_vmalloc_or_module_addr(const void *x);
 #else
--- a/kernel/iomem.c
+++ b/kernel/iomem.c
@@ -121,7 +121,7 @@ EXPORT_SYMBOL(memremap);
 
 void memunmap(void *addr)
 {
-	if (is_vmalloc_addr(addr))
+	if (is_ioremap_addr(addr))
 		iounmap((void __iomem *) addr);
 }
 EXPORT_SYMBOL(memunmap);


