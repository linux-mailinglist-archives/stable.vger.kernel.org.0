Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E5E44866
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393265AbfFMRDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 13:03:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52718 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbfFMRDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 13:03:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so10997979wms.2;
        Thu, 13 Jun 2019 10:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rSclv6ckrkEu5swjf7zPGHU+6F6iEfrM6t9n/L0M83k=;
        b=kW9Mi9c529wb/AlzC9pKtjVmvHUahC1HbneDmyDPdsIFbdrYGiA4JVLGRTDPJV+fVD
         Vde3tY8Z96NnM9F9gsUuJwLSCJL9F9AqIqM4p+xWyIjHffX8aQrDxsl31nwLQr0xZuUF
         mM5d8Lp6auIMnXYWzzLWOpB0b9Bu2anPhYOqRdlq8vENv+GFFiqTIYvBs7h/N+jLYihN
         80reW2tMCGkjnMWE5qqQJuO0vaHRDz0mDn6TkWV2Or9fnVwt3ssgC0OZFlsD/5+bAhor
         Gb3QmVlKZL1/50AMkHQhCY+bnwwbL3ySsiZMJgVECvbFddBB98KMcg2N/E0V0fROMdHy
         oaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=rSclv6ckrkEu5swjf7zPGHU+6F6iEfrM6t9n/L0M83k=;
        b=q8N2MwijTP7OklVF1/JKk7B6I+F5KHsaRSok4dPkorSyipqsH+JEDdxoBhdd3eWa8r
         ml3olWnSG/oQm58N9kr7hMa11u9ZV084iAu6Vf0fwsbliKJ8VwhEfdEXcd0X6t47AUOt
         iwXdL1/cLO940rT03J/g1YFDNJekKvNdgyQ/yDJcsngq7Sxrfv3YIIw3dfwip/2Gkx+t
         ASgzbtMKnuTsKqdUUF7IUQxVgkn0+RjlLEJyYsV+7b2Rafqk0ZtMhxq/TnVweSHsyrYy
         skIThqKxI6GdiReNFWQHVaxm5LcjtIZbLv1Pt0JURl+LD0pzoHzmTYChMi5aTjXHcRx5
         YAMg==
X-Gm-Message-State: APjAAAWQxk3PrmGQOfhZ089XYzDpBZ37mmAVa7qk4iSuuzhZ+DhsPcoN
        A0dIZ7OJXWIFE/i3N6rEbaXcQ77R
X-Google-Smtp-Source: APXvYqw41nr2OGsyaDadsZU1c3EvMZVnu0LxaAHcDuesA3f+3vBwCXxYBAspUg75ImTM6jpIRgw5HQ==
X-Received: by 2002:a1c:a6d3:: with SMTP id p202mr4793150wme.26.1560445412102;
        Thu, 13 Jun 2019 10:03:32 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:31 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/43] KVM: VMX: Fix handling of #MC that occurs during VM-Entry
Date:   Thu, 13 Jun 2019 19:02:47 +0200
Message-Id: <1560445409-17363-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

A previous fix to prevent KVM from consuming stale VMCS state after a
failed VM-Entry inadvertantly blocked KVM's handling of machine checks
that occur during VM-Entry.

Per Intel's SDM, a #MC during VM-Entry is handled in one of three ways,
depending on when the #MC is recognoized.  As it pertains to this bug
fix, the third case explicitly states EXIT_REASON_MCE_DURING_VMENTRY
is handled like any other VM-Exit during VM-Entry, i.e. sets bit 31 to
indicate the VM-Entry failed.

If a machine-check event occurs during a VM entry, one of the following occurs:
 - The machine-check event is handled as if it occurred before the VM entry:
        ...
 - The machine-check event is handled after VM entry completes:
        ...
 - A VM-entry failure occurs as described in Section 26.7. The basic
   exit reason is 41, for "VM-entry failure due to machine-check event".

Explicitly handle EXIT_REASON_MCE_DURING_VMENTRY as a one-off case in
vmx_vcpu_run() instead of binning it into vmx_complete_atomic_exit().
Doing so allows vmx_vcpu_run() to handle VMX_EXIT_REASONS_FAILED_VMENTRY
in a sane fashion and also simplifies vmx_complete_atomic_exit() since
VMCS.VM_EXIT_INTR_INFO is guaranteed to be fresh.

Fixes: b060ca3b2e9e7 ("kvm: vmx: Handle VMLAUNCH/VMRESUME failure properly")
Cc: Jim Mattson <jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d903f8909d1..1b3ca0582a0c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6107,28 +6107,21 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
 {
-	u32 exit_intr_info = 0;
-	u16 basic_exit_reason = (u16)vmx->exit_reason;
-
-	if (!(basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY
-	      || basic_exit_reason == EXIT_REASON_EXCEPTION_NMI))
+	if (vmx->exit_reason != EXIT_REASON_EXCEPTION_NMI)
 		return;
 
-	if (!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
-		exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-	vmx->exit_intr_info = exit_intr_info;
+	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	/* if exit due to PF check for async PF */
-	if (is_page_fault(exit_intr_info))
+	if (is_page_fault(vmx->exit_intr_info))
 		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
 
 	/* Handle machine checks before interrupts are enabled */
-	if (basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY ||
-	    is_machine_check(exit_intr_info))
+	if (is_machine_check(vmx->exit_intr_info))
 		kvm_machine_check();
 
 	/* We need to handle NMIs before interrupts are enabled */
-	if (is_nmi(exit_intr_info)) {
+	if (is_nmi(vmx->exit_intr_info)) {
 		kvm_before_interrupt(&vmx->vcpu);
 		asm("int $2");
 		kvm_after_interrupt(&vmx->vcpu);
@@ -6535,6 +6528,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+		kvm_machine_check();
+
 	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return;
 
-- 
1.8.3.1


