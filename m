Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92B25218EA
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243472AbiEJNkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245190AbiEJNih (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B1CD54;
        Tue, 10 May 2022 06:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80F3FCE1EE2;
        Tue, 10 May 2022 13:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862FFC385C2;
        Tue, 10 May 2022 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189310;
        bh=v7Yqa6zur4G9nPPs/iLeF0a/0w7hCDhIoRVk6yIDzJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSa3soPkG0/lRM7DQrq9dzjEfQlQj91xHoRZBdwZy0RDTK90go3JcGxnpG8bztieL
         C+3uggVBGvOsmv2SJn+b+wijIZXUdXqsEp4c6ZJiymyyJIeEgfHxb81P30d/xpoQPM
         Sd4vJcBZURfunTJAv2sZlHjNflWDpRCZFEJTZFB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Huey <me@kylehuey.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 010/135] KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id
Date:   Tue, 10 May 2022 15:06:32 +0200
Message-Id: <20220510130740.692228214@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream.

Zen renumbered some of the performance counters that correspond to the
well known events in perf_hw_id. This code in KVM was never updated for
that, so guest that attempt to use counters on Zen that correspond to the
pre-Zen perf_hw_id values will silently receive the wrong values.

This has been observed in the wild with rr[0] when running in Zen 3
guests. rr uses the retired conditional branch counter 00d1 which is
incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.

[0] https://rr-project.org/

Signed-off-by: Kyle Huey <me@kylehuey.com>
Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
Cc: stable@vger.kernel.org
[Check guest family, not host. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/pmu.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping
 	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
 };
 
+/* duplicated from amd_f17h_perfmon_event_map. */
+static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
+	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
+	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
+	[2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
+	[3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
+	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
+	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
+	[6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
+	[7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
+};
+
+/* amd_pmc_perf_hw_id depends on these being the same size */
+static_assert(ARRAY_SIZE(amd_event_mapping) ==
+	     ARRAY_SIZE(amd_f17h_event_mapping));
+
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -136,19 +152,25 @@ static inline struct kvm_pmc *get_gp_pmc
 
 static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	struct kvm_event_hw_type_mapping *event_mapping;
 	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	if (guest_cpuid_family(pmc->vcpu) >= 0x17)
+		event_mapping = amd_f17h_event_mapping;
+	else
+		event_mapping = amd_event_mapping;
+
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
+		if (event_mapping[i].eventsel == event_select
+		    && event_mapping[i].unit_mask == unit_mask)
 			break;
 
 	if (i == ARRAY_SIZE(amd_event_mapping))
 		return PERF_COUNT_HW_MAX;
 
-	return amd_event_mapping[i].event_type;
+	return event_mapping[i].event_type;
 }
 
 /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */


