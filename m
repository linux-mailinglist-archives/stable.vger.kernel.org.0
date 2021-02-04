Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE04530CCBD
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbhBBUGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhBBNnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:43:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3276264F66;
        Tue,  2 Feb 2021 13:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273205;
        bh=NP20O/wddR1JeAh//dmrlqiN0SyO+nUO9F4/uRim8es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAGKCam/1F2iA+h43LHtJJCtCos70vZ2xiH57MXbuKvWO5TxROhQC/tnIfYtB+pyu
         83QFVTLN4kAjuvYQTxlY3Dn837iZdLBXoptNHBc88KKBpKGMIl/+5Lu1xFU7bTkty4
         bOsZEIu6q+iaQdGQ5ynUaG1THmCFEYpaDalUgFzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH 5.10 020/142] x86/xen: avoid warning in Xen pv guest with CONFIG_AMD_MEM_ENCRYPT enabled
Date:   Tue,  2 Feb 2021 14:36:23 +0100
Message-Id: <20210202132958.543511160@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 2e92493637a09547734f92c62a2471f6f0cb9a2c upstream.

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
crash the system in case such a trap will ever happen.

Fixes: 0786138c78e793 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Cc: <stable@vger.kernel.org> # v5.10
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/idtentry.h |    1 +
 arch/x86/xen/enlighten_pv.c     |   15 ++++++++++++++-
 arch/x86/xen/xen-asm.S          |    1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -616,6 +616,7 @@ DECLARE_IDTENTRY_VC(X86_TRAP_VC,	exc_vmm
 
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_XENCB(X86_TRAP_OTHER,	exc_xen_hypervisor_callback);
+DECLARE_IDTENTRY_RAW(X86_TRAP_OTHER,	exc_xen_unknown_trap);
 #endif
 
 /* Device interrupts common/spurious */
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -583,6 +583,13 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
 		exc_debug(regs);
 }
 
+DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
+{
+	/* This should never happen and there is no way to handle it. */
+	pr_err("Unknown trap in Xen PV mode.");
+	BUG();
+}
+
 struct trap_array_entry {
 	void (*orig)(void);
 	void (*xen)(void);
@@ -631,6 +638,7 @@ static bool __ref get_trap_addr(void **a
 {
 	unsigned int nr;
 	bool ist_okay = false;
+	bool found = false;
 
 	/*
 	 * Replace trap handler addresses by Xen specific ones.
@@ -645,6 +653,7 @@ static bool __ref get_trap_addr(void **a
 		if (*addr == entry->orig) {
 			*addr = entry->xen;
 			ist_okay = entry->ist_okay;
+			found = true;
 			break;
 		}
 	}
@@ -655,9 +664,13 @@ static bool __ref get_trap_addr(void **a
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
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -178,6 +178,7 @@ xen_pv_trap asm_exc_simd_coprocessor_err
 #ifdef CONFIG_IA32_EMULATION
 xen_pv_trap entry_INT80_compat
 #endif
+xen_pv_trap asm_exc_xen_unknown_trap
 xen_pv_trap asm_exc_xen_hypervisor_callback
 
 	__INIT


