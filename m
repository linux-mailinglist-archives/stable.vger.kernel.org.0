Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083B4DF5C
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfD2JZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:25:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38287 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbfD2JZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 05:25:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6C0B021C46;
        Mon, 29 Apr 2019 05:24:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Apr 2019 05:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PlNYB0
        eMZSBhkQfTdqrN0+DK/g/9nR/aa7BPJNu2O/I=; b=fBDwxbJ0xPD/IcLKkWJ4gu
        6cW19g3+RqjSX+eX1krHKRPov6RPaW3XD8VzIaGFFyGJPNfm00GtD5sPYE2ojI7l
        RrCQ2MzSDMGY+jC+GRINIYV5jPfYAtTk+zdGJq7DZWqjCc6samR3P8XluHT7gAgE
        IE4DeAJcbodkbgaxKUx1I8MpASyNz25sHlUU1C2oW3XzpsN8bgywUYkDHZRn/BCu
        Evre5IIMV3OFOJgMbWxsprZ4Vp1PpHV7JmJ+uSxgRLAmDJFbmoD2+LIIB0C1pNbA
        yciSEhs78xSmGTlTWbgCRhWFcvb6XEnc1dCdNRrneOFVn/MZtf15nx+p0KHgQEgw
        ==
X-ME-Sender: <xms:6MLGXPVbNREg_JGKpVuNkv35kn5j6kMhISElBj3rdBu5IVsSxUBcpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddriedvgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:6MLGXOCAs8WDrMmwfoCZNdURnf1DyGAte9Fq2_Yu3v080Jzt3ThsTA>
    <xmx:6MLGXEMyUWzRe7QxsGsMq2neONKPfNRufbxWcj7MKn_M7xQgp4pglg>
    <xmx:6MLGXNN96oXorAeL2hmSW_wkJ6PvU-EB5tbZp_hMILPNuHCRV3KRYA>
    <xmx:6cLGXGFYBDA-ya1ymIGn3Dpf8-L6vrx8yCUiEpMRotQEwETPhWClVg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0701CE4122;
        Mon, 29 Apr 2019 05:24:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/mm/radix: Make Radix require HUGETLB_PAGE" failed to apply to 4.9-stable tree
To:     mpe@ellerman.id.au, joel@jms.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Apr 2019 11:24:54 +0200
Message-ID: <155652989421647@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8adddf349fda0d3de2f6bb41ddf838cbf36a8ad2 Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Tue, 16 Apr 2019 23:59:02 +1000
Subject: [PATCH] powerpc/mm/radix: Make Radix require HUGETLB_PAGE

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

diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 5ba131c30f6b..1bcd468ab422 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -266,6 +266,7 @@ CONFIG_UDF_FS=m
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
 CONFIG_PROC_KCORE=y
+CONFIG_HUGETLBFS=y
 # CONFIG_MISC_FILESYSTEMS is not set
 # CONFIG_NETWORK_FILESYSTEMS is not set
 CONFIG_NLS=y
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 842b2c7e156a..50cd09b4e05d 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -324,7 +324,7 @@ config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
-	depends on PPC_BOOK3S_64
+	depends on PPC_BOOK3S_64 && HUGETLB_PAGE
 	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	default y
 	help

