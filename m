Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4BB3AF0B5
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhFUQvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233491AbhFUQtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32CC461461;
        Mon, 21 Jun 2021 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293286;
        bh=Y38Q48PTxRJnpG0LEbNi5mfv5F90eUz06tG8xuWbDqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8vOibQrGqv8+YxGhzdXpZ7o31m7VWbhC+5H09O/g1sIT7yFH0RG1Xb3O5sQk2Gow
         36afhoPKNLzBGJ51hJAwP2SNT2F2945gii+1Z0rm7BO0bCNqLY+u27rsFd8rWy+Wdh
         zlwGIdzs2mNkl7Bn4VNmbgzF6WJtF3/gyRa+FMg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 134/178] KVM: x86: Immediately reset the MMU context when the SMM flag is cleared
Date:   Mon, 21 Jun 2021 18:15:48 +0200
Message-Id: <20210621154927.341744249@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 78fcb2c91adfec8ce3a2ba6b4d0dda89f2f4a7c6 upstream.

Immediately reset the MMU context when the vCPU's SMM flag is cleared so
that the SMM flag in the MMU role is always synchronized with the vCPU's
flag.  If RSM fails (which isn't correctly emulated), KVM will bail
without calling post_leave_smm() and leave the MMU in a bad state.

The bad MMU role can lead to a NULL pointer dereference when grabbing a
shadow page's rmap for a page fault as the initial lookups for the gfn
will happen with the vCPU's SMM flag (=0), whereas the rmap lookup will
use the shadow page's SMM flag, which comes from the MMU (=1).  SMM has
an entirely different set of memslots, and so the initial lookup can find
a memslot (SMM=0) and then explode on the rmap memslot lookup (SMM=1).

  general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  CPU: 1 PID: 8410 Comm: syz-executor382 Not tainted 5.13.0-rc5-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:__gfn_to_rmap arch/x86/kvm/mmu/mmu.c:935 [inline]
  RIP: 0010:gfn_to_rmap+0x2b0/0x4d0 arch/x86/kvm/mmu/mmu.c:947
  Code: <42> 80 3c 20 00 74 08 4c 89 ff e8 f1 79 a9 00 4c 89 fb 4d 8b 37 44
  RSP: 0018:ffffc90000ffef98 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff888015b9f414 RCX: ffff888019669c40
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
  RBP: 0000000000000001 R08: ffffffff811d9cdb R09: ffffed10065a6002
  R10: ffffed10065a6002 R11: 0000000000000000 R12: dffffc0000000000
  R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
  FS:  000000000124b300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000028e31000 CR4: 00000000001526e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   rmap_add arch/x86/kvm/mmu/mmu.c:965 [inline]
   mmu_set_spte+0x862/0xe60 arch/x86/kvm/mmu/mmu.c:2604
   __direct_map arch/x86/kvm/mmu/mmu.c:2862 [inline]
   direct_page_fault+0x1f74/0x2b70 arch/x86/kvm/mmu/mmu.c:3769
   kvm_mmu_do_page_fault arch/x86/kvm/mmu.h:124 [inline]
   kvm_mmu_page_fault+0x199/0x1440 arch/x86/kvm/mmu/mmu.c:5065
   vmx_handle_exit+0x26/0x160 arch/x86/kvm/vmx/vmx.c:6122
   vcpu_enter_guest+0x3bdd/0x9630 arch/x86/kvm/x86.c:9428
   vcpu_run+0x416/0xc20 arch/x86/kvm/x86.c:9494
   kvm_arch_vcpu_ioctl_run+0x4e8/0xa40 arch/x86/kvm/x86.c:9722
   kvm_vcpu_ioctl+0x70f/0xbb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3460
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:1069 [inline]
   __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:1055
   do_syscall_64+0x3f/0xb0 arch/x86/entry/common.c:47
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x440ce9

Cc: stable@vger.kernel.org
Reported-by: syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Fixes: 9ec19493fb86 ("KVM: x86: clear SMM flags before loading state while leaving SMM")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210609185619.992058-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6991,7 +6991,10 @@ static unsigned emulator_get_hflags(stru
 
 static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_flags)
 {
-	emul_to_vcpu(ctxt)->arch.hflags = emul_flags;
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	vcpu->arch.hflags = emul_flags;
+	kvm_mmu_reset_context(vcpu);
 }
 
 static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,


