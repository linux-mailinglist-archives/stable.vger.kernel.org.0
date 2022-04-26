Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C850F8F4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbiDZJLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346270AbiDZJH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33382175F9C;
        Tue, 26 Apr 2022 01:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C488160C42;
        Tue, 26 Apr 2022 08:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1ECC385A0;
        Tue, 26 Apr 2022 08:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962909;
        bh=A56fKUb9QhTkuY0ANZnth/JLehVBCPkqJ2mcbTQY0F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrCououv+o3ZOuPDhwyfBWVqnnkooVj/ZEUKFogRHUdDSP4iZUmal0qMljkBILk7u
         cSO/Kxbr7CWUk9P+mGMJ6cOLdS/BI1vACYNoSljgmIezr1IHu6VC1I7H9yI2ISp0Vu
         VnhQOyY3Yb+IFQjgnWjQOGOZ43i6ib/LZoyp9W/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Cao <caodongli@kingsoft.com>,
        Like Xu <likexu@tencent.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 128/146] KVM: x86/pmu: Update AMD PMC sample period to fix guest NMI-watchdog
Date:   Tue, 26 Apr 2022 10:22:03 +0200
Message-Id: <20220426081753.660138313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

commit 75189d1de1b377e580ebd2d2c55914631eac9c64 upstream.

NMI-watchdog is one of the favorite features of kernel developers,
but it does not work in AMD guest even with vPMU enabled and worse,
the system misrepresents this capability via /proc.

This is a PMC emulation error. KVM does not pass the latest valid
value to perf_event in time when guest NMI-watchdog is running, thus
the perf_event corresponding to the watchdog counter will enter the
old state at some point after the first guest NMI injection, forcing
the hardware register PMC0 to be constantly written to 0x800000000001.

Meanwhile, the running counter should accurately reflect its new value
based on the latest coordinated pmc->counter (from vPMC's point of view)
rather than the value written directly by the guest.

Fixes: 168d918f2643 ("KVM: x86: Adjust counter sample period after a wrmsr")
Reported-by: Dongli Cao <caodongli@kingsoft.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
Tested-by: Yanan Wang <wangyanan55@huawei.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220409015226.38619-1-likexu@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/pmu.h           |    9 +++++++++
 arch/x86/kvm/svm/pmu.c       |    1 +
 arch/x86/kvm/vmx/pmu_intel.c |    8 ++------
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,6 +140,15 @@ static inline u64 get_sample_period(stru
 	return sample_period;
 }
 
+static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
+{
+	if (!pmc->perf_event || pmc->is_paused)
+		return;
+
+	perf_event_period(pmc->perf_event,
+			  get_sample_period(pmc, pmc->counter));
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -257,6 +257,7 @@ static int amd_pmu_set_msr(struct kvm_vc
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		pmc->counter += data - pmc_read_counter(pmc);
+		pmc_update_sample_period(pmc);
 		return 0;
 	}
 	/* MSR_EVNTSELn */
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -431,15 +431,11 @@ static int intel_pmu_set_msr(struct kvm_
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)


