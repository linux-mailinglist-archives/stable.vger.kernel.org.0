Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F4459A3D1
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354126AbiHSQsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354005AbiHSQqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF34312C359;
        Fri, 19 Aug 2022 09:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0175618B3;
        Fri, 19 Aug 2022 16:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F35C433D6;
        Fri, 19 Aug 2022 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925538;
        bh=UAT7Y9+eghMhtipisJYCxWU40Q9aQYtPksCApGHfw04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1i12ifhyDbQ+tpISgMweUsnT/s4gxxfjM9mMiwt/2KcJ30ocvIKlpZ5uPzXPalno
         BMXwP0VlmUBBzVgrQW99yoNkM5dJhaY7XzvzwC+zPs9iBvN6gSOlA751t1GPKscqeU
         L0HUJuDQ3GG4HHkD9G4xKINPQ7gapwhv7Iiz9cSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/545] KVM: x86/pmu: Use binary search to check filtered events
Date:   Fri, 19 Aug 2022 17:44:35 +0200
Message-Id: <20220819153852.083624234@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 7ff775aca48adc854436b92c060e5eebfffb6a4a ]

The PMU event filter may contain up to 300 events. Replace the linear
search in reprogram_gp_counter() with a binary search.

Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20220115052431.447232-2-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2f83b5d948b3..350e7cdaad02 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -13,6 +13,8 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/bsearch.h>
+#include <linux/sort.h>
 #include <asm/perf_event.h>
 #include "x86.h"
 #include "cpuid.h"
@@ -168,13 +170,17 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
+static int cmp_u64(const void *a, const void *b)
+{
+	return *(__u64 *)a - *(__u64 *)b;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
-	int i;
 	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
@@ -189,16 +195,13 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (filter) {
-		for (i = 0; i < filter->nevents; i++)
-			if (filter->events[i] ==
-			    (eventsel & AMD64_RAW_EVENT_MASK_NB))
-				break;
-		if (filter->action == KVM_PMU_EVENT_ALLOW &&
-		    i == filter->nevents)
-			allow_event = false;
-		if (filter->action == KVM_PMU_EVENT_DENY &&
-		    i < filter->nevents)
-			allow_event = false;
+		__u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
+
+		if (bsearch(&key, filter->events, filter->nevents,
+			    sizeof(__u64), cmp_u64))
+			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
+		else
+			allow_event = filter->action == KVM_PMU_EVENT_DENY;
 	}
 	if (!allow_event)
 		return;
@@ -507,6 +510,11 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	/* Ensure nevents can't be changed between the user copies. */
 	*filter = tmp;
 
+	/*
+	 * Sort the in-kernel list so that we can search it with bsearch.
+	 */
+	sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
 				     mutex_is_locked(&kvm->lock));
-- 
2.35.1



