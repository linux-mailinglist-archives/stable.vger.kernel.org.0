Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DE158DE63
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345636AbiHISOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345391AbiHISMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:12:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C572C11E;
        Tue,  9 Aug 2022 11:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE707B8171E;
        Tue,  9 Aug 2022 18:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDBAC4347C;
        Tue,  9 Aug 2022 18:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068333;
        bh=IBCeAButYsRtNeRmHz0Nr8ebRIHdO/EQ3qn0BXhofwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFx3fZAOYEr8n6dnq3aqpjE1+4dOHbDvqEVD62enCRrNG/9YETa4HfifbTznrUE68
         S5raZac2Blan5but8El5NJALyxqpGec6xhTUCx/H0KsdNIB+UheKGFe/ZsVygXUMbM
         b0Htx/KCzPqRmHWyBnByoVQG9LVhJI/fkiwsgltI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/30] KVM: selftests: Make hyperv_clock selftest more stable
Date:   Tue,  9 Aug 2022 20:00:37 +0200
Message-Id: <20220809175514.746631465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit eae260be3a0111a28fe95923e117a55dddec0384 ]

hyperv_clock doesn't always give a stable test result, especially with
AMD CPUs. The test compares Hyper-V MSR clocksource (acquired either
with rdmsr() from within the guest or KVM_GET_MSRS from the host)
against rdtsc(). To increase the accuracy, increase the measured delay
(done with nop loop) by two orders of magnitude and take the mean rdtsc()
value before and after rdmsr()/KVM_GET_MSRS.

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220601144322.1968742-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index e0b2bb1339b1..3330fb183c68 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -44,7 +44,7 @@ static inline void nop_loop(void)
 {
 	int i;
 
-	for (i = 0; i < 1000000; i++)
+	for (i = 0; i < 100000000; i++)
 		asm volatile("nop");
 }
 
@@ -56,12 +56,14 @@ static inline void check_tsc_msr_rdtsc(void)
 	tsc_freq = rdmsr(HV_X64_MSR_TSC_FREQUENCY);
 	GUEST_ASSERT(tsc_freq > 0);
 
-	/* First, check MSR-based clocksource */
+	/* For increased accuracy, take mean rdtsc() before and afrer rdmsr() */
 	r1 = rdtsc();
 	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	r1 = (r1 + rdtsc()) / 2;
 	nop_loop();
 	r2 = rdtsc();
 	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	r2 = (r2 + rdtsc()) / 2;
 
 	GUEST_ASSERT(r2 > r1 && t2 > t1);
 
@@ -181,12 +183,14 @@ static void host_check_tsc_msr_rdtsc(struct kvm_vm *vm)
 	tsc_freq = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TSC_FREQUENCY);
 	TEST_ASSERT(tsc_freq > 0, "TSC frequency must be nonzero");
 
-	/* First, check MSR-based clocksource */
+	/* For increased accuracy, take mean rdtsc() before and afrer ioctl */
 	r1 = rdtsc();
 	t1 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	r1 = (r1 + rdtsc()) / 2;
 	nop_loop();
 	r2 = rdtsc();
 	t2 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	r2 = (r2 + rdtsc()) / 2;
 
 	TEST_ASSERT(t2 > t1, "Time reference MSR is not monotonic (%ld <= %ld)", t1, t2);
 
-- 
2.35.1



