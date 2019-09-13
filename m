Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF31BB1EEB
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388895AbfIMNOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388885AbfIMNOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:07 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AFCD20CC7;
        Fri, 13 Sep 2019 13:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380447;
        bh=mUBQxfQ32UvOlvNiMiNAHQHwA17r2wn3WVj5j3Oj+fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQmuBU1IUoNUbVyyiWfR3LnFs6lwZT2+L0PQNiHXkSIfHzJPKy1UGIYFFDLuFSyoK
         3C1dSZWPbfmYEoaYKoVpJf1QTlwBQI1kvf7JOnv1ivytQnkKda9Xm3bngVmRb5Qwnv
         4N2ok4TupEgzJR8TMZ/MVfNBHi4TRmq5mY8h9veY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/190] x86/kvm/lapic: preserve gfn_to_hva_cache len on cache reinit
Date:   Fri, 13 Sep 2019 14:04:59 +0100
Message-Id: <20190913130603.285535110@linuxfoundation.org>
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
index 5427fd0aa97e1..262e49301cae6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2636,14 +2636,22 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
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



