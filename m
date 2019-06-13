Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342264486B
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 19:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393308AbfFMRDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 13:03:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51195 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404533AbfFMRDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 13:03:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id c66so10985868wmf.0;
        Thu, 13 Jun 2019 10:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DhIcMejBJdxQAmrC0DE4pRw6tryHHTsWn2zI8kJgzxo=;
        b=hZ3ZF2MYe0PwL8KBBkQW7fNxjg1PIHkhgdW9RmBGd2Ahbv3PqmmUU9Mta77U2Gq+B8
         HSKwAhswuu5vT72DXtQHbukXdVkLkne/fnZB6iIyDS4FOjDpq8LjO3Vkm6Fw1Y7Elibf
         bqyZAy3Wu8aov5d1c+FeL0kXQwGFWaVCdZGmlL3Jlb3xT3ymth9m3rJNLXYIgHlxV52r
         bpiFURmw1k3aYeKZDLpT/N9lAjv93GTHFn7i1b/n7tRAc9AuOSg3o/7thhrZqCFT4ITE
         3KPxSuwCgJAYcPlOFm2vLOO0+/OMeI6hVlGJNs1uC36XHCvqGBLJf3kXfKVhKIH/5uWC
         ghhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=DhIcMejBJdxQAmrC0DE4pRw6tryHHTsWn2zI8kJgzxo=;
        b=lkE/4ljsT1vF75lGsyjDtjzhN7HWYphFQLBL6fDdb9zH+KF2zeg8sqZjyjSuWd9mCK
         D62sUj0b2RJr9mbvhPtg5IoP4xoGwujvPE2Lo3XI8TSM7HPLwfpNFYlCGgN7B6cxBade
         pUtPoaYxgdyU07LKhk/pVvdLKl9SgPbDKDm0oy70eFUBceC0E12giarkq3mxEfcj00mi
         X6A595I1oTdK/bfzevxGWCVGrHAfJ1mqjexvMhC+grE1XnT2PUvtlTTQuNszeb5iV5pS
         oA/9wawbXjxGOeGIKSkfPjZdNrqXU6LfCNi07kobcr1s2diZ/VsNnu0Ttci3U2Xr/PJG
         JBmg==
X-Gm-Message-State: APjAAAV8/omK1qiQnbrnIuc3SDEScm25efOw8tBobSKikr+wFydCalXu
        R/IwKROvNj4ffyJM6BIOPlv9DYOz
X-Google-Smtp-Source: APXvYqxq8fRFDG4a8bogFdJ/wvIr/GY4DjyUk6JrZ4jLquYWaLwfhu0weueXLYK/fk1YMWVfPyGnjw==
X-Received: by 2002:a1c:c912:: with SMTP id f18mr4402885wmb.118.1560445430834;
        Thu, 13 Jun 2019 10:03:50 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:50 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com, stable@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 16/43] KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
Date:   Thu, 13 Jun 2019 19:03:02 +0200
Message-Id: <1560445409-17363-17-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

If L1 does not set VM_ENTRY_LOAD_BNDCFGS, then L1's BNDCFGS value must
be propagated to vmcs02 since KVM always runs with VM_ENTRY_LOAD_BNDCFGS
when MPX is supported.  Because the value effectively comes from vmcs01,
vmcs02 must be updated even if vmcs12 is clean.

Fixes: 62cf9bd8118c4 ("KVM: nVMX: Fix emulation of VM_ENTRY_LOAD_BNDCFGS")
Cc: stable@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fb7eddd64714..f2be64256f15 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2228,13 +2228,9 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
 	set_cr4_guest_host_mask(vmx);
 
-	if (kvm_mpx_supported()) {
-		if (vmx->nested.nested_run_pending &&
-			(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
-			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
-		else
-			vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
-	}
+	if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+		vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 }
 
 /*
@@ -2266,6 +2262,9 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.vmcs01_debugctl);
 	}
+	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
+		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
-- 
1.8.3.1


