Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12F0D4794
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfJKS2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 14:28:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33599 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfJKS2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 14:28:18 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iIzdj-0008R6-29; Fri, 11 Oct 2019 20:27:47 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 953461C0324;
        Fri, 11 Oct 2019 20:27:46 +0200 (CEST)
Date:   Fri, 11 Oct 2019 18:27:46 -0000
From:   "tip-bot2 for Steve Wahl" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot/64: Make level2_kernel_pgt pages invalid
 outside kernel area
Cc:     Steve Wahl <steve.wahl@hpe.com>, Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Baoquan He <bhe@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dimitri.sivanich@hpe.com, Feng Tang <feng.tang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jordan Borgner <mail@jordan-borgner.de>,
        Juergen Gross <jgross@suse.com>, mike.travis@hpe.com,
        russ.anderson@hpe.com, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86-ml" <x86@kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <9c011ee51b081534a7a15065b1681d200298b530.1569358539.git.steve.wahl@hpe.com>
References: <9c011ee51b081534a7a15065b1681d200298b530.1569358539.git.steve.wahl@hpe.com>
MIME-Version: 1.0
Message-ID: <157081846655.9978.8543242326238590954.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     2aa85f246c181b1fa89f27e8e20c5636426be624
Gitweb:        https://git.kernel.org/tip/2aa85f246c181b1fa89f27e8e20c5636426be624
Author:        Steve Wahl <steve.wahl@hpe.com>
AuthorDate:    Tue, 24 Sep 2019 16:03:55 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 11 Oct 2019 18:38:15 +02:00

x86/boot/64: Make level2_kernel_pgt pages invalid outside kernel area

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
---
 arch/x86/kernel/head64.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 29ffa49..206a4b6 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -222,13 +222,31 @@ unsigned long __head __startup_64(unsigned long physaddr,
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
