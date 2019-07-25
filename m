Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E900274DB2
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404451AbfGYMEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 08:04:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40428 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404435AbfGYMEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 08:04:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so44532815wmj.5
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 05:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/bIhamhaCP8Od8nQqlaPQjE7bAnGgUhjKuEYaWcyOWQ=;
        b=lOvAAKDBjhr2PC5vO279l0A1AerChCdF61zqtA9+ddqRqeU/iFMh3w0Qc4H+sBrDaZ
         FU1HdZ6SjMeKRNlMhP55DACix03Vwn2mU02eWntl2jHH3MePDUr3MZiEJl81YoolEjBV
         wjX2baCMhWCmwZ5AuvGvKySxiPLUeeejwVc5SxmljtH+2ZCo+mAmmNDhosnEb8UuOmoC
         EL0XcQgY3/hgxr6vLqTa7gW/jUJxPgkr9WgTq4XunD+IbNLo6mVfg/ahsU9BNcEJcOxI
         dv62fIYlqLNvZDz4dOEmdarpoHQy66/+hAS7c8VmRVZbQ3x62y00BFmjTRab6VncBJD1
         g42g==
X-Gm-Message-State: APjAAAUceDW9ck874TrgDH6PX0Y7I/NZztlLKvq6Lu3bMO/8NnF/QaaP
        dyu8dg16OZAq3mILMRDQ4B0C9RDHhV4=
X-Google-Smtp-Source: APXvYqww1uMiX4zlMkgdMe0dz50mX1hWd4r7Qep+978QB21ye1nFecSBufvr9akC9iei6QIfTX/wig==
X-Received: by 2002:a1c:b707:: with SMTP id h7mr78305590wmf.45.1564056281416;
        Thu, 25 Jul 2019 05:04:41 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j6sm73793424wrx.46.2019.07.25.05.04.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 05:04:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.2 3/3] Revert "kvm: x86: Use task structs fpu field for user"
Date:   Thu, 25 Jul 2019 14:04:36 +0200
Message-Id: <20190725120436.5432-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725120436.5432-1-vkuznets@redhat.com>
References: <20190725120436.5432-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit ec269475cba7bcdd1eb8fdf8e87f4c6c81a376fe ]

This reverts commit 240c35a3783ab9b3a0afaba0dde7291295680a6b
("kvm: x86: Use task structs fpu field for user", 2018-11-06).
The commit is broken and causes QEMU's FPU state to be destroyed
when KVM_RUN is preempted.

Fixes: 240c35a3783a ("kvm: x86: Use task structs fpu field for user")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++---
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26d1eb83f72a..08f46951c430 100644
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fafd81d2c9ea..a4eceb0b5dde 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8219,7 +8219,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(&current->thread.fpu);
+	copy_fpregs_to_fpstate(&vcpu->arch.user_fpu);
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
@@ -8236,7 +8236,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	fpregs_lock();
 
 	copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
-	copy_kernel_to_fpregs(&current->thread.fpu.state);
+	copy_kernel_to_fpregs(&vcpu->arch.user_fpu.state);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
2.20.1

