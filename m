Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDF747AD32
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhLTOuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56070 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhLTOt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:49:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66D7DB80EEC;
        Mon, 20 Dec 2021 14:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3361C36AE7;
        Mon, 20 Dec 2021 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011764;
        bh=w4NvOpzW6h3pkAvSSQmI3obNZi3DKLv3L7tuerst79g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZ4HFLEEAWEag28EK5g9T23fLjSZVEI5dxCOLj0XxDO3X9JvyCKqnbtj/hKGlbPbJ
         uw+chE5ySVAEBvdQi3kEB0/L3Qx89DE0YkpQ/rGhR45EEnQ6WlC3olv/hgY1814+Zy
         rcx39/tBWKKci4Nei1XjGw9kuI4k9/icLOZ35EF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 66/99] KVM: x86: Drop guest CPUID check for host initiated writes to MSR_IA32_PERF_CAPABILITIES
Date:   Mon, 20 Dec 2021 15:34:39 +0100
Message-Id: <20211220143031.609395263@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 1aa2abb33a419090c7c87d4ae842a6347078ee12 ]

The ability to write to MSR_IA32_PERF_CAPABILITIES from the host should
not depend on guest visible CPUID entries, even if just to allow
creating/restoring guest MSRs and CPUIDs in any sequence.

Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211216165213.338923-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b885063dc393f..4f828cac0273e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3065,7 +3065,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (!msr_info->host_initiated)
 			return 1;
-		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) && kvm_get_msr_feature(&msr_ent))
+		if (kvm_get_msr_feature(&msr_ent))
 			return 1;
 		if (data & ~msr_ent.data)
 			return 1;
-- 
2.34.1



