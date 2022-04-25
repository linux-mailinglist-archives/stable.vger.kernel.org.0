Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4750DEA3
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 13:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbiDYLTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 07:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241467AbiDYLTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 07:19:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D147B3C70C
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75E8C611DE
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 11:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCEFC385AB;
        Mon, 25 Apr 2022 11:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650885364;
        bh=AfxYAaqgOBNdHLw2K4oQKFbocDE1K1SWVKBp88UbZ4Y=;
        h=Subject:To:Cc:From:Date:From;
        b=A0G5d9RiwiZXtt5FdT1lSrGHIdq0n8hI/db+VemGligHooM+lCV7JSD9hKVB6rt7Z
         F+FNZ5gCzooBF3s1abpBzT10hMXCdzy/gMb/kEb/iStxQSySi9PM6zln8ei8omoYpo
         +fSd+V7LgAstxYTTUPpy3jGhT2XCBf/8z7D/RqGE=
Subject: FAILED: patch "[PATCH] KVM: x86/pmu: Update AMD PMC sample period to fix guest" failed to apply to 5.10-stable tree
To:     likexu@tencent.com, caodongli@kingsoft.com, jmattson@google.com,
        pbonzini@redhat.com, wangyanan55@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 13:16:01 +0200
Message-ID: <1650885361123236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 75189d1de1b377e580ebd2d2c55914631eac9c64 Mon Sep 17 00:00:00 2001
From: Like Xu <likexu@tencent.com>
Date: Sat, 9 Apr 2022 09:52:26 +0800
Subject: [PATCH] KVM: x86/pmu: Update AMD PMC sample period to fix guest
 NMI-watchdog

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

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 9e66fba1d6a3..22992b049d38 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -138,6 +138,15 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
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
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 24eb935b6f85..b14860863c39 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -257,6 +257,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		pmc->counter += data - pmc_read_counter(pmc);
+		pmc_update_sample_period(pmc);
 		return 0;
 	}
 	/* MSR_EVNTSELn */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bc3f8512bb64..b82b6709d7a8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -431,15 +431,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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

