Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215B46EC24
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfGSVjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 17:39:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36534 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfGSVjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 17:39:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so26127378wme.1;
        Fri, 19 Jul 2019 14:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=dJZwB/Clkci6ZFRbtdSU37FYwxEFZIATbsU+Tyu15yU=;
        b=J5/uLkUQiySkxXmK4m2T0AjaKrFTGYUOyNeGEK/FehRSVzgscPlWhQi3qkQ1LU7R1H
         t/fN2q9m/LRjIgu59k+dJllD0xfhaHaoHFBXemQbpAfD6UphBhYJeJ03Uv8+E7ckRFc4
         YPCJGeORBPmXuqlD2Ir10H8NA/XeZTzr3uKGVO2nGUSUAs3LfeK9aU8qZH5fkZu6Oqd3
         LBk0KI38nPeuqE6fM/aASkK8CDDk0ze/P/OjZmPt4nIvoyt+YmyBnaFTuoWC+PCMMMM3
         Lur/5TnAZCngt3K7UlBO5OQZEakO+WOpSopYTjpRGZgAZGFQVRDbLCGCJSAwIQjGmi7z
         MOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=dJZwB/Clkci6ZFRbtdSU37FYwxEFZIATbsU+Tyu15yU=;
        b=i91lo4GOHzSZl7lsAyfsuZ1dbJJXj1o++1IoC3JkgV7RPCAkrjm/WSmzypiMudS/u8
         i7xKxRGf9kzFZU/ht5q+/GfOnCV/ExVv0NRCREqLbxY1hJ3MUEZSSBZY6PXw2rAnTBvm
         8gYfTKqeio/MuN0ZFgo4eDokXwDQRblIv5yDx36P/CtO8y/N4RSbt14k7/Amk36vweH4
         nCRdDgiE5dqeMBW4956K0nB6t7uI6z6d8Wyod59MMTSKOt+sd7vH0GgNt4fAK8n236Jl
         K3ULj6niZBK3dxWLhxhwuM0bwd36mRXF1kxCIHlxY0oM3otbolBSLOpuas/ZqTBedFHc
         IEYw==
X-Gm-Message-State: APjAAAWaXHqbM32MrbFQ5tPOeHSKox29AnH8m4QKic2V/HYnGm5GfbPS
        t6dKa3VZeznlXYF2HsC8aXNuvBoQ9aA=
X-Google-Smtp-Source: APXvYqy22DLKRAzSsbKsRzshsG+BNywMNiZsLK/xOpZhQVmuyq2WCMJhopvjLFhb8SHCCAhir6F9eA==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr48223115wmm.108.1563572392538;
        Fri, 19 Jul 2019 14:39:52 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i18sm39303874wrp.91.2019.07.19.14.39.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 14:39:51 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>, stable@vger.kernel.org
Subject: [PATCH v2] KVM: nVMX: do not use dangling shadow VMCS after guest reset
Date:   Fri, 19 Jul 2019 23:39:50 +0200
Message-Id: <1563572390-28823-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 4f23e34f628b..0f1378789bd0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
@@ -1341,6 +1342,9 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 	unsigned long val;
 	int i;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	preempt_disable();
 
 	vmcs_load(shadow_vmcs);
@@ -1373,6 +1377,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	unsigned long val;
 	int i, q;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	vmcs_load(shadow_vmcs);
 
 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
@@ -4436,7 +4443,6 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 		/* copy to memory all shadowed fields in case
 		   they were modified */
 		copy_shadow_to_vmcs12(vmx);
-		vmx->nested.need_vmcs12_to_shadow_sync = false;
 		vmx_disable_shadow_vmcs(vmx);
 	}
 	vmx->nested.posted_intr_nv = -1;
-- 
1.8.3.1

