Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CFAA706F
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbfICQZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729791AbfICQZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C44C2343A;
        Tue,  3 Sep 2019 16:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527944;
        bh=CC0jLTX4WDNq6QPJuI18WeL6EaFRS3B/x7g/1f+OPqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glqzn8vVQSqMROJNOcBuCiRlfPSNXnrEG+6n6A+hVwT+iC3C0rCDlmToSk8+goWHq
         r+axZ4hmuO2dASkWiU9/J59kdtKzRLYkc9jVF6L8uWhqFHD4Ehxz0QsXMVcVoCeORj
         dSWnqy6otg9qiFCyUR4QLO0qoo0MvsRjPEFg+kz4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 012/167] KVM: x86: hyperv: consistently use 'hv_vcpu' for 'struct kvm_vcpu_hv' variables
Date:   Tue,  3 Sep 2019 12:22:44 -0400
Message-Id: <20190903162519.7136-12-sashal@kernel.org>
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 1779a39f786397760ae7a7cc03cf37697d8ae58d ]

Rename 'hv' to 'hv_vcpu' in kvm_hv_set_msr/kvm_hv_get_msr(); 'hv' is
'reserved' for 'struct kvm_hv' variables across the file.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/hyperv.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 73fa074b9089a..3f2775aac5545 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1042,20 +1042,20 @@ static u64 current_task_runtime_100ns(void)
 
 static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
-	struct kvm_vcpu_hv *hv = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX:
 		if (!host || (u32)data >= KVM_MAX_VCPUS)
 			return 1;
-		hv->vp_index = (u32)data;
+		hv_vcpu->vp_index = (u32)data;
 		break;
 	case HV_X64_MSR_VP_ASSIST_PAGE: {
 		u64 gfn;
 		unsigned long addr;
 
 		if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
-			hv->hv_vapic = data;
+			hv_vcpu->hv_vapic = data;
 			if (kvm_lapic_enable_pv_eoi(vcpu, 0))
 				return 1;
 			break;
@@ -1066,7 +1066,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 		if (__clear_user((void __user *)addr, PAGE_SIZE))
 			return 1;
-		hv->hv_vapic = data;
+		hv_vcpu->hv_vapic = data;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
 		if (kvm_lapic_enable_pv_eoi(vcpu,
 					    gfn_to_gpa(gfn) | KVM_MSR_ENABLED))
@@ -1082,7 +1082,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	case HV_X64_MSR_VP_RUNTIME:
 		if (!host)
 			return 1;
-		hv->runtime_offset = data - current_task_runtime_100ns();
+		hv_vcpu->runtime_offset = data - current_task_runtime_100ns();
 		break;
 	case HV_X64_MSR_SCONTROL:
 	case HV_X64_MSR_SVERSION:
@@ -1174,11 +1174,11 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 			  bool host)
 {
 	u64 data = 0;
-	struct kvm_vcpu_hv *hv = &vcpu->arch.hyperv;
+	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX:
-		data = hv->vp_index;
+		data = hv_vcpu->vp_index;
 		break;
 	case HV_X64_MSR_EOI:
 		return kvm_hv_vapic_msr_read(vcpu, APIC_EOI, pdata);
@@ -1187,10 +1187,10 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_TPR:
 		return kvm_hv_vapic_msr_read(vcpu, APIC_TASKPRI, pdata);
 	case HV_X64_MSR_VP_ASSIST_PAGE:
-		data = hv->hv_vapic;
+		data = hv_vcpu->hv_vapic;
 		break;
 	case HV_X64_MSR_VP_RUNTIME:
-		data = current_task_runtime_100ns() + hv->runtime_offset;
+		data = current_task_runtime_100ns() + hv_vcpu->runtime_offset;
 		break;
 	case HV_X64_MSR_SCONTROL:
 	case HV_X64_MSR_SVERSION:
-- 
2.20.1

