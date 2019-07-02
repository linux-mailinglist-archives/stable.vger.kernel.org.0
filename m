Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C685D255
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGBPEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 11:04:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42067 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfGBPEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 11:04:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so18219705wrl.9;
        Tue, 02 Jul 2019 08:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t56wQhmbC0eK6Si58Q9wqbieCBfEkE9Pa30U73bNL2s=;
        b=LPtQII5df23fZnUhJhsdshpakbDmVhjyV7jWcOKOIs2e/ZHfr3fEGBH+6nvj8DsUCY
         gLD40CWql4WreFhw2fHLTNvEji3Gr/jZMEm6Ix2brFwD5ml31Qy6rQDkTGs6RHhQnM4l
         mUWfYlVgBPJkrrCLfbj7AuCqPAmdaQ+lgGZGMaF4RAK9JciT3l4oNA/pNxbALGatPI++
         mJMPn864+cvRqJDTc5l9iWxqD/su98ET8kXVMtPpIWQzHLKbQPxcNgyTGlNCR9QpXO9J
         wzAaScV8Qjj7g7guI9XzAkBxRewlLFC5xgVrcDBmsU5Lma2DAVyB8wtTXrSfYpaGEhtW
         WlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=t56wQhmbC0eK6Si58Q9wqbieCBfEkE9Pa30U73bNL2s=;
        b=qyfi0xxGQF6uxRqPIPVG/3Eai+ylZCuSKI0Ea+8TcvRfxfmabpKuJtlku5grvbeuBd
         +cBCKPdhjxzAX82i/vn77pXHNeSx00BuuCfai2/U4HKB5g0Kw4tC6cY7qY5YB4DAiAB6
         dxswabXF4qmVdMPms0nG631L1o1u8FGY39+GjyIwRwoAAQXjS3bRh1PjQj9C0iI7qTF+
         ZU31EBz13ueRMckIy4cwLcEmwxoSLZxGP6LFT1IqfDoZvZU5sbgGPSbRfaTSOIwju1B0
         z+Lehbpecm4FenamCyBAbfp627OQTjYNdNCkMXa5FqiUpnugPXxfwdCU/P3G/c+wLPgr
         A3yA==
X-Gm-Message-State: APjAAAWkdIzMvxxSNC8//7Ll8vRswSX5YyvyAh3gUiv+zumPHJg9agFQ
        Izhd4lT1bXHbkmX1HtxmUL+uTJJH+/w=
X-Google-Smtp-Source: APXvYqwxRLKO+D0At4TubFsnDlNCAevYaJZOFetfxOe9d+M5+sj+wf62oBSmxnWtg7uOj+sXiB3/9g==
X-Received: by 2002:a5d:53ca:: with SMTP id a10mr24763517wrw.131.1562079881552;
        Tue, 02 Jul 2019 08:04:41 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b203sm3494191wmd.41.2019.07.02.08.04.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:04:40 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] KVM: nVMX: list VMX MSRs in KVM_GET_MSR_INDEX_LIST
Date:   Tue,  2 Jul 2019 17:04:36 +0200
Message-Id: <1562079876-20756-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
References: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This allows userspace to know which MSRs are supported by the hypervisor.
Unfortunately userspace must resort to tricks for everything except
MSR_IA32_VMX_VMFUNC (which was just added in the previous patch).
One possibility is to use the feature control MSR, which is tied to nested
VMX as well and is present on all KVM versions that support feature MSRs.

Fixes: 1389309c811 ("KVM: nVMX: expose VMX capabilities for nested hypervisors to userspace", 2018-02-26)
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c     |  1 +
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bbc31f7213ed..5db50c19d1c7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5885,6 +5885,7 @@ static bool svm_has_emulated_msr(int index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
 	default:
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a35459ce7e29..c43635942693 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6223,6 +6223,8 @@ static bool vmx_has_emulated_msr(int index)
 		 * real mode.
 		 */
 		return enable_unrestricted_guest || emulate_invalid_guest_state;
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+		return nested;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		/* This is AMD only.  */
 		return false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8996a3131116..a02d4c244422 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1177,6 +1177,26 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_AMD64_VIRT_SPEC_CTRL,
 	MSR_IA32_POWER_CTL,
 
+	/*
+	 * The following list leaves out MSRs whose values are determined
+	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
+	 * We always support the "true" VMX control MSRs, even if the host
+	 * processor does not, so I am putting these registers here rather
+	 * than in msrs_to_save.
+	 */
+	MSR_IA32_VMX_BASIC,
+	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
+	MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
+	MSR_IA32_VMX_TRUE_EXIT_CTLS,
+	MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+	MSR_IA32_VMX_MISC,
+	MSR_IA32_VMX_CR0_FIXED0,
+	MSR_IA32_VMX_CR4_FIXED0,
+	MSR_IA32_VMX_VMCS_ENUM,
+	MSR_IA32_VMX_PROCBASED_CTLS2,
+	MSR_IA32_VMX_EPT_VPID_CAP,
+	MSR_IA32_VMX_VMFUNC,
+
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
 };
-- 
1.8.3.1

