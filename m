Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF14B6FF0E
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 13:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfGVL4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 07:56:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44788 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbfGVL4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 07:56:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so39075688wrf.11;
        Mon, 22 Jul 2019 04:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=wYE/nhc4N92v6LXkAKkrTf5th+f3+Wju4vNytZnYrvI=;
        b=eG/d5ZL9OmuTgooJTT+pydFaonxG+a382DSwnK4ARBiEKzpqc8uJp+Gt+clbJ+3Mb2
         rtwAe3RAKfVf8UY8pZiISeKE9jslkDzt/oWJEbrmVtZoYePty2BMn89iOBFdtRHsyP20
         Vf3shxoMhjh4ylWhkCKHQUmbIqLXivUhGtVEdRhtMRnhbHpoqpMaXLGvVb3xl1eKIFUl
         NozVw7BjCzzLeHEMv9a8qdcoIMaISJLrMD3V/mXdbLMLeKAlVQcojiBflUjp8Ydc8wxQ
         AboiJFtQ+Q6vG42RAt4p15H0Ju1eLnCFGb7k/LwBMmWyAg7NvuoJI2eS3o/1zkSIGQXA
         dfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=wYE/nhc4N92v6LXkAKkrTf5th+f3+Wju4vNytZnYrvI=;
        b=o+E+tKRSYP+UC1JhMwcRTr2pZiiP3Bl+zYaLEPtIsV4pic5K2OWyX48RVm8QiYEkl5
         cV3zGzwzgfpsp9PzF2vGIzepfLU/6Q2THOOk+uLG9ZGQCjvu9GQLzZ2d1X+05qvKqcmv
         VmrOnYl9lAspRISlB+mcMC3qo81TkkUK/kBnz8oUtxgTEbQIAknPMYW3ZBesznMRNA/i
         oqGlg6Wwl8lcBPy2bU0tC+4zFb8ajySwOLtKJokf4tSpTAV/Wq6exQNMJDPvJ6fwhwIF
         xsjno0T0JF6uBCKKInRgwoJ5+Hua66qN/BuEhtZpGWYM6hOWLkNK8xF6hcDm22A8lPk+
         vQsA==
X-Gm-Message-State: APjAAAUcE/jzgGE6YqspEjELFRdAne+wBS9SUv7+HAccv/etcLINQb6A
        TmQcxr5lT1QLNew5MpmRU1vQocb1Ag4=
X-Google-Smtp-Source: APXvYqwcxM/LHAt08mGwsS9gTr/2RF7hUy13btsugqaeyPE/Sy+8S6Q0u0uu2Xa/F5Ka/uN8VO16LQ==
X-Received: by 2002:adf:f68b:: with SMTP id v11mr10169330wrp.116.1563796595786;
        Mon, 22 Jul 2019 04:56:35 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id m24sm24096366wmi.39.2019.07.22.04.56.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 04:56:35 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] Revert "kvm: x86: Use task structs fpu field for user"
Date:   Mon, 22 Jul 2019 13:56:34 +0200
Message-Id: <1563796594-25317-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 0cc5b611a113..b2f1ffb937af 100644
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
index 58305cf81182..cf2afdf8facf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8270,7 +8270,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(&current->thread.fpu);
+	copy_fpregs_to_fpstate(&vcpu->arch.user_fpu);
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
@@ -8287,7 +8287,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	fpregs_lock();
 
 	copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
-	copy_kernel_to_fpregs(&current->thread.fpu.state);
+	copy_kernel_to_fpregs(&vcpu->arch.user_fpu.state);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
1.8.3.1

