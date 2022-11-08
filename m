Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E1A6215CC
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbiKHOPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiKHOPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB66960EA6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 983EDB81B04
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70544C433C1;
        Tue,  8 Nov 2022 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916925;
        bh=HyHJpsLbe9/L+0dvqI3uUP1RJWEykS0auhl6jYEBSw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsYf+ih2AevpuNlWzanEe0frU64VBYd3BDCiO/IYEB6R4BkLU7mY/gTsdD6/EOKJh
         wgxayBuKMj+NasaKCWE5BeJOQWNMWDR4tpkUJe9Dq8wxcGrpB1CNurEbm+DYhihXv4
         749dvlHKOSU/CowCkrpKeL+KReQ1kbqgOQRhgggg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 175/197] KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs
Date:   Tue,  8 Nov 2022 14:40:13 +0100
Message-Id: <20221108133402.880211286@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

commit 145dfad998eac74abc59219d936e905766ba2d98 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/capabilities.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -404,6 +404,7 @@ static inline bool vmx_pebs_supported(vo
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = PMU_CAP_FW_WRITES;
+	struct x86_pmu_lbr lbr;
 	u64 host_perf_cap = 0;
 
 	if (!enable_pmu)
@@ -412,7 +413,8 @@ static inline u64 vmx_get_perf_capabilit
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	if (x86_perf_get_lbr(&lbr) >= 0 && lbr.nr)
+		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
 
 	if (vmx_pebs_supported()) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;


