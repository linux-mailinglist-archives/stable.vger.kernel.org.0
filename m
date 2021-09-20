Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1A4412194
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358431AbhITSGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357351AbhITSEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:04:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A838B6323A;
        Mon, 20 Sep 2021 17:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158226;
        bh=Kyf+3fxqhW55SBXTs2tFrO+jADQANsShD1EpHkl0fhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/9+X1i0oaeL2F7U5FnXeTWJned0zQLiYTu69TvKps7BwTsR5fGZB/Hi+rybYuNrx
         ARlmV5oeRQ2STvHp+jpBHrl6DqGbimK//vEHfXktNxSm3gujxEsimGheLfBma+crw9
         7P50K/XqKIYpMZciLjlc8m25pkVF3YW1BH7l8hF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/260] KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live
Date:   Mon, 20 Sep 2021 18:41:17 +0200
Message-Id: <20210920163933.130708758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 1782663897945a5cf28e564ba5eed730098e9aa4 ]

After the L1 saves its PMU SPRs but before loading the L2's PMU SPRs,
switch the pmcregs_in_use field in the L1 lppaca to the value advertised
by the L2 in its VPA. On the way out of the L2, set it back after saving
the L2 PMU registers (if they were in-use).

This transfers the PMU liveness indication between the L1 and L2 at the
points where the registers are not live.

This fixes the nested HV bug for which a workaround was added to the L0
HV by commit 63279eeb7f93a ("KVM: PPC: Book3S HV: Always save guest pmu
for guest capable of nesting"), which explains the problem in detail.
That workaround is no longer required for guests that include this bug
fix.

Fixes: 360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Link: https://lore.kernel.org/r/20210811160134.904987-10-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/pmc.h |  7 +++++++
 arch/powerpc/kvm/book3s_hv.c   | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/powerpc/include/asm/pmc.h b/arch/powerpc/include/asm/pmc.h
index c6bbe9778d3c..3c09109e708e 100644
--- a/arch/powerpc/include/asm/pmc.h
+++ b/arch/powerpc/include/asm/pmc.h
@@ -34,6 +34,13 @@ static inline void ppc_set_pmu_inuse(int inuse)
 #endif
 }
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+static inline int ppc_get_pmu_inuse(void)
+{
+	return get_paca()->pmcregs_in_use;
+}
+#endif
+
 extern void power4_enable_pmcs(void);
 
 #else /* CONFIG_PPC64 */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index bba358f13471..6c99ccc3bfcb 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -58,6 +58,7 @@
 #include <asm/kvm_book3s.h>
 #include <asm/mmu_context.h>
 #include <asm/lppaca.h>
+#include <asm/pmc.h>
 #include <asm/processor.h>
 #include <asm/cputhreads.h>
 #include <asm/page.h>
@@ -3559,6 +3560,18 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		if (vcpu->arch.vpa.pinned_addr) {
+			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
+			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
+		} else {
+			get_lppaca()->pmcregs_in_use = 1;
+		}
+		barrier();
+	}
+#endif
 	kvmhv_load_guest_pmu(vcpu);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
@@ -3693,6 +3706,13 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
+		barrier();
+	}
+#endif
 
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
-- 
2.30.2



