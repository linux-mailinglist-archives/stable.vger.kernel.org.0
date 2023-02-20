Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCB569CEB9
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbjBTOBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjBTOBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D603A1E9E5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4902AB80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF796C433EF;
        Mon, 20 Feb 2023 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901684;
        bh=IfcDuylq71Attqv3xBHz2BA5wAfyJyyxl64jYW2wtYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EizncGLXsQTbIWkpyCwVFX/TmJlP38+fGVnkFq6KSbzbF8Uz2onrqarspau8wZfLW
         TRygsLuERMy311Kbw/nPAOPgt4semX/PieUU0ChGFRSkIfQnLhHP5DiFjiHP+yTDOo
         YRyea2HogboEoI7ibZ3mvJm/Lr6lbFurSwP8YBzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianfeng Gao <jianfeng.gao@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 112/118] KVM: x86/pmu: Disable vPMU support on hybrid CPUs (host PMUs)
Date:   Mon, 20 Feb 2023 14:37:08 +0100
Message-Id: <20230220133604.879910136@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 4d7404e5ee0066e9a9e8268675de8a273b568b08 upstream.

Disable KVM support for virtualizing PMUs on hosts with hybrid PMUs until
KVM gains a sane way to enumeration the hybrid vPMU to userspace and/or
gains a mechanism to let userspace opt-in to the dangers of exposing a
hybrid vPMU to KVM guests.  Virtualizing a hybrid PMU, or at least part of
a hybrid PMU, is possible, but it requires careful, deliberate
configuration from userspace.

E.g. to expose full functionality, vCPUs need to be pinned to pCPUs to
prevent migrating a vCPU between a big core and a little core, userspace
must enumerate a reasonable topology to the guest, and guest CPUID must be
curated per vCPU to enumerate accurate vPMU capabilities.

The last point is especially problematic, as KVM doesn't control which
pCPU it runs on when enumerating KVM's vPMU capabilities to userspace,
i.e. userspace can't rely on KVM_GET_SUPPORTED_CPUID in it's current form.

Alternatively, userspace could enable vPMU support by enumerating the
set of features that are common and coherent across all cores, e.g. by
filtering PMU events and restricting guest capabilities.  But again, that
requires userspace to take action far beyond reflecting KVM's supported
feature set into the guest.

For now, simply disable vPMU support on hybrid CPUs to avoid inducing
seemingly random #GPs in guests, and punt support for hybrid CPUs to a
future enabling effort.

Reported-by: Jianfeng Gao <jianfeng.gao@intel.com>
Cc: stable@vger.kernel.org
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Link: https://lore.kernel.org/all/20220818181530.2355034-1-kan.liang@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230208204230.1360502-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/pmu.h |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -164,15 +164,27 @@ static inline void kvm_init_pmu_capabili
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 
-	perf_get_x86_pmu_capability(&kvm_pmu_cap);
-
-	 /*
-	  * For Intel, only support guest architectural pmu
-	  * on a host with architectural pmu.
-	  */
-	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
+	/*
+	 * Hybrid PMUs don't play nice with virtualization without careful
+	 * configuration by userspace, and KVM's APIs for reporting supported
+	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
+	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
 		enable_pmu = false;
 
+	if (enable_pmu) {
+		perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+		/*
+		 * For Intel, only support guest architectural pmu
+		 * on a host with architectural pmu.
+		 */
+		if ((is_intel && !kvm_pmu_cap.version) ||
+		    !kvm_pmu_cap.num_counters_gp)
+			enable_pmu = false;
+	}
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;


