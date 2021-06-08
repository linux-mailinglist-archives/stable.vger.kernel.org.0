Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF083A0597
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 23:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhFHVQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 17:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhFHVQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 17:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF1E96139A;
        Tue,  8 Jun 2021 21:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623186858;
        bh=5ENbWZzoJaZh+uraKcpFyBD+U1tY8idYFliuLEEi4ik=;
        h=Date:From:To:Subject:From;
        b=JIAK38A9z86GOyvnmitcrn18gkROIU0QjdEauQQjSfbxVQSDH6cVIxl6FGnmgO68T
         OqtT0+zP5phziOKG/vaknj1aakeejViW+ZETxN/WYd56l7wnvo6LmQ9KkTW+7AIUb6
         ExHdbX0Fl6Ny/VzOPJMLRD0ugxh4FABrCrsnaITY=
Date:   Tue, 08 Jun 2021 14:14:17 -0700
From:   akpm@linux-foundation.org
To:     anderson@redhat.com, benh@kernel.crashing.org, bhe@redhat.com,
        bhupesh.sharma@linaro.org, bp@alien8.de, catalin.marinas@arm.com,
        dyoung@redhat.com, james.morse@arm.com, k-hagio@ab.jp.nec.com,
        kernelfans@gmail.com, mark.rutland@arm.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        stable@vger.kernel.org, tglx@linutronix.de, will@kernel.org
Subject:  +
 crash_core-vmcoreinfo-append-section_size_bits-to-vmcoreinfo.patch added to
 -mm tree
Message-ID: <20210608211417.XF2pYHaX0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: crash_core, vmcoreinfo: append 'SECTION_SIZE_BITS' to vmcoreinfo
has been added to the -mm tree.  Its filename is
     crash_core-vmcoreinfo-append-section_size_bits-to-vmcoreinfo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/crash_core-vmcoreinfo-append-section_size_bits-to-vmcoreinfo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/crash_core-vmcoreinfo-append-section_size_bits-to-vmcoreinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kernelfans@gmail.com are

crash_core-vmcoreinfo-append-section_size_bits-to-vmcoreinfo.patch

