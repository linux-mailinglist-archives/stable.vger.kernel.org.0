Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DE43C4AA5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbhGLGxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239930AbhGLGuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 403AE61004;
        Mon, 12 Jul 2021 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072438;
        bh=M+7KL+MhXotuYuHWFd6yo8cNqW5Y9Up0QO3Dbt70Kr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUkKoZONLiR6cyZYPjqGkWsLzbv6sH4uimAD7inVPHqRZ9j+Xfik5ALsqUpMYbD3x
         3yMHGOjJgXQpHTSKKIot7+3aDxOiNCiZ7xCi1B3hjBUSpWKvCR9VpVRNAFpunOZnpi
         68eoSE90s4w7dOm8VHnwdp6xUtbcdBEwZ1XPLGAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 497/593] s390: enable HAVE_IOREMAP_PROT
Date:   Mon, 12 Jul 2021 08:10:57 +0200
Message-Id: <20210712060946.126430986@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit d460bb6c6417588dd8b0907d34f69b237918812a ]

In commit b02002cc4c0f ("s390/pci: Implement ioremap_wc/prot() with
MIO") we implemented both ioremap_wc() and ioremap_prot() however until
now we had not set HAVE_IOREMAP_PROT in Kconfig, do so now.

This also requires implementing pte_pgprot() as this is used in the
generic_access_phys() code enabled by CONFIG_HAVE_IOREMAP_PROT. As with
ioremap_wc() we need to take the MMIO Write Back bit index into account.

Moreover since the pgprot value returned from pte_pgprot() is to be used
for mappings into kernel address space we must make sure that it uses
appropriate kernel page table protection bits. In particular a pgprot
value originally coming from userspace could have the _PAGE_PROTECT
bit set to enable fault based dirty bit accounting which would then make
the mapping inaccessible when used in kernel address space.

Fixes: b02002cc4c0f ("s390/pci: Implement ioremap_wc/prot() with MIO")
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig               |  1 +
 arch/s390/include/asm/pgtable.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index dc5c3e6fd200..7105d44a335b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -154,6 +154,7 @@ config S390
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_VDSO
+	select HAVE_IOREMAP_PROT if PCI
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b5dbae78969b..2338345912a3 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -864,6 +864,25 @@ static inline int pte_unused(pte_t pte)
 	return pte_val(pte) & _PAGE_UNUSED;
 }
 
+/*
+ * Extract the pgprot value from the given pte while at the same time making it
+ * usable for kernel address space mappings where fault driven dirty and
+ * young/old accounting is not supported, i.e _PAGE_PROTECT and _PAGE_INVALID
+ * must not be set.
+ */
+static inline pgprot_t pte_pgprot(pte_t pte)
+{
+	unsigned long pte_flags = pte_val(pte) & _PAGE_CHG_MASK;
+
+	if (pte_write(pte))
+		pte_flags |= pgprot_val(PAGE_KERNEL);
+	else
+		pte_flags |= pgprot_val(PAGE_KERNEL_RO);
+	pte_flags |= pte_val(pte) & mio_wb_bit_mask;
+
+	return __pgprot(pte_flags);
+}
+
 /*
  * pgd/pmd/pte modification functions
  */
-- 
2.30.2



