Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF4E24A613
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 20:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgHSSg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 14:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSSg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 14:36:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABF8320658;
        Wed, 19 Aug 2020 18:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597862185;
        bh=Sr+YQc/ZD/a1tvYxhh12zNoYcDgKbi/Gm2goAZkxqBM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oteiuLFeuwobNGhOHveSDY7CuU6Wt5b6qjQDcmdjM1Mdbp3WuEavnfdHNSAMwskUZ
         zCqzW4s8ctBpOQ0PQWTM9Agss7RlccXFAgOCVrf0Hd40q1CrqK55808/IJ3KCvdkd8
         X6G3PsBYSiRnYuvUWGlVvlqb3IjojqJ3VMUVL3H8=
Date:   Wed, 19 Aug 2020 11:36:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     fenghua.yu@intel.com, krzk@kernel.org, lkp@intel.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com
Subject:  + ia64-fix-build-error-with-coredump.patch added to -mm
 tree
Message-ID: <20200819183625.szXpQfuMb%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ia64: fix build error with !COREDUMP
has been added to the -mm tree.  Its filename is
     ia64-fix-build-error-with-coredump.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-build-error-with-coredump.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-build-error-with-coredump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: ia64: fix build error with !COREDUMP

Fix linkage error when CONFIG_BINFMT_ELF is selected but CONFIG_COREDUMP
is not:

    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_phdrs':
    elfcore.c:(.text+0x172): undefined reference to `dump_emit'
    ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_data':
    elfcore.c:(.text+0x2b2): undefined reference to `dump_emit'

Link: https://lkml.kernel.org/r/20200819064146.12529-1-krzk@kernel.org
Fixes: 1fcccbac89f5 ("elf coredump: replace ELF_CORE_EXTRA_* macros by functions")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/Makefile~ia64-fix-build-error-with-coredump
+++ a/arch/ia64/kernel/Makefile
@@ -41,7 +41,7 @@ obj-y				+= esi_stub.o	# must be in kern
 endif
 obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 
-obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+obj-$(CONFIG_ELF_CORE)		+= elfcore.o
 
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31
_

Patches currently in -mm which might be from krzk@kernel.org are

ia64-fix-build-error-with-coredump.patch

