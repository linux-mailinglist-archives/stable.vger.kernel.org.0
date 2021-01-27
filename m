Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B53305723
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 10:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhA0Jkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 04:40:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:46712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234871AbhA0JjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 04:39:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611740304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=R3PWSOk1QE9v1GpOIHb/NnNGs7W5QhxGQA5YD3vuLm4=;
        b=rlTPArEzklGezseesPPFjz4F1fJwPjR1KNQkEVUkSvvakuCt4EZel4JI/VgNArul7YKey2
        Pp86uNd24R9Modq30iF0Zmo7Kz/apPZ+jc6sP6CTSP0f5d8tx4gE7RH/zxBh/J3KVq2SdF
        G8RoOYcWZXVGjsY8G0qpjPGOYvcOjtw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 970ABADA2;
        Wed, 27 Jan 2021 09:38:24 +0000 (UTC)
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
Subject: [PATCH v2] x86/xen: avoid warning in Xen pv guest with CONFIG_AMD_MEM_ENCRYPT enabled
Date:   Wed, 27 Jan 2021 10:38:22 +0100
Message-Id: <20210127093822.18570-1-jgross@suse.com>
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

Fix that by adding a generic trap handler for unknown traps and wire all
unknown bare metal handlers to this generic handler, which will just
panic the system in case such a trap will ever happen.

Fixes: 0786138c78e793 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Cc: <stable@vger.kernel.org> # v5.10
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- use generic handler for unknown traps (Andrew Cooper)
---
 arch/x86/include/asm/idtentry.h |  1 +
 arch/x86/xen/enlighten_pv.c     | 14 +++++++++++++-
 arch/x86/xen/xen-asm.S          |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 247a60a47331..f656aabd1545 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -613,6 +613,7 @@ DECLARE_IDTENTRY_VC(X86_TRAP_VC,	exc_vmm_communication);
 
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_XENCB(X86_TRAP_OTHER,	exc_xen_hypervisor_callback);
+DECLARE_IDTENTRY_RAW(X86_TRAP_OTHER,	exc_xen_unknown_trap);
 #endif
 
 /* Device interrupts common/spurious */
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4409306364dc..ca5ac10fcbf7 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -583,6 +583,12 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
 		exc_debug(regs);
 }
 
+DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
+{
+	/* This should never happen and there is no way to handle it. */
+	panic("Unknown trap in Xen PV mode.");
+}
+
 struct trap_array_entry {
 	void (*orig)(void);
 	void (*xen)(void);
@@ -631,6 +637,7 @@ static bool __ref get_trap_addr(void **addr, unsigned int ist)
 {
 	unsigned int nr;
 	bool ist_okay = false;
+	bool found = false;
 
 	/*
 	 * Replace trap handler addresses by Xen specific ones.
@@ -645,6 +652,7 @@ static bool __ref get_trap_addr(void **addr, unsigned int ist)
 		if (*addr == entry->orig) {
 			*addr = entry->xen;
 			ist_okay = entry->ist_okay;
+			found = true;
 			break;
 		}
 	}
@@ -655,9 +663,13 @@ static bool __ref get_trap_addr(void **addr, unsigned int ist)
 		nr = (*addr - (void *)early_idt_handler_array[0]) /
 		     EARLY_IDT_HANDLER_SIZE;
 		*addr = (void *)xen_early_idt_handler_array[nr];
+		found = true;
 	}
 
-	if (WARN_ON(ist != 0 && !ist_okay))
+	if (!found)
+		*addr = (void *)xen_asm_exc_xen_unknown_trap;
+
+	if (WARN_ON(found && ist != 0 && !ist_okay))
 		return false;
 
 	return true;
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 1cb0e84b9161..53cf8aa35032 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -178,6 +178,7 @@ xen_pv_trap asm_exc_simd_coprocessor_error
 #ifdef CONFIG_IA32_EMULATION
 xen_pv_trap entry_INT80_compat
 #endif
+xen_pv_trap asm_exc_xen_unknown_trap
 xen_pv_trap asm_exc_xen_hypervisor_callback
 
 	__INIT
-- 
2.26.2

