Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE37409023
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243004AbhIMNuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243266AbhIMNrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:47:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43013610F7;
        Mon, 13 Sep 2021 13:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539945;
        bh=F4i1mJonU6zm6wETwto0yf/xl4rP4xC6cyqdmxZFf2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x49qJHtwSd4VHZ3yT9xU7Zt7Le64p6rxrIIUMqbQYqEd1vCPayCqlBLKVOMdrabEL
         4HaLwv7QWrd6B5m1ulq3tKxW108LxdJturINusjh92lrs1f2LI9Q0kQsxU6+jN1r81
         ZWPHOdBgUChsNCNuvFGNEPrmYNCh5LnHqOXLYCRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 224/236] Revert "KVM: x86: mmu: Add guest physical address check in translate_gpa()"
Date:   Mon, 13 Sep 2021 15:15:29 +0200
Message-Id: <20210913131107.975809274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit e7177339d7b5f9594b316842122b5fda9513d5e2 upstream.

Revert a misguided illegal GPA check when "translating" a non-nested GPA.
The check is woefully incomplete as it does not fill in @exception as
expected by all callers, which leads to KVM attempting to inject a bogus
exception, potentially exposing kernel stack information in the process.

 WARNING: CPU: 0 PID: 8469 at arch/x86/kvm/x86.c:525 exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
 CPU: 1 PID: 8469 Comm: syz-executor531 Not tainted 5.14.0-rc7-syzkaller #0
 RIP: 0010:exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
 Call Trace:
  x86_emulate_instruction+0xef6/0x1460 arch/x86/kvm/x86.c:7853
  kvm_mmu_page_fault+0x2f0/0x1810 arch/x86/kvm/mmu/mmu.c:5199
  handle_ept_misconfig+0xdf/0x3e0 arch/x86/kvm/vmx/vmx.c:5336
  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6021 [inline]
  vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6038
  vcpu_enter_guest+0x2a1c/0x4430 arch/x86/kvm/x86.c:9712
  vcpu_run arch/x86/kvm/x86.c:9779 [inline]
  kvm_arch_vcpu_ioctl_run+0x47d/0x1b20 arch/x86/kvm/x86.c:10010
  kvm_vcpu_ioctl+0x49e/0xe50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3652

The bug has escaped notice because practically speaking the GPA check is
useless.  The GPA check in question only comes into play when KVM is
walking guest page tables (or "translating" CR3), and KVM already handles
illegal GPA checks by setting reserved bits in rsvd_bits_mask for each
PxE, or in the case of CR3 for loading PTDPTRs, manually checks for an
illegal CR3.  This particular failure doesn't hit the existing reserved
bits checks because syzbot sets guest.MAXPHYADDR=1, and IA32 architecture
simply doesn't allow for such an absurd MAXPHYADDR, e.g. 32-bit paging
doesn't define any reserved PA bits checks, which KVM emulates by only
incorporating the reserved PA bits into the "high" bits, i.e. bits 63:32.

Simply remove the bogus check.  There is zero meaningful value and no
architectural justification for supporting guest.MAXPHYADDR < 32, and
properly filling the exception would introduce non-trivial complexity.

This reverts commit ec7771ab471ba6a945350353617e2e3385d0e013.

Fixes: ec7771ab471b ("KVM: x86: mmu: Add guest physical address check in translate_gpa()")
Cc: stable@vger.kernel.org
Reported-by: syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210831164224.1119728-2-seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -267,12 +267,6 @@ static bool check_mmio_spte(struct kvm_v
 static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
                                   struct x86_exception *exception)
 {
-	/* Check if guest physical address doesn't exceed guest maximum */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, gpa)) {
-		exception->error_code |= PFERR_RSVD_MASK;
-		return UNMAPPED_GVA;
-	}
-
         return gpa;
 }
 


