Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B0E1D8A2F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 23:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgERVnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 17:43:08 -0400
Received: from o1.dev.nutanix.com ([198.21.4.205]:57039 "EHLO
        o1.dev.nutanix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgERVnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 17:43:08 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2020 17:43:08 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sendgrid.net; 
        h=from:to:cc:subject:mime-version:content-transfer-encoding; 
        s=smtpapi; bh=JyhxMm+Y9a7fjPz/PBMgYlMCWgvafYN43d9h18/IJbI=; b=K3
        6rKQEhR78CJvDghmo3MHIE6s5bH5bs5zAp8nvnnkhgve+Kdbd9XDenKd1LfjSPqe
        f0o1wsVQDVbFasd6HPA7jqxEoAXTglsrpRQ13/CDKEy0KD6RV9tSzgqxDv3Sg15W
        xQeeBpDWXG4icd4d5GZ1ggwZ2/QylNf3u084ELG1Q=
Received: by filter1137p1las1.sendgrid.net with SMTP id filter1137p1las1-22580-5EC2FFE0-18
        2020-05-18 21:36:32.413492831 +0000 UTC m=+8938.670754625
Received: from debian.localdomain (unknown)
        by ismtpd0005p1lon1.sendgrid.net (SG) with ESMTP id GjyWYWl9Q9OZMewhNqAgqw
        Mon, 18 May 2020 21:36:31.830 +0000 (UTC)
From:   Felipe Franciosi <felipe@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, stable@vger.kernel.org,
        Felipe Franciosi <felipe@nutanix.com>
Subject: [PATCH] KVM: x86: respect singlestep when emulating instruction
Date:   Mon, 18 May 2020 21:36:32 +0000 (UTC)
Message-Id: <20200518213620.2216-1-felipe@nutanix.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
content-transfer-encoding: quoted-printable
X-SG-EID: CGtAtjf4Go6FDPc8ef3PWsOov9FWDSRj47sg/PtefHC6AApxWf5Ur/6xfv3D9RXUUQnZOws+Rw5UKP
 RmPAG3u8rVsysSOS96R+hhXn9p5O4wAAMkwfoxrDX47S3M5sNjfPVID4VKosElSk9uXGeOchJp6iNe
 oZNqrW4i7IdK0+z6ixHIoznwwd0AYnh0XSoscN7DiLDj8m3jUxCN+vDwJOTs4KfeHdsoVVzFG4GXue
 g=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When userspace configures KVM_GUESTDBG_SINGLESTEP, KVM will manage the=0D
presence of X86_EFLAGS_TF via kvm_set/get_rflags on vcpus. The actual=0D
rflag bit is therefore hidden from callers.=0D
=0D
That includes init_emulate_ctxt() which uses the value returned from=0D
kvm_get_flags() to set ctxt->tf. As a result, x86_emulate_instruction()=0D
will skip a single step, leaving singlestep_rip stale and not returning=0D
to userspace.=0D
=0D
This resolves the issue by observing the vcpu guest_debug configuration=0D
alongside ctxt->tf in x86_emulate_instruction(), performing the single=0D
step if set.=0D
=0D
Signed-off-by: Felipe Franciosi <felipe@nutanix.com>=0D
---=0D
 arch/x86/kvm/x86.c | 2 +-=0D
 1 file changed, 1 insertion(+), 1 deletion(-)=0D
=0D
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c=0D
index c17e6eb9ad43..78463f01c606 100644=0D
--- a/arch/x86/kvm/x86.c=0D
+++ b/arch/x86/kvm/x86.c=0D
@@ -6919,7 +6919,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gp=
a_t cr2_or_gpa,=0D
 		if (!ctxt->have_exception ||=0D
 		    exception_type(ctxt->exception.vector) =3D=3D EXCPT_TRAP) {=0D
 			kvm_rip_write(vcpu, ctxt->eip);=0D
-			if (r && ctxt->tf)=0D
+			if ((r && ctxt->tf) || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))=
=0D
 				r =3D kvm_vcpu_do_singlestep(vcpu);=0D
 			if (kvm_x86_ops.update_emulated_instruction)=0D
 				kvm_x86_ops.update_emulated_instruction(vcpu);=0D
-- =0D
2.20.1=0D

