Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC391F2C0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfEOMG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728925AbfEOLKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954602166E;
        Wed, 15 May 2019 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918607;
        bh=r8UsJHeobUmrU9dWDtYjj8wQqq1tEaW8hScVYrx/nBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rIPjNqdTk8gWAaAjLxEeF4AIHjBppXF12ViJepG7n3nOreyQ0VKvoA5qr9bsqk0J
         BlNFZLxGBlwRycPdSbxrkU+ZhqRx/oD7Irdsu2tIum9VAyhbvrFWjXLNOaet0WP2FQ
         bjhypkJwMfPAvq2Uf9QGzUgrLe4saEtN8Rxff87w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        x86@kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 196/266] KVM: x86: SVM: Call x86_spec_ctrl_set_guest/host() with interrupts disabled
Date:   Wed, 15 May 2019 12:55:03 +0200
Message-Id: <20190515090729.575734497@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@xxxxxxxxxxxxx>

commit 024d83cadc6b2af027e473720f3c3da97496c318 upstream.

Mikhail reported the following lockdep splat:

WARNING: possible irq lock inversion dependency detected
CPU 0/KVM/10284 just changed the state of lock:
  000000000d538a88 (&st->lock){+...}, at:
  speculative_store_bypass_update+0x10b/0x170

but this lock was taken by another, HARDIRQ-safe lock
in the past:

(&(&sighand->siglock)->rlock){-.-.}

   and interrupts could create inverse lock ordering between them.

Possible interrupt unsafe locking scenario:

    CPU0                    CPU1
    ----                    ----
   lock(&st->lock);
                           local_irq_disable();
                           lock(&(&sighand->siglock)->rlock);
                           lock(&st->lock);
    <Interrupt>
     lock(&(&sighand->siglock)->rlock);
     *** DEADLOCK ***

The code path which connects those locks is:

   speculative_store_bypass_update()
   ssb_prctl_set()
   do_seccomp()
   do_syscall_64()

In svm_vcpu_run() speculative_store_bypass_update() is called with
interupts enabled via x86_virt_spec_ctrl_set_guest/host().

This is actually a false positive, because GIF=0 so interrupts are
disabled even if IF=1; however, we can easily move the invocations of
x86_virt_spec_ctrl_set_guest/host() into the interrupt disabled region to
cure it, and it's a good idea to keep the GIF=0/IF=1 area as small
and self-contained as possible.

Fixes: 1f50ddb4f418 ("x86/speculation: Handle HT correctly on AMD")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3928,8 +3928,6 @@ static void svm_vcpu_run(struct kvm_vcpu
 
 	clgi();
 
-	local_irq_enable();
-
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
 	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
@@ -3938,6 +3936,8 @@ static void svm_vcpu_run(struct kvm_vcpu
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
+	local_irq_enable();
+
 	asm volatile (
 		"push %%" _ASM_BP "; \n\t"
 		"mov %c[rbx](%[svm]), %%" _ASM_BX " \n\t"
@@ -4060,12 +4060,12 @@ static void svm_vcpu_run(struct kvm_vcpu
 	if (!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
-	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
-
 	reload_tss(vcpu);
 
 	local_irq_disable();
 
+	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
 	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;


