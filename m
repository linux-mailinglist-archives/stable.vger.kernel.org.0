Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8A1B60B8
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 11:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfIRJuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 05:50:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38189 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfIRJuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 05:50:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so4039740pfe.5;
        Wed, 18 Sep 2019 02:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H0Psu3PhVMw4W2UhvH+UB9Pvbou3FZjlccsYwKn7bM4=;
        b=ahAQSlgQn+DpqeTBcw+FkvdwHW++TZRDbKgIrEkmvidIcVZEhJ7jsHf587MdjE8/lY
         gXaXJNs1CTtq7ZNrP9MUn3QZsSqH+GnLMTVs5ye72FSvjD2uGDkRVjnKzvqST5XkMfJ2
         q21Y6UhoFJbm+mL0X4r0hj2uJoRkK6FkSMFAIDtURRPt4plGOsDhu9wospOYGlqIO2NY
         wQAg2zxYYBcA297PcKLbOs/5NiUD72bqRoxDfpb4502sKZXO2IsFGA5H9/LcD+1G/Txl
         VXK0yujKvgiR38nbdWPPAnhGFkhAwJgMh3j2qLCNhWLNlHDbbxYEdVlW+tEP1CzQTQWU
         AW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H0Psu3PhVMw4W2UhvH+UB9Pvbou3FZjlccsYwKn7bM4=;
        b=Pn06wVi4E81MKZm43aTKV9if0wCiFW7ORd0JhjoRdFosiCMUOao43CJWj0RqrNZ6EL
         qjLebLQ/2hKv2ZdNRmzWNtj63/tuAtbd2iAYV0K7bWdHf15XeZUsDFUxHpz01X8tJJZN
         DBWgLiAzcBbHldPI9z5JKZLLmSvwFSwwZxO/i1rvtlpvXOSZrz+BPo8IW6Nx+zqDpcHy
         j/E3MkQ8DsSyvtUmAs5BSRAZi8xxr4L7n+bEPlfbA6004fPTiL2+xYaOhrQrohLq+WdW
         Va6PmwsbaSZaHGM8vRjIcBHoA5LOYVUar0MC9Zcr8qzjYpfrzj1b+OXDpqPpjDheP0Ob
         K+5w==
X-Gm-Message-State: APjAAAW2Z1dq737u5w7nwXzB3k0VdAKvtcvxexgZv+ItccxZXfGsw2tQ
        PZWy4Ag/B5ZEVFZhz+aR4PnvBnj1
X-Google-Smtp-Source: APXvYqxC9/NkTpM8jBHZ9ArfFP0frb/EJYTyB9VpuWjutvkwWhf+7i3r2zMFEogdqVw0iFhG+xKgzw==
X-Received: by 2002:a63:70d:: with SMTP id 13mr3195301pgh.326.1568800220986;
        Wed, 18 Sep 2019 02:50:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g24sm8496563pgn.90.2019.09.18.02.50.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Sep 2019 02:50:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH v3] KVM: X86: Fix userspace set invalid CR4
Date:   Wed, 18 Sep 2019 17:50:10 +0800
Message-Id: <1568800210-3127-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

	WARNING: CPU: 0 PID: 6544 at /home/kernel/data/kvm/arch/x86/kvm//vmx/vmx.c:4689 handle_desc+0x37/0x40 [kvm_intel]
	CPU: 0 PID: 6544 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
	RIP: 0010:handle_desc+0x37/0x40 [kvm_intel]
	Call Trace:
	 vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
	 vcpu_enter_guest+0x4dc/0x18d0 [kvm]
	 kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
	 kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
	 do_vfs_ioctl+0xa2/0x690
	 ksys_ioctl+0x6d/0x80
	 __x64_sys_ioctl+0x1a/0x20
	 do_syscall_64+0x74/0x720
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

When CR4.UMIP is set, guest should have UMIP cpuid flag. Current
kvm set_sregs function doesn't have such check when userspace inputs
sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP
in vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast
triggers handle_desc warning when executing ltr instruction since
guest architectural CR4 doesn't set UMIP. This patch fixes it by
adding valid CR4 and CPUID combination checking in __set_sregs.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=138efb99600000

Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7cfd8e..d23cf0d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -884,34 +884,42 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
-int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	unsigned long old_cr4 = kvm_read_cr4(vcpu);
-	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
-				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
-
 	if (cr4 & CR4_RESERVED_BITS)
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) && (cr4 & X86_CR4_OSXSAVE))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMEP) && (cr4 & X86_CR4_SMEP))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMAP) && (cr4 & X86_CR4_SMAP))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_FSGSBASE) && (cr4 & X86_CR4_FSGSBASE))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_PKU) && (cr4 & X86_CR4_PKE))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_LA57) && (cr4 & X86_CR4_LA57))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) && (cr4 & X86_CR4_UMIP))
+		return -EINVAL;
+
+	return 0;
+}
+
+int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	unsigned long old_cr4 = kvm_read_cr4(vcpu);
+	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
+				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+
+	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
 
 	if (is_long_mode(vcpu)) {
@@ -8641,10 +8649,6 @@ EXPORT_SYMBOL_GPL(kvm_task_switch);
 
 static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-			(sregs->cr4 & X86_CR4_OSXSAVE))
-		return  -EINVAL;
-
 	if ((sregs->efer & EFER_LME) && (sregs->cr0 & X86_CR0_PG)) {
 		/*
 		 * When EFER.LME and CR0.PG are set, the processor is in
@@ -8663,7 +8667,7 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 			return -EINVAL;
 	}
 
-	return 0;
+	return kvm_valid_cr4(vcpu, sregs->cr4);
 }
 
 static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
-- 
2.7.4

