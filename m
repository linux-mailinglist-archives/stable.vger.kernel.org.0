Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636134BE87A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbiBUJii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:38:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350672AbiBUJel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:34:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C6D2AC73;
        Mon, 21 Feb 2022 01:14:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E02660E9F;
        Mon, 21 Feb 2022 09:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA36C340F6;
        Mon, 21 Feb 2022 09:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434831;
        bh=ZpfoQcnTmVqebXfBI40itLAdUgbRn0FhwDiHLlfqpqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uswXPEhonJQ3tk+tXRvX9I06jBqehnlUtj/KONkaC9iqyI4EWgiZ9+HICqSbBrFPT
         RgxOvJLOhqquVFBZ8sw9FJ6C1E8wfGVOcfofELNUdUrnxPMJ6CZ1IPO611RBiNYueq
         MdngXMaCIfx0yvj1abWgN1PSrWQU1wrZ1MomJ9p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/196] KVM: x86/pmu: Dont truncate the PerfEvtSeln MSR when creating a perf event
Date:   Mon, 21 Feb 2022 09:49:37 +0100
Message-Id: <20220221084935.775021299@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit b8bfee85f1307426e0242d654f3a14c06ef639c5 ]

AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
a PerfEvtSeln MSR. Don't drop the high nybble when setting up the
config field of a perf_event_attr structure for a call to
perf_event_create_kernel_counter().

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220203014813.2130559-1-jmattson@google.com>
Reviewed-by: David Dunn <daviddunn@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eec614de9af30..bfef0c658730e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -95,7 +95,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 }
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
-				  unsigned config, bool exclude_user,
+				  u64 config, bool exclude_user,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
@@ -173,7 +173,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
-	unsigned config, type = PERF_TYPE_RAW;
+	u64 config;
+	u32 type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
-- 
2.34.1



