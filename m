Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEB561FA60
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiKGQsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiKGQst (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:48:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95258D8D
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30A53611B3
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226F7C433B5;
        Mon,  7 Nov 2022 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839727;
        bh=x+lk28t+1uZ7TH9QGXjNyUaWX0Qoq6w+oA3KKo7+pe8=;
        h=Subject:To:Cc:From:Date:From;
        b=oRNeWRCe8v06yZgsMTkxf4znEbJQKcbf4GRtSMW9MAY3E6D8NvuKhCp2jYVoIwlH+
         WMgfPWuC1kKrjYSxulcAbN3elnZFxlAvUWbs8d3vanEzC0pIFs9RuQk5hBf/uhUrpX
         bOtFbvTHo1NAGQWd6f9nXXuG2ZMYcf3qECS2Tz48=
Subject: FAILED: patch "[PATCH] KVM: VMX: Advertise PMU LBRs if and only if perf supports" failed to apply to 5.15-stable tree
To:     seanjc@google.com, like.xu.linux@gmail.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:48:44 +0100
Message-ID: <1667839724187111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

145dfad998ea ("KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs")
cf8e55fe50df ("KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64")
4732f2444acd ("KVM: x86: Making the module parameter of vPMU more common")
b1d66dad65dc ("KVM: x86/svm: Add module param to control PMU virtualization")
f800650a4ed2 ("KVM: x86: SVM: add module param to control TSC scaling")
4c84926e229e ("KVM: x86: SVM: add module param to control LBR virtualization")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 145dfad998eac74abc59219d936e905766ba2d98 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 6 Oct 2022 00:03:08 +0000
Subject: [PATCH] KVM: VMX: Advertise PMU LBRs if and only if perf supports
 LBRs

Advertise LBR support to userspace via MSR_IA32_PERF_CAPABILITIES if and
only if perf fully supports LBRs.  Perf may disable LBRs (by zeroing the
number of LBRs) even on platforms the allegedly support LBRs, e.g. if
probing any LBR MSRs during setup fails.

Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
Reported-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221006000314.73240-3-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 87c4e46daf37..3bd7a8970618 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -400,6 +400,7 @@ static inline bool vmx_pebs_supported(void)
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = PMU_CAP_FW_WRITES;
+	struct x86_pmu_lbr lbr;
 	u64 host_perf_cap = 0;
 
 	if (!enable_pmu)
@@ -408,7 +409,8 @@ static inline u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	if (x86_perf_get_lbr(&lbr) >= 0 && lbr.nr)
+		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
 
 	if (vmx_pebs_supported()) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;

