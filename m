Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6481A5841
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgDKXLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729825AbgDKXLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E54215A4;
        Sat, 11 Apr 2020 23:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646672;
        bh=xcs1ISAQ16S+9fBkfFe44DGw9yGir8f5r8hg82E2Bx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJ4gpa4cxij0goHw/18AqhLh8CA9b9BQWgNvzOign7HmfLJsyLJE018myYy5X91Uh
         +Qm0CIY+uIjmibSTMJNxF9erF8e7Hv6ZFfsbS13vn706hywZJmon+OvpxANJK1EYEJ
         YS0WwNceFzbAGVlSOy0M0LTcSiHZ3rkh5iQwTH9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gustavo Romero <gromero@linux.ibm.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Leonardo Bras <leonardo@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 071/108] KVM: PPC: Book3S HV: Treat TM-related invalid form instructions on P9 like the valid ones
Date:   Sat, 11 Apr 2020 19:09:06 -0400
Message-Id: <20200411230943.24951-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Romero <gromero@linux.ibm.com>

[ Upstream commit 1dff3064c764b5a51c367b949b341d2e38972bec ]

On P9 DD2.2 due to a CPU defect some TM instructions need to be emulated by
KVM. This is handled at first by the hardware raising a softpatch interrupt
when certain TM instructions that need KVM assistance are executed in the
guest. Althought some TM instructions per Power ISA are invalid forms they
can raise a softpatch interrupt too. For instance, 'tresume.' instruction
as defined in the ISA must have bit 31 set (1), but an instruction that
matches 'tresume.' PO and XO opcode fields but has bit 31 not set (0), like
0x7cfe9ddc, also raises a softpatch interrupt. Similarly for 'treclaim.'
and 'trechkpt.' instructions with bit 31 = 0, i.e. 0x7c00075c and
0x7c0007dc, respectively. Hence, if a code like the following is executed
in the guest it will raise a softpatch interrupt just like a 'tresume.'
when the TM facility is enabled ('tabort. 0' in the example is used only
to enable the TM facility):

int main() { asm("tabort. 0; .long 0x7cfe9ddc;"); }

Currently in such a case KVM throws a complete trace like:

[345523.705984] WARNING: CPU: 24 PID: 64413 at arch/powerpc/kvm/book3s_hv_tm.c:211 kvmhv_p9_tm_emulation+0x68/0x620 [kvm_hv]
[345523.705985] Modules linked in: kvm_hv(E) xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp ip6table_mangle ip6table_nat
iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter bridge stp llc sch_fq_codel ipmi_powernv at24 vmx_crypto ipmi_devintf ipmi_msghandler
ibmpowernv uio_pdrv_genirq kvm opal_prd uio leds_powernv ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c xor raid6_pq raid1 raid0 multipath linear tg3
crct10dif_vpmsum crc32c_vpmsum ipr [last unloaded: kvm_hv]
[345523.706030] CPU: 24 PID: 64413 Comm: CPU 0/KVM Tainted: G        W   E     5.5.0+ #1
[345523.706031] NIP:  c0080000072cb9c0 LR: c0080000072b5e80 CTR: c0080000085c7850
[345523.706034] REGS: c000000399467680 TRAP: 0700   Tainted: G        W   E      (5.5.0+)
[345523.706034] MSR:  900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 24022428  XER: 00000000
[345523.706042] CFAR: c0080000072b5e7c IRQMASK: 0
                GPR00: c0080000072b5e80 c000000399467910 c0080000072db500 c000000375ccc720
                GPR04: c000000375ccc720 00000003fbec0000 0000a10395dda5a6 0000000000000000
                GPR08: 000000007cfe9ddc 7cfe9ddc000005dc 7cfe9ddc7c0005dc c0080000072cd530
                GPR12: c0080000085c7850 c0000003fffeb800 0000000000000001 00007dfb737f0000
                GPR16: c0002001edcca558 0000000000000000 0000000000000000 0000000000000001
                GPR20: c000000001b21258 c0002001edcca558 0000000000000018 0000000000000000
                GPR24: 0000000001000000 ffffffffffffffff 0000000000000001 0000000000001500
                GPR28: c0002001edcc4278 c00000037dd80000 800000050280f033 c000000375ccc720
