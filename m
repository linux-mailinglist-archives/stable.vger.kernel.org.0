Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B323C4F92
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbhGLH0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343835AbhGLHYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:24:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A544F6140F;
        Mon, 12 Jul 2021 07:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074471;
        bh=bcB3nMSciNpF5lim5unmyHce8opSUYrNDvmjECH1mV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+QWAvQyPymiD69ACkuS/Qx0HG7JCiw63zis6fbTVze8AMRQOHAU1HCp40TzjVLoo
         IPYmUB7M+9s78T9WgjEvn0FOD5CYgEVI8Fw9bOy4WGECooRPlPh6KFmMWFrgGJvj9r
         iZPQQhj9QuY7lBBkOrBvoGBRE6AvCr1E1f3Lm8SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 592/700] s390: enable HAVE_IOREMAP_PROT
Date:   Mon, 12 Jul 2021 08:11:15 +0200
Message-Id: <20210712061038.955542316@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index c1ff874e6c2e..d6676197276c 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -160,6 +160,7 @@ config S390
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_VDSO
+	select HAVE_IOREMAP_PROT if PCI
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b38f7b781564..adea53f69bfd 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -863,6 +863,25 @@ static inline int pte_unused(pte_t pte)
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



