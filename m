Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9908FB2004
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbfIMNNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389388AbfIMNNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:47 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646C0206BB;
        Fri, 13 Sep 2019 13:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380426;
        bh=UUoHt1rrBOdqn11d3un8b9stphkaG4XRwE4Cyn9LGMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGgIWHknBJPwQIZ9Rbc7UQiKALcKIoUsBmV1lfk6VaXJK8suJEy07C294CVREgce1
         c+jC3l/rAD1UWziNgPC3Q5VNfasqMo1WzNu+eniNOQ73HhGXUb0kWipU0Jvy2DVooc
         yJJHuCbEC+NikrYn14Ko0/iDmvA22bmWkUBBSyy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ladi Prosek <lprosek@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/190] KVM: hyperv: define VP assist page helpers
Date:   Fri, 13 Sep 2019 14:04:58 +0100
Message-Id: <20190913130603.202370862@linuxfoundation.org>
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

[ Upstream commit 72bbf9358c3676bd89dc4bd8fb0b1f2a11c288fc ]

The state related to the VP assist page is still managed by the LAPIC
code in the pv_eoi field.

Signed-off-by: Ladi Prosek <lprosek@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/hyperv.c | 23 +++++++++++++++++++++--
 arch/x86/kvm/hyperv.h |  4 ++++
 arch/x86/kvm/lapic.c  |  4 ++--
 arch/x86/kvm/lapic.h  |  2 +-
 arch/x86/kvm/x86.c    |  2 +-
 5 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2bb554b90b3c2..5842c5f587fe9 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -691,6 +691,24 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 		stimer_cleanup(&hv_vcpu->stimer[i]);
 }
 
+bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
+{
+	if (!(vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
+		return false;
+	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
+}
+EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
+
+bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
+			    struct hv_vp_assist_page *assist_page)
+{
+	if (!kvm_hv_assist_page_enabled(vcpu))
+		return false;
+	return !kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
+				      assist_page, sizeof(*assist_page));
+}
+EXPORT_SYMBOL_GPL(kvm_hv_get_assist_page);
+
 static void stimer_prepare_msg(struct kvm_vcpu_hv_stimer *stimer)
 {
 	struct hv_message *msg = &stimer->msg;
@@ -1076,7 +1094,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 
 		if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
 			hv_vcpu->hv_vapic = data;
-			if (kvm_lapic_enable_pv_eoi(vcpu, 0))
+			if (kvm_lapic_enable_pv_eoi(vcpu, 0, 0))
 				return 1;
 			break;
 		}
@@ -1089,7 +1107,8 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		hv_vcpu->hv_vapic = data;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
 		if (kvm_lapic_enable_pv_eoi(vcpu,
-					    gfn_to_gpa(gfn) | KVM_MSR_ENABLED))
+					    gfn_to_gpa(gfn) | KVM_MSR_ENABLED,
+					    sizeof(struct hv_vp_assist_page)))
 			return 1;
 		break;
 	}
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index d6aa969e20f19..0e66c12ed2c3d 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -62,6 +62,10 @@ void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
 
+bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
+bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
+			    struct hv_vp_assist_page *assist_page);
+
 static inline struct kvm_vcpu_hv_stimer *vcpu_to_stimer(struct kvm_vcpu *vcpu,
 							int timer_index)
 {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5f5bc59768042..5427fd0aa97e1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2633,7 +2633,7 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 	return 0;
 }
 
-int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
+int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 {
 	u64 addr = data & ~KVM_MSR_ENABLED;
 	if (!IS_ALIGNED(addr, 4))
@@ -2643,7 +2643,7 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
 	if (!pv_eoi_enabled(vcpu))
 		return 0;
 	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.pv_eoi.data,
-					 addr, sizeof(u8));
+					 addr, len);
 }
 
 void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index ed0ed39abd369..ff6ef9c3d760c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -120,7 +120,7 @@ static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
 	return vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
 }
 
-int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data);
+int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_init(void);
 void kvm_lapic_exit(void);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c27ce60590905..86e35df8fbce3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2494,7 +2494,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		break;
 	case MSR_KVM_PV_EOI_EN:
-		if (kvm_lapic_enable_pv_eoi(vcpu, data))
+		if (kvm_lapic_enable_pv_eoi(vcpu, data, sizeof(u8)))
 			return 1;
 		break;
 
-- 
2.20.1



