Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23E47AF7D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbhLTPN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbhLTPMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:12:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C1BC08EB39;
        Mon, 20 Dec 2021 06:56:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DA22611A5;
        Mon, 20 Dec 2021 14:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0067BC36AE7;
        Mon, 20 Dec 2021 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012195;
        bh=aWhdbSqSEwm2NU5GcU/34E+diUcmKcnM3RzhCcvNZWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsQfA7DoUVAmFpTNDd0bedkaNrrvifkxlNJqYWJ+J0L5QbYqPeRqiqBPwQ4yq1Je5
         +Hpb/Af/YvCUoNSVFuJeb3ka9ByU+8ikYmXz13bTyPdLCpafHq82JV+OURup9TTlfJ
         6Lqmu+a8yyyyahpa0mh71+Yw/LK6wmKzN6udPink=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/177] KVM: x86: Drop guest CPUID check for host initiated writes to MSR_IA32_PERF_CAPABILITIES
Date:   Mon, 20 Dec 2021 15:34:25 +0100
Message-Id: <20211220143043.951569937@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
index 3c9e2d236830c..dea578586fa4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3359,7 +3359,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (!msr_info->host_initiated)
 			return 1;
-		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) && kvm_get_msr_feature(&msr_ent))
+		if (kvm_get_msr_feature(&msr_ent))
 			return 1;
 		if (data & ~msr_ent.data)
 			return 1;
-- 
2.34.1



