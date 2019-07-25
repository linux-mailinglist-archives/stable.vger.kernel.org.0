Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4366874D78
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404319AbfGYLtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:49:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40786 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404296AbfGYLtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 07:49:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so44488498wmj.5
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 04:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahpb6xPK075Z6njHxQUERLqrZnJthEhBDnChxsDJ0yI=;
        b=nT1K0F4WRgwaG1uCRNhJASaeJOeZqh/LKzb/rjeZ6spK8J1R0gT8ofLY0gTT/Iwy/V
         yg3QWPBjGhsDYvf6DPXZ0pdO4vIJ9KWZY/kqRc8lbPpgHcymtFsRS8KnpSdyUrZhkmB+
         qJDH03Z4tcgOSsBFjIygZWQl8cxyjs+TZ7y+ZAh5WGPyZ+wI9EGOVXTLhT4BLjStbuZt
         vJgGI4OD2Wb6Cw+Ctc1qQqG6nqBw2Zas6eiOJxWrWKMthBDM+X96SUhwf6QF1QKh5CPo
         fF6phEG5HdtvSKhjfxQ+bLs5MkKOvPZyfjU0dYOrcFlOHHIbho9yXsVP3JRxayzx8V2x
         x3vA==
X-Gm-Message-State: APjAAAXhIROqcb1uvzanMckCXE/Kjqg9g10EU1cq1aaMGub1D2gapQ8F
        YIpt5IU5jyG3Ss9WVZUi1M14qtHvPVc=
X-Google-Smtp-Source: APXvYqysh53Nn7YpCuVhrX6td5G/bTjwKnhelBX4YvIb8Js+9A/cGM/O1IBBsQ19J2X8WwmSCryqSg==
X-Received: by 2002:a7b:cf0b:: with SMTP id l11mr83901119wmg.143.1564055381570;
        Thu, 25 Jul 2019 04:49:41 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t140sm44784683wmt.0.2019.07.25.04.49.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:49:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.1 1/3] KVM: nVMX: do not use dangling shadow VMCS after guest reset
Date:   Thu, 25 Jul 2019 13:49:36 +0200
Message-Id: <20190725114938.3976-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725114938.3976-1-vkuznets@redhat.com>
References: <20190725114938.3976-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 88dddc11a8d6b09201b4db9d255b3394d9bc9e57 ]

If a KVM guest is reset while running a nested guest, free_nested will
disable the shadow VMCS execution control in the vmcs01.  However,
on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
the VMCS12 to the shadow VMCS which has since been freed.

This causes a vmptrld of a NULL pointer on my machime, but Jan reports
the host to hang altogether.  Let's see how much this trivial patch fixes.

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4ca834d22169..3f48006a43ec 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -184,6 +184,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL, SECONDARY_EXEC_SHADOW_VMCS);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmx->nested.need_vmcs12_sync = false;
 }
 
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
@@ -1328,6 +1329,9 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 	u64 field_value;
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	preempt_disable();
 
 	vmcs_load(shadow_vmcs);
@@ -1366,6 +1370,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	u64 field_value = 0;
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	vmcs_load(shadow_vmcs);
 
 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
@@ -4340,7 +4347,6 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 		/* copy to memory all shadowed fields in case
 		   they were modified */
 		copy_shadow_to_vmcs12(vmx);
-		vmx->nested.need_vmcs12_sync = false;
 		vmx_disable_shadow_vmcs(vmx);
 	}
 	vmx->nested.posted_intr_nv = -1;
-- 
2.20.1

