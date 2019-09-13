Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0EBB210E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389916AbfIMNcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389286AbfIMNNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:13 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25E0208C0;
        Fri, 13 Sep 2019 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380392;
        bh=sGSm+WEEazJKMqmflV8kB6JhIDapV9tpfMGzwrd4KZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfJ5xvM0oRp2Qt0qmjr6yJIiJUpIipcEIE8uFU/l1DxnpDUH8v9GnguxUNVsr9baV
         h5Oii9Gy0W8c4HOKNhc+6wZ6dfoC8mJUOZYwtLM2c0eWrqYeJPMV3PK5kmMO7kBS5+
         H98vuTdNl7nLcGT45ciUq2wz2UQUsi0yj2yz8CSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/190] KVM: x86: hyperv: keep track of mismatched VP indexes
Date:   Fri, 13 Sep 2019 14:04:57 +0100
Message-Id: <20190913130603.107888371@linuxfoundation.org>
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

[ Upstream commit 87ee613d076351950b74383215437f841ebbeb75 ]

In most common cases VP index of a vcpu matches its vcpu index. Userspace
is, however, free to set any mapping it wishes and we need to account for
that when we need to find a vCPU with a particular VP index. To keep search
algorithms optimal in both cases introduce 'num_mismatched_vp_indexes'
counter showing how many vCPUs with mismatching VP index we have. In case
the counter is zero we can assume vp_index == vcpu_idx.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/hyperv.c           | 26 +++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3245b95ad2d97..b6417454a9d79 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -784,6 +784,9 @@ struct kvm_hv {
 	u64 hv_reenlightenment_control;
 	u64 hv_tsc_emulation_control;
 	u64 hv_tsc_emulation_status;
+
+	/* How many vCPUs have VP index != vCPU index */
+	atomic_t num_mismatched_vp_indexes;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 3f2775aac5545..2bb554b90b3c2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1045,11 +1045,31 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
 
 	switch (msr) {
-	case HV_X64_MSR_VP_INDEX:
-		if (!host || (u32)data >= KVM_MAX_VCPUS)
+	case HV_X64_MSR_VP_INDEX: {
+		struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+		int vcpu_idx = kvm_vcpu_get_idx(vcpu);
+		u32 new_vp_index = (u32)data;
+
+		if (!host || new_vp_index >= KVM_MAX_VCPUS)
 			return 1;
-		hv_vcpu->vp_index = (u32)data;
+
+		if (new_vp_index == hv_vcpu->vp_index)
+			return 0;
+
+		/*
+		 * The VP index is initialized to vcpu_index by
+		 * kvm_hv_vcpu_postcreate so they initially match.  Now the
+		 * VP index is changing, adjust num_mismatched_vp_indexes if
+		 * it now matches or no longer matches vcpu_idx.
+		 */
+		if (hv_vcpu->vp_index == vcpu_idx)
+			atomic_inc(&hv->num_mismatched_vp_indexes);
+		else if (new_vp_index == vcpu_idx)
+			atomic_dec(&hv->num_mismatched_vp_indexes);
+
+		hv_vcpu->vp_index = new_vp_index;
 		break;
+	}
 	case HV_X64_MSR_VP_ASSIST_PAGE: {
 		u64 gfn;
 		unsigned long addr;
-- 
2.20.1



