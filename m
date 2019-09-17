Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048DEB4900
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 10:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731803AbfIQIQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 04:16:38 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38983 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfIQIQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 04:16:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id i1so1689712pfa.6;
        Tue, 17 Sep 2019 01:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=flYRSMt8pIOAP3TA8EAVhdOF1+uRuM0MoI3dzcIAOic=;
        b=lUYe/HN8N3La1GQJ554woX+0srWbLV+S94trrY+6GwRi+jUkdvybgbHGxOeCa7k2Op
         NBOEUxvOVzshmU394xTkfz5PCGSmBdGZaw4OUeMorK6sfdN/p9YfRla/dZ/eommEb50S
         XFoZnqEbH84ddJC/KndIgnGvscspqD0VCEquGKxTNWfxEUEUQ/YGK8nzW9yC4Wehp6jC
         O9u0Zhoy1PMRAswOo0GXMeRi/Wbu5pobkKPwmZrG0IXQ9eivymKXRo99Joz4fjSavyAC
         VZqRKTGZdX9ruHK2RmPi6uoKrUiD3NI+vVqhdntCGqaXMnG+iT99OP6IlReYyNtNFi36
         BJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=flYRSMt8pIOAP3TA8EAVhdOF1+uRuM0MoI3dzcIAOic=;
        b=rj8o9wOgJDq4EiSln2IK2jmPw+yf4aVL3MvNObhpZh+R805p7btuwp8A/ja+r4N0L7
         4aC7W5FxCQd7hQx0FHezNCltd32Ky+dSUAFTHxGcUO3rb+LE+FHpnk0LVWWnXrTblPUw
         I37eZiYOQlfnVQE8z1KDTyR2kszbh5aEpBvYQh+8H9bc2Wsx1O0UPh7f5zeJ8WZEXr8N
         AQqAzyJHvahVLXh7eyKYTZuhfisqNcB423A3A6n/fr8K1g7cBOf7WujEmr+AS4+zt3zR
         ZYdAFrV2bcCz16GMugjt9IePbxP9RgBKytHd0s/ybbKcElQb4VMpHZ0WxthTk9UtcPlS
         gO+g==
X-Gm-Message-State: APjAAAVRGPk6nQkajipNo4tkbwmpAHNVdia1Bbu6ysEr5N9hmIqupcKC
        llKn4E71mHlgIHuADqdihi7CzOad
X-Google-Smtp-Source: APXvYqz3ie3yVwYKkCr/8naCaiieW3a+kAzHMAbDb6B2dHhP8we0iuGsW39wpjQ+/OgbzMnP9231Hg==
X-Received: by 2002:a63:d301:: with SMTP id b1mr2127747pgg.379.1568708196244;
        Tue, 17 Sep 2019 01:16:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j10sm1924142pfh.137.2019.09.17.01.16.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Sep 2019 01:16:35 -0700 (PDT)
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
Subject: [PATCH v2 2/3] KVM: X86: Fix userspace set broken combinations of CPUID and CR4
Date:   Tue, 17 Sep 2019 16:16:25 +0800
Message-Id: <1568708186-20260-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7cfd8e..cafb4d4 100644
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
-	if (cr4 & CR4_RESERVED_BITS)
-		return 1;
-
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
+	if (cr4 & CR4_RESERVED_BITS)
+		return 1;
+
+	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
 
 	if (is_long_mode(vcpu)) {
@@ -8675,7 +8683,8 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	struct desc_ptr dt;
 	int ret = -EINVAL;
 
-	if (kvm_valid_sregs(vcpu, sregs))
+	if (kvm_valid_sregs(vcpu, sregs) ||
+		kvm_valid_cr4(vcpu, sregs->cr4))
 		goto out;
 
 	apic_base_msr.data = sregs->apic_base;
-- 
2.7.4

