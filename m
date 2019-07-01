Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CF135392
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfFDX0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfFDXZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:25:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F57D20862;
        Tue,  4 Jun 2019 23:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690747;
        bh=XOQsj7LhOQZBOh6NMkjXt0yudzIxokbXiey5V7Uw9cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9/B6DBDYOFAGL6wMMrlL3fUlnrv6bZ+vt6LbFpzZCNiZWbWMsiP61e+6ZQcltsGw
         kLnyBAGbmnaqSuKmbRh9frv+yApXoxryBhD/Sux7qjdNekXqrTaTfA6W54nSnHE4Pk
         EKE7HklkwMkWjGpzD4hSSquK/bQRDyUEkBI4IGic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/10] KVM: x86/pmu: do not mask the value that is written to fixed PMUs
Date:   Tue,  4 Jun 2019 19:25:30 -0400
Message-Id: <20190604232532.7953-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232532.7953-1-sashal@kernel.org>
References: <20190604232532.7953-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

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

