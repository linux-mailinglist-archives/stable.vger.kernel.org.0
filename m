Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78AC76E02
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388445AbfGZP2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387978AbfGZP2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7847F22BF5;
        Fri, 26 Jul 2019 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154901;
        bh=tq/XML1mgou6EUt/qIYkKsyK636drn68NKavb/LeLTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3TZbvu++eqdVOX0n1jomchlOHdeW/Eo57WVSScNNGg/wPiCABsIZKmza1fY6pODJ
         qGlcwW02OzNwrVf0nRzi0IPO0mOEjh4n+0y6aW5PmHI/q5XRA/ziwin8qJZIsGvpV5
         teZMxASo60s8VD6Ago7bD1kCRNSxcH8fl0TywsNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 64/66] Revert "kvm: x86: Use task structs fpu field for user"
Date:   Fri, 26 Jul 2019 17:25:03 +0200
Message-Id: <20190726152308.597585968@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit ec269475cba7bcdd1eb8fdf8e87f4c6c81a376fe upstream.

This reverts commit 240c35a3783ab9b3a0afaba0dde7291295680a6b
("kvm: x86: Use task structs fpu field for user", 2018-11-06).
The commit is broken and causes QEMU's FPU state to be destroyed
when KVM_RUN is preempted.

Fixes: 240c35a3783a ("kvm: x86: Use task structs fpu field for user")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    7 ++++---
 arch/x86/kvm/x86.c              |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -607,15 +607,16 @@ struct kvm_vcpu_arch {
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
-	 * In vcpu_run, we switch between the user, maintained in the
-	 * task_struct struct, and guest FPU contexts. While running a VCPU,
-	 * the VCPU thread will have the guest FPU context.
+	 * In vcpu_run, we switch between the user and guest FPU contexts.
+	 * While running a VCPU, the VCPU thread will have the guest FPU
+	 * context.
 	 *
 	 * Note that while the PKRU state lives inside the fpu registers,
 	 * it is switched out separately at VMENTER and VMEXIT time. The
 	 * "guest_fpu" state here contains the guest FPU context, with the
 	 * host PRKU bits.
 	 */
+	struct fpu user_fpu;
 	struct fpu *guest_fpu;
 
 	u64 xcr0;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8219,7 +8219,7 @@ static void kvm_load_guest_fpu(struct kv
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(&current->thread.fpu);
+	copy_fpregs_to_fpstate(&vcpu->arch.user_fpu);
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
@@ -8236,7 +8236,7 @@ static void kvm_put_guest_fpu(struct kvm
 	fpregs_lock();
 
 	copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
-	copy_kernel_to_fpregs(&current->thread.fpu.state);
+	copy_kernel_to_fpregs(&vcpu->arch.user_fpu.state);
 
 	fpregs_mark_activate();
 	fpregs_unlock();


