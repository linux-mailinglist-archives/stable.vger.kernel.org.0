Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB8291506
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 01:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439880AbgJQXNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 19:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293D320878;
        Sat, 17 Oct 2020 23:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976418;
        bh=HS242CeKxVh1MmljEzFukdz2v+/3iS3zJnh37idj+xQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vaRz5bnSZs48U0meeCB9SzxTN8zGoOGOvAHbfLCExWl4sd+H44kJaI2owjxe3jJsR
         bzgp26I/6MRqs8v0+eI0emTs0ZJaTL/oLgm/djmsF+Lb/WoN3t3z4JqFC61rkbe5I2
         +SE7uqAR3mXNHeTQbIk/zgjKCa0txgJRK3id4EFc=
Date:   Sat, 17 Oct 2020 16:13:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fenghua.yu@intel.com, krzk@kernel.org,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 01/40] ia64: fix build error with !COREDUMP
Message-ID: <20201017231337.Vvr0NUSA4%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -40,7 +40,7 @@ obj-y				+= esi_stub.o	# must be in kern
 endif
 obj-$(CONFIG_INTEL_IOMMU)	+= pci-dma.o
 
-obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+obj-$(CONFIG_ELF_CORE)		+= elfcore.o
 
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31
_
