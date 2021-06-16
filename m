Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5C3A8E46
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 03:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhFPBZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 21:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFPBZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 21:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74EB9613B1;
        Wed, 16 Jun 2021 01:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806617;
        bh=cQ5Kb9gWEq0bMnW5jOLwX9BtI78Ce3eUp25+8n3Txbc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M41VIRYU93KnEIWUjsZt9Po98wdAS99c2lpDVz12YGw/b0KUofySkvm1i9DrENV4s
         imTkPVP+rEh4paBbeMJ6Od7//Z30FQcyt8h0fsQE9X6tBHfa7oLcwZ4I469SHukSx+
         7WFH9KQeLH6P1Fm8BW4kRrkMCbSNcC5WyIAGavn4=
Date:   Tue, 15 Jun 2021 18:23:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anderson@redhat.com,
        benh@kernel.crashing.org, bhe@redhat.com,
        bhupesh.sharma@linaro.org, bp@alien8.de, catalin.marinas@arm.com,
        dyoung@redhat.com, james.morse@arm.com, k-hagio@ab.jp.nec.com,
        kernelfans@gmail.com, linux-mm@kvack.org, mark.rutland@arm.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paulus@samba.org, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 08/18] crash_core, vmcoreinfo: append
 'SECTION_SIZE_BITS' to vmcoreinfo
Message-ID: <20210616012336.mnhwEhLlA%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>
Subject: crash_core, vmcoreinfo: append 'SECTION_SIZE_BITS' to vmcoreinfo

As mentioned in kernel commit 1d50e5d0c505 ("crash_core, vmcoreinfo:
Append 'MAX_PHYSMEM_BITS' to vmcoreinfo"), SECTION_SIZE_BITS in the
formula:

    #define SECTIONS_SHIFT    (MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)

Besides SECTIONS_SHIFT, SECTION_SIZE_BITS is also used to calculate
PAGES_PER_SECTION in makedumpfile just like kernel.

Unfortunately, this arch-dependent macro SECTION_SIZE_BITS changes, e.g. 
recently in kernel commit f0b13ee23241 ("arm64/sparsemem: reduce
SECTION_SIZE_BITS").  But user space wants a stable interface to get this
info.  Such info is impossible to be deduced from a crashdump vmcore. 
Hence append SECTION_SIZE_BITS to vmcoreinfo.

Link: https://lkml.kernel.org/r/20210608103359.84907-1-kernelfans@gmail.com
Link: http://lists.infradead.org/pipermail/kexec/2021-June/022676.html
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc: Kazuhito Hagio <k-hagio@ab.jp.nec.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Boris Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Anderson <anderson@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/crash_core.c~crash_core-vmcoreinfo-append-section_size_bits-to-vmcoreinfo
+++ a/kernel/crash_core.c
@@ -464,6 +464,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
+	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);
_
