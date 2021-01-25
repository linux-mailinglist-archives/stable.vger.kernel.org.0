Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661BC30323C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbhAYOC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:02:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:34164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729052AbhAYOBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 09:01:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611583214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sdcHMLB31tbVyd/BVCp9LaTCjmBsfraBzDo/3Q+9DY0=;
        b=a+FXT8qjH2HLENLcySw+AEVEMq3UZKQkhDpMgaFFkB5quYElNpPQP/9K13VrYvtrJ2mk8E
        HXo1oyd6S52wm9Ck4hPZD1//7kYwxWiQD3+kJo7VRZ+22wVC1mRDMla2ykm8i7igFHcxJa
        1WuCmcl4PO8kMCN1ZzQbhfe2/WQ9KHg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 78AC0AC45;
        Mon, 25 Jan 2021 14:00:14 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] x86/xen: avoid warning in Xen pv guest with CONFIG_AMD_MEM_ENCRYPT enabled
Date:   Mon, 25 Jan 2021 15:00:13 +0100
Message-Id: <20210125140013.10198-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When booting a kernel which has been built with CONFIG_AMD_MEM_ENCRYPT
enabled as a Xen pv guest a warning is issued for each processor:

[    5.964347] ------------[ cut here ]------------
[    5.968314] WARNING: CPU: 0 PID: 1 at /home/gross/linux/head/arch/x86/xen/enlighten_pv.c:660 get_trap_addr+0x59/0x90
[    5.972321] Modules linked in:
[    5.976313] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.11.0-rc5-default #75
[    5.980313] Hardware name: Dell Inc. OptiPlex 9020/0PC5F7, BIOS A05 12/05/2013
[    5.984313] RIP: e030:get_trap_addr+0x59/0x90
[    5.988313] Code: 42 10 83 f0 01 85 f6 74 04 84 c0 75 1d b8 01 00 00 00 c3 48 3d 00 80 83 82 72 08 48 3d 20 81 83 82 72 0c b8 01 00 00 00 eb db <0f> 0b 31 c0 c3 48 2d 00 80 83 82 48 ba 72 1c c7 71 1c c7 71 1c 48
[    5.992313] RSP: e02b:ffffc90040033d38 EFLAGS: 00010202
[    5.996313] RAX: 0000000000000001 RBX: ffffffff82a141d0 RCX: ffffffff8222ec38
[    6.000312] RDX: ffffffff8222ec38 RSI: 0000000000000005 RDI: ffffc90040033d40
[    6.004313] RBP: ffff8881003984a0 R08: 0000000000000007 R09: ffff888100398000
[    6.008312] R10: 0000000000000007 R11: ffffc90040246000 R12: ffff8884082182a8
[    6.012313] R13: 0000000000000100 R14: 000000000000001d R15: ffff8881003982d0
[    6.016316] FS:  0000000000000000(0000) GS:ffff888408200000(0000) knlGS:0000000000000000
[    6.020313] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.024313] CR2: ffffc900020ef000 CR3: 000000000220a000 CR4: 0000000000050660
[    6.028314] Call Trace:
[    6.032313]  cvt_gate_to_trap.part.7+0x3f/0x90
[    6.036313]  ? asm_exc_double_fault+0x30/0x30
[    6.040313]  xen_convert_trap_info+0x87/0xd0
[    6.044313]  xen_pv_cpu_up+0x17a/0x450
[    6.048313]  bringup_cpu+0x2b/0xc0
[    6.052313]  ? cpus_read_trylock+0x50/0x50
[    6.056313]  cpuhp_invoke_callback+0x80/0x4c0
[    6.060313]  _cpu_up+0xa7/0x140
[    6.064313]  cpu_up+0x98/0xd0
[    6.068313]  bringup_nonboot_cpus+0x4f/0x60
[    6.072313]  smp_init+0x26/0x79
[    6.076313]  kernel_init_freeable+0x103/0x258
[    6.080313]  ? rest_init+0xd0/0xd0
[    6.084313]  kernel_init+0xa/0x110
[    6.088313]  ret_from_fork+0x1f/0x30
[    6.092313] ---[ end trace be9ecf17dceeb4f3 ]---

Reason is that there is no Xen pv trap entry for X86_TRAP_VC.

Fix that by defining a trap entry for X86_TRAP_VC in Xen pv mode.

Fixes: 0786138c78e793 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Cc: <stable@vger.kernel.org> # v5.10
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/idtentry.h |  3 +++
 arch/x86/xen/enlighten_pv.c     | 11 +++++++++++
 arch/x86/xen/xen-asm.S          |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 247a60a47331..115a76e77e65 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -609,6 +609,9 @@ DECLARE_IDTENTRY_DF(X86_TRAP_DF,	exc_double_fault);
 /* #VC */
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 DECLARE_IDTENTRY_VC(X86_TRAP_VC,	exc_vmm_communication);
+#ifdef CONFIG_XEN_PV
+DECLARE_IDTENTRY_RAW(X86_TRAP_VC,	xenpv_exc_vmm_communication);
+#endif
 #endif
 
 #ifdef CONFIG_XEN_PV
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4409306364dc..82948251f57b 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -583,6 +583,14 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
 		exc_debug(regs);
 }
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+DEFINE_IDTENTRY_RAW(xenpv_exc_vmm_communication)
+{
+	/* This should never happen and there is no way to handle it. */
+	panic("X86_TRAP_VC in Xen PV mode.");
+}
+#endif
+
 struct trap_array_entry {
 	void (*orig)(void);
 	void (*xen)(void);
@@ -625,6 +633,9 @@ static struct trap_array_entry trap_array[] = {
 	TRAP_ENTRY(exc_coprocessor_error,		false ),
 	TRAP_ENTRY(exc_alignment_check,			false ),
 	TRAP_ENTRY(exc_simd_coprocessor_error,		false ),
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	TRAP_ENTRY_REDIR(exc_vmm_communication,		true ),
+#endif
 };
 
 static bool __ref get_trap_addr(void **addr, unsigned int ist)
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 1cb0e84b9161..16f4db35de44 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -175,6 +175,9 @@ xen_pv_trap asm_exc_alignment_check
 xen_pv_trap asm_exc_machine_check
 #endif /* CONFIG_X86_MCE */
 xen_pv_trap asm_exc_simd_coprocessor_error
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+xen_pv_trap asm_xenpv_exc_vmm_communication
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
 #ifdef CONFIG_IA32_EMULATION
 xen_pv_trap entry_INT80_compat
 #endif
-- 
2.26.2

