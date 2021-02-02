Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEAD30CA41
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237837AbhBBSnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233701AbhBBOCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:02:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6BDD65009;
        Tue,  2 Feb 2021 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273680;
        bh=9jlpwl0vd1nEsyhkgt2MrOrRk54Wj74gwVYnyNkU3jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTdt9SmhR35kONyf99DHefsqKWmGrmSucq3UXxV0kUm3t0bT6elrPO/L4aETob56Z
         Q+e6OBgj4ITb+1FcpgA1bsVrVWjBBDGJnzmcax9Ujxhw7jEN+h19Aqp3Ip9UhF1/zX
         u2dBXFVkiHGyGWIYxx+0eo1QPbY9ffcBMLmCcklw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Zhou <jianjay.zhou@huawei.com>,
        Shengen Zhuang <zhuangshengen@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 20/61] KVM: x86: get smi pending status correctly
Date:   Tue,  2 Feb 2021 14:37:58 +0100
Message-Id: <20210202132947.306956316@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
@@ -102,6 +102,7 @@ static u64 __read_mostly cr4_reserved_bi
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
+static void process_smi(struct kvm_vcpu *vcpu);
 static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
@@ -3772,6 +3773,10 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_
 {
 	process_nmi(vcpu);
 
+
+	if (kvm_check_request(KVM_REQ_SMI, vcpu))
+		process_smi(vcpu);
+
 	/*
 	 * The API doesn't provide the instruction length for software
 	 * exceptions, so don't report them. As long as the guest RIP


