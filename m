Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAEDF706
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbfD3Ltf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbfD3Lte (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E504D20449;
        Tue, 30 Apr 2019 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624973;
        bh=zNlQdbz+/oj7s2o7hZ2cj9AEuIuBVrfX/tbNdqzqbDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6hgt1E77TRi5aayr13iqcb3T65XCP0+p2HYVeso1XW1mOW9Psvdw/+6ohsBvRWE1
         0m/2CsaaeVTTAWjIDPjvUiw9XmtsPhbhsWEwZH+km2EYP7UTjVR8mUu8/jgtZfoY6f
         CRFPld13v2vf8H89KwID8pm8lpo9GwYMuTyprAD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.0 41/89] powerpc/mm/radix: Make Radix require HUGETLB_PAGE
Date:   Tue, 30 Apr 2019 13:38:32 +0200
Message-Id: <20190430113611.717806595@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8adddf349fda0d3de2f6bb41ddf838cbf36a8ad2 upstream.

Joel reported weird crashes using skiroot_defconfig, in his case we
jumped into an NX page:

  kernel tried to execute exec-protected page (c000000002bff4f0) - exploit attempt? (uid: 0)
  BUG: Unable to handle kernel instruction fetch
  Faulting instruction address: 0xc000000002bff4f0

Looking at the disassembly, we had simply branched to that address:

  c000000000c001bc  49fff335    bl     c000000002bff4f0

But that didn't match the original kernel image:

  c000000000c001bc  4bfff335    bl     c000000000bff4f0 <kobject_get+0x8>

When STRICT_KERNEL_RWX is enabled, and we're using the radix MMU, we
call radix__change_memory_range() late in boot to change page
protections. We do that both to mark rodata read only and also to mark
init text no-execute. That involves walking the kernel page tables,
and clearing _PAGE_WRITE or _PAGE_EXEC respectively.

With radix we may use hugepages for the linear mapping, so the code in
radix__change_memory_range() uses eg. pmd_huge() to test if it has
found a huge mapping, and if so it stops the page table walk and
changes the PMD permissions.

However if the kernel is built without HUGETLBFS support, pmd_huge()
is just a #define that always returns 0. That causes the code in
radix__change_memory_range() to incorrectly interpret the PMD value as
a pointer to a PTE page rather than as a PTE at the PMD level.

We can see this using `dv` in xmon which also uses pmd_huge():

  0:mon> dv c000000000000000
  pgd  @ 0xc000000001740000
  pgdp @ 0xc000000001740000 = 0x80000000ffffb009
  pudp @ 0xc0000000ffffb000 = 0x80000000ffffa009
  pmdp @ 0xc0000000ffffa000 = 0xc00000000000018f   <- this is a PTE
  ptep @ 0xc000000000000100 = 0xa64bb17da64ab07d   <- kernel text

The end result is we treat the value at 0xc000000000000100 as a PTE
and clear _PAGE_WRITE or _PAGE_EXEC, potentially corrupting the code
at that address.

In Joel's specific case we cleared the sign bit in the offset of the
branch, causing a backward branch to turn into a forward branch which
caused us to branch into a non-executable page. However the exact
nature of the crash depends on kernel version, compiler version, and
other factors.

We need to fix radix__change_memory_range() to not use accessors that
depend on HUGETLBFS, but we also have radix memory hotplug code that
uses pmd_huge() etc that will also need fixing. So for now just
disallow the broken combination of Radix with HUGETLBFS disabled.

The only defconfig we have that is affected is skiroot_defconfig, so
turn on HUGETLBFS there so that it still gets Radix.

Fixes: 566ca99af026 ("powerpc/mm/radix: Add dummy radix_enabled()")
Cc: stable@vger.kernel.org # v4.7+
Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/configs/skiroot_defconfig |    1 +
 arch/powerpc/platforms/Kconfig.cputype |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -260,6 +260,7 @@ CONFIG_UDF_FS=m
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
 CONFIG_PROC_KCORE=y
+CONFIG_HUGETLBFS=y
 # CONFIG_MISC_FILESYSTEMS is not set
 # CONFIG_NETWORK_FILESYSTEMS is not set
 CONFIG_NLS=y
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -318,7 +318,7 @@ config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
-	depends on PPC_BOOK3S_64
+	depends on PPC_BOOK3S_64 && HUGETLB_PAGE
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	default y
 	help


