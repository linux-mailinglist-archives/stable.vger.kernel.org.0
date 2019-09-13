Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572A1B1EF5
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389526AbfIMNOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389522AbfIMNO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:29 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43EF208C0;
        Fri, 13 Sep 2019 13:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380468;
        bh=xyMEzy5t3eJ3y9Ziqx6b8ifGTiMWJD8qz138okdkK+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxN2ebzagbtq//R02PDfDft8p3bdmjraDWQgKDDhO4iAUY3I+Tats/Uj9g2kla5gl
         D0+zG7wsJ5exDdDPmBbPUl0NalAmG+pcQb4biLHIPTPLCjnxYyY2WMYXsqgU5PBIlE
         bLjDhHpsCAwcjjLZ9qT31sH1GWLiK3yEkFYIi/bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/190] KVM: x86: hyperv: consistently use hv_vcpu for struct kvm_vcpu_hv variables
Date:   Fri, 13 Sep 2019 14:04:56 +0100
Message-Id: <20190913130603.023458406@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



