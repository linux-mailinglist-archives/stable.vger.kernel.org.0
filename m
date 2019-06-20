Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AC84D5BA
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfFTSAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfFTSAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:00:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B688A2168B;
        Thu, 20 Jun 2019 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053624;
        bh=VX0Mch9mxPNtTWpyXYP91PK7meeVE2iNkr4GOupQ+Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBI/29+5kSkLE7eOJna8xYYWw6YJ3T7PDAL3Uq78nBZoLeOYr1GTip96gu7fYTwSE
         /2J5fRwBXtbI5xaEcfEuZuEfhHCQYVx3cPHdUJeXK7zxCG43rYEQqPGl/GydVpATjC
         6d/2C2CgrPA9N1dzffGUn7FqusdINxarWWUmhWkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 54/84] KVM: x86/pmu: do not mask the value that is written to fixed PMUs
Date:   Thu, 20 Jun 2019 19:56:51 +0200
Message-Id: <20190620174347.119128481@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2924b52117b2812e9633d5ea337333299166d373 ]

According to the SDM, for MSR_IA32_PERFCTR0/1 "the lower-order 32 bits of
each MSR may be written with any value, and the high-order 8 bits are
sign-extended according to the value of bit 31", but the fixed counters
in real hardware are limited to the width of the fixed counters ("bits
beyond the width of the fixed-function counter are reserved and must be
written as zeros").  Fix KVM to do the same.

Reported-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu_intel.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu_intel.c b/arch/x86/kvm/pmu_intel.c
index 23a7c7ba377a..8fc07ea23344 100644
--- a/arch/x86/kvm/pmu_intel.c
+++ b/arch/x86/kvm/pmu_intel.c
@@ -235,11 +235,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
-		    (pmc = get_fixed_pmc(pmu, msr))) {
-			if (!msr_info->host_initiated)
-				data = (s64)(s32)data;
-			pmc->counter += data - pmc_read_counter(pmc);
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
+			if (msr_info->host_initiated)
+				pmc->counter = data;
+			else
+				pmc->counter = (s32)data;
+			return 0;
+		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+			pmc->counter = data;
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
-- 
2.20.1