[345523.706062] NIP [c0080000072cb9c0] kvmhv_p9_tm_emulation+0x68/0x620 [kvm_hv]
[345523.706065] LR [c0080000072b5e80] kvmppc_handle_exit_hv.isra.53+0x3e8/0x798 [kvm_hv]
[345523.706066] Call Trace:
[345523.706069] [c000000399467910] [c000000399467940] 0xc000000399467940 (unreliable)
[345523.706071] [c000000399467950] [c000000399467980] 0xc000000399467980
[345523.706075] [c0000003994679f0] [c0080000072bd1c4] kvmhv_run_single_vcpu+0xa1c/0xb80 [kvm_hv]
[345523.706079] [c000000399467ac0] [c0080000072bd8e0] kvmppc_vcpu_run_hv+0x5b8/0xb00 [kvm_hv]
[345523.706087] [c000000399467b90] [c0080000085c93cc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[345523.706095] [c000000399467bb0] [c0080000085c582c] kvm_arch_vcpu_ioctl_run+0x244/0x420 [kvm]
[345523.706101] [c000000399467c40] [c0080000085b7498] kvm_vcpu_ioctl+0x3d0/0x7b0 [kvm]
[345523.706105] [c000000399467db0] [c0000000004adf9c] ksys_ioctl+0x13c/0x170
[345523.706107] [c000000399467e00] [c0000000004adff8] sys_ioctl+0x28/0x80
[345523.706111] [c000000399467e20] [c00000000000b278] system_call+0x5c/0x68
[345523.706112] Instruction dump:
[345523.706114] 419e0390 7f8a4840 409d0048 6d497c00 2f89075d 419e021c 6d497c00 2f8907dd
[345523.706119] 419e01c0 6d497c00 2f8905dd 419e00a4 <0fe00000> 38210040 38600000 ebc1fff0

and then treats the executed instruction as a 'nop'.

However the POWER9 User's Manual, in section "4.6.10 Book II Invalid
Forms", informs that for TM instructions bit 31 is in fact ignored, thus
for the TM-related invalid forms ignoring bit 31 and handling them like the
valid forms is an acceptable way to handle them. POWER8 behaves the same
way too.

This commit changes the handling of the cases here described by treating
the TM-related invalid forms that can generate a softpatch interrupt
just like their valid forms (w/ bit 31 = 1) instead of as a 'nop' and by
gently reporting any other unrecognized case to the host and treating it as
illegal instruction instead of throwing a trace and treating it as a 'nop'.

Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Acked-By: Michael Neuling <mikey@neuling.org>
Reviewed-by: Leonardo Bras <leonardo@linux.ibm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_asm.h      |  3 +++
 arch/powerpc/kvm/book3s_hv_tm.c         | 28 ++++++++++++++++++++-----
 arch/powerpc/kvm/book3s_hv_tm_builtin.c | 16 ++++++++++++--
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index 635fb154b33f9..a3633560493be 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -150,4 +150,7 @@
 
 #define KVM_INST_FETCH_FAILED	-1
 
+/* Extract PO and XOP opcode fields */
+#define PO_XOP_OPCODE_MASK 0xfc0007fe
+
 #endif /* __POWERPC_KVM_ASM_H__ */
diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index 0db9374971697..cc90b8b823291 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -3,6 +3,8 @@
  * Copyright 2017 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_ppc.h>
@@ -44,7 +46,18 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 	u64 newmsr, bescr;
 	int ra, rs;
 
-	switch (instr & 0xfc0007ff) {
+	/*
+	 * rfid, rfebb, and mtmsrd encode bit 31 = 0 since it's a reserved bit
+	 * in these instructions, so masking bit 31 out doesn't change these
+	 * instructions. For treclaim., tsr., and trechkpt. instructions if bit
+	 * 31 = 0 then they are per ISA invalid forms, however P9 UM, in section
+	 * 4.6.10 Book II Invalid Forms, informs specifically that ignoring bit
+	 * 31 is an acceptable way to handle these invalid forms that have
+	 * bit 31 = 0. Moreover, for emulation purposes both forms (w/ and wo/
+	 * bit 31 set) can generate a softpatch interrupt. Hence both forms
+	 * are handled below for these instructions so they behave the same way.
+	 */
+	switch (instr & PO_XOP_OPCODE_MASK) {
 	case PPC_INST_RFID:
 		/* XXX do we need to check for PR=0 here? */
 		newmsr = vcpu->arch.shregs.srr1;
@@ -105,7 +118,8 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.shregs.msr = newmsr;
 		return RESUME_GUEST;
 
-	case PPC_INST_TSR:
+	/* ignore bit 31, see comment above */
+	case (PPC_INST_TSR & PO_XOP_OPCODE_MASK):
 		/* check for PR=1 and arch 2.06 bit set in PCR */
 		if ((msr & MSR_PR) && (vcpu->arch.vcore->pcr & PCR_ARCH_206)) {
 			/* generate an illegal instruction interrupt */
@@ -140,7 +154,8 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.shregs.msr = msr;
 		return RESUME_GUEST;
 
-	case PPC_INST_TRECLAIM:
+	/* ignore bit 31, see comment above */
+	case (PPC_INST_TRECLAIM & PO_XOP_OPCODE_MASK):
 		/* check for TM disabled in the HFSCR or MSR */
 		if (!(vcpu->arch.hfscr & HFSCR_TM)) {
 			/* generate an illegal instruction interrupt */
@@ -176,7 +191,8 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.shregs.msr &= ~MSR_TS_MASK;
 		return RESUME_GUEST;
 
-	case PPC_INST_TRECHKPT:
+	/* ignore bit 31, see comment above */
+	case (PPC_INST_TRECHKPT & PO_XOP_OPCODE_MASK):
 		/* XXX do we need to check for PR=0 here? */
 		/* check for TM disabled in the HFSCR or MSR */
 		if (!(vcpu->arch.hfscr & HFSCR_TM)) {
@@ -208,6 +224,8 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 	}
 
 	/* What should we do here? We didn't recognize the instruction */
-	WARN_ON_ONCE(1);
+	kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
+	pr_warn_ratelimited("Unrecognized TM-related instruction %#x for emulation", instr);
+
 	return RESUME_GUEST;
 }
diff --git a/arch/powerpc/kvm/book3s_hv_tm_builtin.c b/arch/powerpc/kvm/book3s_hv_tm_builtin.c
index 217246279dfae..fad931f224efd 100644
--- a/arch/powerpc/kvm/book3s_hv_tm_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_tm_builtin.c
@@ -23,7 +23,18 @@ int kvmhv_p9_tm_emulation_early(struct kvm_vcpu *vcpu)
 	u64 newmsr, msr, bescr;
 	int rs;
 
-	switch (instr & 0xfc0007ff) {
+	/*
+	 * rfid, rfebb, and mtmsrd encode bit 31 = 0 since it's a reserved bit
+	 * in these instructions, so masking bit 31 out doesn't change these
+	 * instructions. For the tsr. instruction if bit 31 = 0 then it is per
+	 * ISA an invalid form, however P9 UM, in section 4.6.10 Book II Invalid
+	 * Forms, informs specifically that ignoring bit 31 is an acceptable way
+	 * to handle TM-related invalid forms that have bit 31 = 0. Moreover,
+	 * for emulation purposes both forms (w/ and wo/ bit 31 set) can
+	 * generate a softpatch interrupt. Hence both forms are handled below
+	 * for tsr. to make them behave the same way.
+	 */
+	switch (instr & PO_XOP_OPCODE_MASK) {
 	case PPC_INST_RFID:
 		/* XXX do we need to check for PR=0 here? */
 		newmsr = vcpu->arch.shregs.srr1;
@@ -73,7 +84,8 @@ int kvmhv_p9_tm_emulation_early(struct kvm_vcpu *vcpu)
 		vcpu->arch.shregs.msr = newmsr;
 		return 1;
 
-	case PPC_INST_TSR:
+	/* ignore bit 31, see comment above */
+	case (PPC_INST_TSR & PO_XOP_OPCODE_MASK):
 		/* we know the MSR has the TS field = S (0b01) here */
 		msr = vcpu->arch.shregs.msr;
 		/* check for PR=1 and arch 2.06 bit set in PCR */
-- 
2.20.1

