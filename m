Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3373A6E61
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfICQZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730465AbfICQZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0A823774;
        Tue,  3 Sep 2019 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527948;
        bh=K9OcstgoEAF/+7QGbfId/spEmXyKk4gKH5hsBnfLJQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb+4hR4sFuf+r6j2E2nYalSeQDGRmNxDui5WmW61JC8N7XEql+adOYHsFvdJfHM5H
         4uAC4K2yoNqU/okbPRr9+AQwzjEDEZPg7Rf+ZJOHJWePEisoUNWxRwrmevcNuScVtK
         hw9R4QHBcCiu8h4b+j818OEIbdf/LF98vdTI+ST4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 015/167] x86/kvm/lapic: preserve gfn_to_hva_cache len on cache reinit
Date:   Tue,  3 Sep 2019 12:22:47 -0400
Message-Id: <20190903162519.7136-15-sashal@kernel.org>
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

[ Upstream commit a7c42bb6da6b1b54b2e7bd567636d72d87b10a79 ]

vcpu->arch.pv_eoi is accessible through both HV_X64_MSR_VP_ASSIST_PAGE and
MSR_KVM_PV_EOI_EN so on migration userspace may try to restore them in any
order. Values match, however, kvm_lapic_enable_pv_eoi() uses different
length: for Hyper-V case it's the whole struct hv_vp_assist_page, for KVM
native case it is 8. In case we restore KVM-native MSR last cache will
be reinitialized with len=8 so trying to access VP assist page beyond
8 bytes with kvm_read_guest_cached() will fail.

Check if we re-initializing cache for the same address and preserve length
in case it was greater.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ccf5a04de94c3..973a244081d34 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2631,14 +2631,22 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 {
 	u64 addr = data & ~KVM_MSR_ENABLED;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.pv_eoi.data;
+	unsigned long new_len;
+
 	if (!IS_ALIGNED(addr, 4))
 		return 1;
 
 	vcpu->arch.pv_eoi.msr_val = data;
 	if (!pv_eoi_enabled(vcpu))
 		return 0;
-	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.pv_eoi.data,
-					 addr, len);
+
+	if (addr == ghc->gpa && len <= ghc->len)
+		new_len = ghc->len;
+	else
+		new_len = len;
+
+	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
 }
 
 void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
-- 
2.20.1

