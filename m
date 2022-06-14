Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A4854A66A
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355324AbiFNCcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355586AbiFNC3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:29:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0123C42A2F;
        Mon, 13 Jun 2022 19:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF1EB816A4;
        Tue, 14 Jun 2022 02:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCC8C341C0;
        Tue, 14 Jun 2022 02:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172699;
        bh=IBCeAButYsRtNeRmHz0Nr8ebRIHdO/EQ3qn0BXhofwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXX/1UkjSu3zyVnCOlcNYkxZyAvNDDfaKqU+aAVFqMbH+MnNDIuNUquqOQNsqvxt8
         UE9bvlvGAt/nSPFXkV5wnh/X+esg9J4u2Z/eL1tI6XGNPwoglS0q4bbK7gy+j/Y+e/
         PnOwPk9GXvoV5quPypGBTcTJBqjzlCClE+wXOAqcnjHo+iNlDx7v6FpV3RmTrrjt2R
         H+qGjTYJgo4Yntyj1MrQsvD/hbtNYJNhN3JJDBOnJam9LYHLX4fjM9cskJFn/afj4C
         y2fOJFgHn7Q4f7cDftdpMm8rnmkS00vaP6H4TWu73URfEOcN1iaya1eYIVx2Lrg37H
         V/YSKNlzW8wSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        seanjc@google.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 3/4] KVM: selftests: Make hyperv_clock selftest more stable
Date:   Mon, 13 Jun 2022 22:11:29 -0400
Message-Id: <20220614021130.1101425-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021130.1101425-1-sashal@kernel.org>
References: <20220614021130.1101425-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

