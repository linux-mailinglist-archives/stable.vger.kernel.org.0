Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B4C2F43E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfE3Egb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbfE3DNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:00 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90EB72449A;
        Thu, 30 May 2019 03:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185979;
        bh=SbTFFUuSRSP005lrWiHb6QE2jPtSQRfWODw8nUneGEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKiLXXrf/nzsU3Qv1Xeu7rrJ2Ldu5pSLVYFIB03529IK73G2B8h6G6QuMsVPfTV6A
         ayCu6hDyIh6D3Lj6l0MNZGR8nT96mcA9gkgU9KOCsSfyVCrVMxANRFAVBgq3Vb5UFL
         FLEgqnzjUt/PY7YzaP33RCHhoxC5L95YuxmkjBxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5.0 014/346] arm64/kernel: kaslr: reduce module randomization range to 2 GB
Date:   Wed, 29 May 2019 20:01:27 -0700
Message-Id: <20190530030541.312633535@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@arm.com>

commit b2eed9b58811283d00fa861944cb75797d4e52a7 upstream.

The following commit

  7290d5809571 ("module: use relative references for __ksymtab entries")

updated the ksymtab handling of some KASLR capable architectures
so that ksymtab entries are emitted as pairs of 32-bit relative
references. This reduces the size of the entries, but more
importantly, it gets rid of statically assigned absolute
addresses, which require fixing up at boot time if the kernel
is self relocating (which takes a 24 byte RELA entry for each
member of the ksymtab struct).

Since ksymtab entries are always part of the same module as the
symbol they export, it was assumed at the time that a 32-bit
relative reference is always sufficient to capture the offset
between a ksymtab entry and its target symbol.

Unfortunately, this is not always true: in the case of per-CPU
variables, a per-CPU variable's base address (which usually differs
from the actual address of any of its per-CPU copies) is allocated
in the vicinity of the ..data.percpu section in the core kernel
(i.e., in the per-CPU reserved region which follows the section
containing the core kernel's statically allocated per-CPU variables).

Since we randomize the module space over a 4 GB window covering
the core kernel (based on the -/+ 4 GB range of an ADRP/ADD pair),
we may end up putting the core kernel out of the -/+ 2 GB range of
32-bit relative references of module ksymtab entries that refer to
per-CPU variables.

So reduce the module randomization range a bit further. We lose
1 bit of randomization this way, but this is something we can
tolerate.

Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/kaslr.c  |    6 +++---
 arch/arm64/kernel/module.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -145,15 +145,15 @@ u64 __init kaslr_early_init(u64 dt_phys)
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_MODULE_REGION_FULL)) {
 		/*
-		 * Randomize the module region over a 4 GB window covering the
+		 * Randomize the module region over a 2 GB window covering the
 		 * kernel. This reduces the risk of modules leaking information
 		 * about the address of the kernel itself, but results in
 		 * branches between modules and the core kernel that are
 		 * resolved via PLTs. (Branches between modules will be
 		 * resolved normally.)
 		 */
-		module_range = SZ_4G - (u64)(_end - _stext);
-		module_alloc_base = max((u64)_end + offset - SZ_4G,
+		module_range = SZ_2G - (u64)(_end - _stext);
+		module_alloc_base = max((u64)_end + offset - SZ_2G,
 					(u64)MODULES_VADDR);
 	} else {
 		/*
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -56,7 +56,7 @@ void *module_alloc(unsigned long size)
 		 * can simply omit this fallback in that case.
 		 */
 		p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_base + SZ_4G, GFP_KERNEL,
+				module_alloc_base + SZ_2G, GFP_KERNEL,
 				PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 


