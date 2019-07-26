Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C9A768F0
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbfGZNpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388531AbfGZNpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:45:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B482122CD8;
        Fri, 26 Jul 2019 13:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148718;
        bh=5FX+wq9W2/yXLvQvozoVGSUl6g+1aCWYapttN7WDd7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1KVydY7RcTONPGInkY7qNqUu1seiMv4g0ULmY6CWPj/BEzH198C4JVvuKUhnvIhv
         XoW6NSLBWjcovSkmYKTE6RJ3aHPu4SU+7iCCPvfVqJubglTArYstvYuU8ci0pBHLsE
         r4zvaGAxnZRTNPUcq734NNOzpOnzmlmVzDA3Pwi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 29/30] x86/kvm: Don't call kvm_spurious_fault() from .fixup
Date:   Fri, 26 Jul 2019 09:44:31 -0400
Message-Id: <20190726134432.12993-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134432.12993-1-sashal@kernel.org>
References: <20190726134432.12993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 3901336ed9887b075531bffaeef7742ba614058b ]

After making a change to improve objtool's sibling call detection, it
started showing the following warning:

  arch/x86/kvm/vmx/nested.o: warning: objtool: .fixup+0x15: sibling call from callable instruction with modified stack frame

The problem is the ____kvm_handle_fault_on_reboot() macro.  It does a
fake call by pushing a fake RIP and doing a jump.  That tricks the
unwinder into printing the function which triggered the exception,
rather than the .fixup code.

Instead of the hack to make it look like the original function made the
call, just change the macro so that the original function actually does
make the call.  This allows removal of the hack, and also makes objtool
happy.

I triggered a vmx instruction exception and verified that the stack
trace is still sane:

  kernel BUG at arch/x86/kvm/x86.c:358!
  invalid opcode: 0000 [#1] SMP PTI
  CPU: 28 PID: 4096 Comm: qemu-kvm Not tainted 5.2.0+ #16
  Hardware name: Lenovo THINKSYSTEM SD530 -[7X2106Z000]-/-[7X2106Z000]-, BIOS -[TEE113Z-1.00]- 07/17/2017
  RIP: 0010:kvm_spurious_fault+0x5/0x10
  Code: 00 00 00 00 00 8b 44 24 10 89 d2 45 89 c9 48 89 44 24 10 8b 44 24 08 48 89 44 24 08 e9 d4 40 22 00 0f 1f 40 00 0f 1f 44 00 00 <0f> 0b 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 55 49 89 fd 41
  RSP: 0018:ffffbf91c683bd00 EFLAGS: 00010246
  RAX: 000061f040000000 RBX: ffff9e159c77bba0 RCX: ffff9e15a5c87000
  RDX: 0000000665c87000 RSI: ffff9e15a5c87000 RDI: ffff9e159c77bba0
  RBP: 0000000000000000 R08: 0000000000000000 R09: ffff9e15a5c87000
  R10: 0000000000000000 R11: fffff8f2d99721c0 R12: ffff9e159c77bba0
  R13: ffffbf91c671d960 R14: ffff9e159c778000 R15: 0000000000000000
  FS:  00007fa341cbe700(0000) GS:ffff9e15b7400000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fdd38356804 CR3: 00000006759de003 CR4: 00000000007606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   loaded_vmcs_init+0x4f/0xe0
   alloc_loaded_vmcs+0x38/0xd0
   vmx_create_vcpu+0xf7/0x600
   kvm_vm_ioctl+0x5e9/0x980
   ? __switch_to_asm+0x40/0x70
   ? __switch_to_asm+0x34/0x70
   ? __switch_to_asm+0x40/0x70
   ? __switch_to_asm+0x34/0x70
   ? free_one_page+0x13f/0x4e0
   do_vfs_ioctl+0xa4/0x630
   ksys_ioctl+0x60/0x90
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x55/0x1c0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7fa349b1ee5b

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/64a9b64d127e87b6920a97afde8e96ea76f6524e.1563413318.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 34 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 83b5b2990b49..222cb69e1219 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1309,25 +1309,29 @@ enum {
 #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 
+asmlinkage void __noreturn kvm_spurious_fault(void);
+
 /*
  * Hardware virtualization extension instructions may fault if a
  * reboot turns off virtualization while processes are running.
- * Trap the fault and ignore the instruction if that happens.
+ * Usually after catching the fault we just panic; during reboot
+ * instead the instruction is ignored.
  */
-asmlinkage void kvm_spurious_fault(void);
-
-#define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)	\
-	"666: " insn "\n\t" \
-	"668: \n\t"                           \
-	".pushsection .fixup, \"ax\" \n" \
-	"667: \n\t" \
-	cleanup_insn "\n\t"		      \
-	"cmpb $0, kvm_rebooting \n\t"	      \
-	"jne 668b \n\t"      		      \
-	__ASM_SIZE(push) " $666b \n\t"	      \
-	"jmp kvm_spurious_fault \n\t"	      \
-	".popsection \n\t" \
-	_ASM_EXTABLE(666b, 667b)
+#define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)		\
+	"666: \n\t"							\
+	insn "\n\t"							\
+	"jmp	668f \n\t"						\
+	"667: \n\t"							\
+	"call	kvm_spurious_fault \n\t"				\
+	"668: \n\t"							\
+	".pushsection .fixup, \"ax\" \n\t"				\
+	"700: \n\t"							\
+	cleanup_insn "\n\t"						\
+	"cmpb	$0, kvm_rebooting\n\t"					\
+	"je	667b \n\t"						\
+	"jmp	668b \n\t"						\
+	".popsection \n\t"						\
+	_ASM_EXTABLE(666b, 700b)
 
 #define __kvm_handle_fault_on_reboot(insn)		\
 	____kvm_handle_fault_on_reboot(insn, "")
-- 
2.20.1

