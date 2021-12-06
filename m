Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC4F469E1B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349785AbhLFPgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35518 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387719AbhLFPbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:31:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A539B8111E;
        Mon,  6 Dec 2021 15:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1834C34901;
        Mon,  6 Dec 2021 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804498;
        bh=D9BneoZ5pKUabNYLDWhUTzNUJl51i27LH35N2pk8NFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKmVARFqpo/Bz9V1Q0QcPKfHSHnpRLJFls0nHe021Zzpi/lJ5NJk7U2IHDqO1geAn
         5nh6+mhGfkh92eue4ARPpJBEamaCmTSUucRHIdk+GIEWr+mVFlIimtZfSUDnTWyaQz
         d6Ira7ViG/AvN1+8sQ6KI9Me19zfT4rbT9AqRlfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/207] KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register
Date:   Mon,  6 Dec 2021 15:57:01 +0100
Message-Id: <20211206145616.057749160@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

[ Upstream commit cb1d220da0faa5ca0deb93449aff953f0c2cce6d ]

If we run the following perf command in an AMD Milan guest:

  perf stat \
  -e cpu/event=0x1d0/ \
  -e cpu/event=0x1c7/ \
  -e cpu/umask=0x1f,event=0x18e/ \
  -e cpu/umask=0x7,event=0x18e/ \
  -e cpu/umask=0x18,event=0x18e/ \
  ./workload

dmesg will report a #GP warning from an unchecked MSR access
error on MSR_F15H_PERF_CTLx.

This is because according to APM (Revision: 4.03) Figure 13-7,
the bits [35:32] of AMD PerfEvtSeln register is a part of the
event select encoding, which extends the EVENT_SELECT field
from 8 bits to 12 bits.

Opportunistically update pmu->reserved_bits for reserved bit 19.

Reported-by: Jim Mattson <jmattson@google.com>
Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Like Xu <likexu@tencent.com>
Message-Id: <20211118130320.95997-1-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index fdf587f19c5fb..e152241d1d709 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -282,7 +282,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
-	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->reserved_bits = 0xfffffff000280000ull;
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-- 
2.33.0



