Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CE1E66F8
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbfJ0VQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbfJ0VQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:53 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C6742070B;
        Sun, 27 Oct 2019 21:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211012;
        bh=3BnMbfPndXojbnIO/KjTzKqKNjsSSST0nsbkX7y7L8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Af4mmmGRO75jtl5t4QMnrBw8oVAcsXG48ax5ak1s+m9OSnyaqxFehH5UaxLw3Pdyu
         zQ66BbB4NDNSEFqKAyM9Y8f7De+6cK+/hGt7NKSRJu45mzn7Pblzq5uxOFuKYPZlyB
         gbGEoDDeleTaZHuX44fNKFEIJIclhuYBgosNE97M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Wahl <steve.wahl@hpe.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Baoquan He <bhe@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dimitri.sivanich@hpe.com, Feng Tang <feng.tang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jordan Borgner <mail@jordan-borgner.de>,
        Juergen Gross <jgross@suse.com>, mike.travis@hpe.com,
        russ.anderson@hpe.com, Thomas Gleixner <tglx@linutronix.de>,
        x86-ml <x86@kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH 4.19 79/93] x86/boot/64: Make level2_kernel_pgt pages invalid outside kernel area
Date:   Sun, 27 Oct 2019 22:01:31 +0100
Message-Id: <20191027203312.260206025@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Wahl <steve.wahl@hpe.com>

commit 2aa85f246c181b1fa89f27e8e20c5636426be624 upstream.

Our hardware (UV aka Superdome Flex) has address ranges marked
reserved by the BIOS. Access to these ranges is caught as an error,
causing the BIOS to halt the system.

Initial page tables mapped a large range of physical addresses that
were not checked against the list of BIOS reserved addresses, and
sometimes included reserved addresses in part of the mapped range.
Including the reserved range in the map allowed processor speculative
accesses to the reserved range, triggering a BIOS halt.

Used early in booting, the page table level2_kernel_pgt addresses 1
GiB divided into 2 MiB pages, and it was set up to linearly map a full
 1 GiB of physical addresses that included the physical address range
of the kernel image, as chosen by KASLR.  But this also included a
large range of unused addresses on either side of the kernel image.
And unlike the kernel image's physical address range, this extra
mapped space was not checked against the BIOS tables of usable RAM
addresses.  So there were times when the addresses chosen by KASLR
would result in processor accessible mappings of BIOS reserved
physical addresses.

The kernel code did not directly access any of this extra mapped
space, but having it mapped allowed the processor to issue speculative
accesses into reserved memory, causing system halts.

This was encountered somewhat rarely on a normal system boot, and much
more often when starting the crash kernel if "crashkernel=512M,high"
was specified on the command line (this heavily restricts the physical
address of the crash kernel, in our case usually within 1 GiB of
reserved space).

The solution is to invalidate the pages of this table outside the kernel
image's space before the page table is activated. It fixes this problem
on our hardware.

 [ bp: Touchups. ]

Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: dimitri.sivanich@hpe.com
Cc: Feng Tang <feng.tang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jordan Borgner <mail@jordan-borgner.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: mike.travis@hpe.com
Cc: russ.anderson@hpe.com
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Link: https://lkml.kernel.org/r/9c011ee51b081534a7a15065b1681d200298b530.1569358539.git.steve.wahl@hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/head64.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -222,13 +222,31 @@ unsigned long __head __startup_64(unsign
 	 * we might write invalid pmds, when the kernel is relocated
 	 * cleanup_highmap() fixes this up along with the mappings
 	 * beyond _end.
+	 *
+	 * Only the region occupied by the kernel image has so far
+	 * been checked against the table of usable memory regions
+	 * provided by the firmware, so invalidate pages outside that
+	 * region. A page table entry that maps to a reserved area of
+	 * memory would allow processor speculation into that area,
+	 * and on some hardware (particularly the UV platform) even
+	 * speculative access to some reserved areas is caught as an
+	 * error, causing the BIOS to halt the system.
 	 */
 
 	pmd = fixup_pointer(level2_kernel_pgt, physaddr);
-	for (i = 0; i < PTRS_PER_PMD; i++) {
+
+	/* invalidate pages before the kernel image */
+	for (i = 0; i < pmd_index((unsigned long)_text); i++)
+		pmd[i] &= ~_PAGE_PRESENT;
+
+	/* fixup pages that are part of the kernel image */
+	for (; i <= pmd_index((unsigned long)_end); i++)
 		if (pmd[i] & _PAGE_PRESENT)
 			pmd[i] += load_delta;
-	}
+
+	/* invalidate pages after the kernel image */
+	for (; i < PTRS_PER_PMD; i++)
+		pmd[i] &= ~_PAGE_PRESENT;
 
 	/*
 	 * Fixup phys_base - remove the memory encryption mask to obtain


