Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8684EA6E99
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfICQ1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbfICQ1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C7F2343A;
        Tue,  3 Sep 2019 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528035;
        bh=YODQn4bJzJ0Lbaw3j5vgOebSPIQaDZawm8/CBsQrlHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLgtf+tHqj5VpoExkIfArD076U3aSEiKgBF10tM2FkZNLVgVaJPZuI/Q92lDryo9R
         s5nMyXDRaOe5x4uP/SP21+5wJJCbbM7b63dBCVQiR8iQGtdayk5egSGxFO1GdxXaf5
         ONNd9EkPk2HMtaWHzTV/VvRBmmR6SFfUviZEDHoQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 065/167] KVM: VMX: Compare only a single byte for VMCS' "launched" in vCPU-run
Date:   Tue,  3 Sep 2019 12:23:37 -0400
Message-Id: <20190903162519.7136-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 61c08aa9606d4e48a8a50639c956448a720174c3 ]

The vCPU-run asm blob does a manual comparison of a VMCS' launched
status to execute the correct VM-Enter instruction, i.e. VMLAUNCH vs.
VMRESUME.  The launched flag is a bool, which is a typedef of _Bool.
C99 does not define an exact size for _Bool, stating only that is must
be large enough to hold '0' and '1'.  Most, if not all, compilers use
a single byte for _Bool, including gcc[1].

Originally, 'launched' was of type 'int' and so the asm blob used 'cmpl'
to check the launch status.  When 'launched' was moved to be stored on a
per-VMCS basis, struct vcpu_vmx's "temporary" __launched flag was added
in order to avoid having to pass the current VMCS into the asm blob.
The new  '__launched' was defined as a 'bool' and not an 'int', but the
'cmp' instruction was not updated.

This has not caused any known problems, likely due to compilers aligning
variables to 4-byte or 8-byte boundaries and KVM zeroing out struct
vcpu_vmx during allocation.  I.e. vCPU-run accesses "junk" data, it just
happens to always be zero and so doesn't affect the result.

[1] https://gcc.gnu.org/ml/gcc-patches/2000-10/msg01127.html

Fixes: d462b8192368 ("KVM: VMX: Keep list of loaded VMCSs, instead of vcpus")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2e310ea62d609..562f5dc4645b6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10808,7 +10808,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"mov %%" _ASM_AX", %%cr2 \n\t"
 		"3: \n\t"
 		/* Check if vmlaunch of vmresume is needed */
-		"cmpl $0, %c[launched](%0) \n\t"
+		"cmpb $0, %c[launched](%0) \n\t"
 		/* Load guest registers.  Don't clobber flags. */
 		"mov %c[rax](%0), %%" _ASM_AX " \n\t"
 		"mov %c[rbx](%0), %%" _ASM_BX " \n\t"
-- 
2.20.1

