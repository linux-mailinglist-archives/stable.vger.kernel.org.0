Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4624F347E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiDEKG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344277AbiDEJTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4B510B9;
        Tue,  5 Apr 2022 02:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72170B81B75;
        Tue,  5 Apr 2022 09:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B1AC385A1;
        Tue,  5 Apr 2022 09:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149619;
        bh=M5tS/9vv/uIRvx67Td8JRZGoPjU2mKc0WyaZ+vfFFbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0AYHlMz1rCNVCvRcKuuwSn0+tgPDsT6+MWb+qB+dSZIjb7RT13MovIK31ZqKG/lA
         x3aYsEjPTMRgRdnMk5oMw3bcy05tBU2kYvu8zeTNzvMZ947G51FEkNrISRLGiZYEwg
         gjlkj+ryr13nHfhHtOwkgLbW7xOa3jxrU5QmKYWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0780/1017] parisc: Fix handling off probe non-access faults
Date:   Tue,  5 Apr 2022 09:28:13 +0200
Message-Id: <20220405070417.410743498@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit e00b0a2ab8ec019c344e53bfc76e31c18bb587b7 ]

Currently, the parisc kernel does not fully support non-access TLB
fault handling for probe instructions. In the fast path, we set the
target register to zero if it is not a shadowed register. The slow
path is not implemented, so we call do_page_fault. The architecture
indicates that non-access faults should not cause a page fault from
disk.

This change adds to code to provide non-access fault support for
probe instructions. It also modifies the handling of faults on
userspace so that if the address lies in a valid VMA and the access
type matches that for the VMA, the probe target register is set to
one. Otherwise, the target register is set to zero.

This was done to make probe instructions more useful for userspace.
Probe instructions are not very useful if they set the target register
to zero whenever a page is not present in memory. Nominally, the
purpose of the probe instruction is determine whether read or write
access to a given address is allowed.

This fixes a problem in function pointer comparison noticed in the
glibc testsuite (stdio-common/tst-vfprintf-user-type). The same
problem is likely in glibc (_dl_lookup_address).

V2 adds flush and lpa instruction support to handle_nadtlb_fault.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/traps.h |  1 +
 arch/parisc/kernel/traps.c      |  2 +
 arch/parisc/mm/fault.c          | 89 +++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+)

diff --git a/arch/parisc/include/asm/traps.h b/arch/parisc/include/asm/traps.h
index 34619f010c63..0ccdb738a9a3 100644
--- a/arch/parisc/include/asm/traps.h
+++ b/arch/parisc/include/asm/traps.h
@@ -18,6 +18,7 @@ unsigned long parisc_acctyp(unsigned long code, unsigned int inst);
 const char *trap_name(unsigned long code);
 void do_page_fault(struct pt_regs *regs, unsigned long code,
 		unsigned long address);
+int handle_nadtlb_fault(struct pt_regs *regs);
 #endif
 
 #endif
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index eb41fece1910..b56aab7141ed 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -662,6 +662,8 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 			 by hand. Technically we need to emulate:
 			 fdc,fdce,pdc,"fic,4f",prober,probeir,probew, probeiw
 		*/
+		if (code == 17 && handle_nadtlb_fault(regs))
+			return;
 		fault_address = regs->ior;
 		fault_space = regs->isr;
 		break;
diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index 4a6221b869fd..22ffe11cec72 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -424,3 +424,92 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 		goto no_context;
 	pagefault_out_of_memory();
 }
+
+/* Handle non-access data TLB miss faults.
+ *
+ * For probe instructions, accesses to userspace are considered allowed
+ * if they lie in a valid VMA and the access type matches. We are not
+ * allowed to handle MM faults here so there may be situations where an
+ * actual access would fail even though a probe was successful.
+ */
+int
+handle_nadtlb_fault(struct pt_regs *regs)
+{
+	unsigned long insn = regs->iir;
+	int breg, treg, xreg, val = 0;
+	struct vm_area_struct *vma, *prev_vma;
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	unsigned long address;
+	unsigned long acc_type;
+
+	switch (insn & 0x380) {
+	case 0x280:
+		/* FDC instruction */
+		fallthrough;
+	case 0x380:
+		/* PDC and FIC instructions */
+		if (printk_ratelimit()) {
+			pr_warn("BUG: nullifying cache flush/purge instruction\n");
+			show_regs(regs);
+		}
+		if (insn & 0x20) {
+			/* Base modification */
+			breg = (insn >> 21) & 0x1f;
+			xreg = (insn >> 16) & 0x1f;
+			if (breg && xreg)
+				regs->gr[breg] += regs->gr[xreg];
+		}
+		regs->gr[0] |= PSW_N;
+		return 1;
+
+	case 0x180:
+		/* PROBE instruction */
+		treg = insn & 0x1f;
+		if (regs->isr) {
+			tsk = current;
+			mm = tsk->mm;
+			if (mm) {
+				/* Search for VMA */
+				address = regs->ior;
+				mmap_read_lock(mm);
+				vma = find_vma_prev(mm, address, &prev_vma);
+				mmap_read_unlock(mm);
+
+				/*
+				 * Check if access to the VMA is okay.
+				 * We don't allow for stack expansion.
+				 */
+				acc_type = (insn & 0x40) ? VM_WRITE : VM_READ;
+				if (vma
+				    && address >= vma->vm_start
+				    && (vma->vm_flags & acc_type) == acc_type)
+					val = 1;
+			}
+		}
+		if (treg)
+			regs->gr[treg] = val;
+		regs->gr[0] |= PSW_N;
+		return 1;
+
+	case 0x300:
+		/* LPA instruction */
+		if (insn & 0x20) {
+			/* Base modification */
+			breg = (insn >> 21) & 0x1f;
+			xreg = (insn >> 16) & 0x1f;
+			if (breg && xreg)
+				regs->gr[breg] += regs->gr[xreg];
+		}
+		treg = insn & 0x1f;
+		if (treg)
+			regs->gr[treg] = 0;
+		regs->gr[0] |= PSW_N;
+		return 1;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
-- 
2.34.1



