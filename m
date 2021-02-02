Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019CA30C80D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhBBRj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:39:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234024AbhBBOM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328C564FB3;
        Tue,  2 Feb 2021 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273937;
        bh=ap8D5h2Uoo5QL65hGFaPloFqwO29iOjT17jgglPdjHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xw5ORjEzf2rNx97yqKRfGX3TmanO5pnhtq9PZAKxKIB7Z2VhUH4bZ4GBpaet5BNyQ
         3rHjXnKuaQvvHC+32BD3G7R4dqWTxHnp/ztthFoJXAMJ5nWXJe+KYXTWHSDtKVi81S
         5c4q2iP30eKowb83QlXzq2e36dOrjQXljmIdCreA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Zhou <jianjay.zhou@huawei.com>,
        Shengen Zhuang <zhuangshengen@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 09/30] KVM: x86: get smi pending status correctly
Date:   Tue,  2 Feb 2021 14:38:50 +0100
Message-Id: <20210202132942.516085515@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Zhou <jianjay.zhou@huawei.com>

commit 1f7becf1b7e21794fc9d460765fe09679bc9b9e0 upstream.

The injection process of smi has two steps:

    Qemu                        KVM
Step1:
    cpu->interrupt_request &= \
        ~CPU_INTERRUPT_SMI;
    kvm_vcpu_ioctl(cpu, KVM_SMI)

                                call kvm_vcpu_ioctl_smi() and
                                kvm_make_request(KVM_REQ_SMI, vcpu);

Step2:
    kvm_vcpu_ioctl(cpu, KVM_RUN, 0)

                                call process_smi() if
                                kvm_check_request(KVM_REQ_SMI, vcpu) is
                                true, mark vcpu->arch.smi_pending = true;

The vcpu->arch.smi_pending will be set true in step2, unfortunately if
vcpu paused between step1 and step2, the kvm_run->immediate_exit will be
set and vcpu has to exit to Qemu immediately during step2 before mark
vcpu->arch.smi_pending true.
During VM migration, Qemu will get the smi pending status from KVM using
KVM_GET_VCPU_EVENTS ioctl at the downtime, then the smi pending status
will be lost.

Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
Signed-off-by: Shengen Zhuang <zhuangshengen@huawei.com>
Message-Id: <20210118084720.1585-1-jianjay.zhou@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -98,6 +98,7 @@ static u64 __read_mostly efer_reserved_b
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
+static void process_smi(struct kvm_vcpu *vcpu);
 static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 
@@ -3290,6 +3291,10 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_
 					       struct kvm_vcpu_events *events)
 {
 	process_nmi(vcpu);
+
+	if (kvm_check_request(KVM_REQ_SMI, vcpu))
+		process_smi(vcpu);
+
 	/*
 	 * FIXME: pass injected and pending separately.  This is only
 	 * needed for nested virtualization, whose state cannot be


