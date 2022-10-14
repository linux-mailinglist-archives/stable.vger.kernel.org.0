Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB4C5FEF06
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJNNwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJNNwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:52:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738381C5E29;
        Fri, 14 Oct 2022 06:52:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADD17B82349;
        Fri, 14 Oct 2022 13:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8A8C433C1;
        Fri, 14 Oct 2022 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755525;
        bh=cLt3pymF4BiahlW8njTC8pTkDVDzPCEtlPz56wf+7iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpnlEAjxZ0KtTruRco+wglfC2AKpaRNHsfbtzer4M+WCujgA5kGe/Wda4xa25I6xI
         /hvL7eWd6Ra+cKpEmGAdWRzJeDix6jXHdBvz4pJL5cuOJO998TAG3lUZNUZAHSmnUl
         QKYhkJXizmGSGL3SPtLjfxAtLt9M6tnUHN+RMTi9zVzIMajAGKxKo5LXYBHXL1a7PH
         e7iQAmF8WIEG15Pr68hpWCiHSrxFSm5F1DsvGlMMt6mEK+LUaRzcHsQbWK0Z+uO+jC
         WpuMSxCeP4ARgWBFYUzUTAx3irdlJXCDH6IjH1g5KNZf8onpCa05AcFBw90x3a4hsI
         l0qRsGivw+qhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Disha Goel <disgoel@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        Julia.Lawall@inria.fr, nick.child@ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.0 08/11] powerpc/perf: Fix branch_filter support for multiple filters
Date:   Fri, 14 Oct 2022 09:51:34 -0400
Message-Id: <20221014135139.2109024-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135139.2109024-1-sashal@kernel.org>
References: <20221014135139.2109024-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit b9c001276d4a756f98cc7dc4672eff5343949203 ]

For PERF_SAMPLE_BRANCH_STACK sample type, different branch_sample_type
ie branch filters are supported. The branch filters are requested via
event attribute "branch_sample_type". Multiple branch filters can be
passed in event attribute. eg:

  $ perf record -b -o- -B --branch-filter any,ind_call true

None of the Power PMUs support having multiple branch filters at
the same time. Branch filters for branch stack sampling is set via MMCRA
IFM bits [32:33]. But currently when requesting for multiple filter
types, the "perf record" command does not report any error.

eg:
  $ perf record -b -o- -B --branch-filter any,save_type true
  $ perf record -b -o- -B --branch-filter any,ind_call true

The "bhrb_filter_map" function in PMU driver code does the validity
check for supported branch filters. But this check is done for single
filter. Hence "perf record" will proceed here without reporting any
error.

Fix power_pmu_event_init() to return EOPNOTSUPP when multiple branch
filters are requested in the event attr.

After the fix:
  $ perf record --branch-filter any,ind_call -- ls
  Error:
  cycles: PMU Hardware doesn't support sampling/overflow-interrupts.
  Try 'perf stat'

Reported-by: Disha Goel <disgoel@linux.vnet.ibm.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Tested-by: Disha Goel<disgoel@linux.vnet.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Reviewed-by: Kajol Jain <kjain@linux.ibm.com>
[mpe: Tweak comment and change log wording]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220921145255.20972-1-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 13919eb96931..03e31ae97741 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2131,6 +2131,23 @@ static int power_pmu_event_init(struct perf_event *event)
 	if (has_branch_stack(event)) {
 		u64 bhrb_filter = -1;
 
+		/*
+		 * Currently no PMU supports having multiple branch filters
+		 * at the same time. Branch filters are set via MMCRA IFM[32:33]
+		 * bits for Power8 and above. Return EOPNOTSUPP when multiple
+		 * branch filters are requested in the event attr.
+		 *
+		 * When opening event via perf_event_open(), branch_sample_type
+		 * gets adjusted in perf_copy_attr(). Kernel will automatically
+		 * adjust the branch_sample_type based on the event modifier
+		 * settings to include PERF_SAMPLE_BRANCH_PLM_ALL. Hence drop
+		 * the check for PERF_SAMPLE_BRANCH_PLM_ALL.
+		 */
+		if (hweight64(event->attr.branch_sample_type & ~PERF_SAMPLE_BRANCH_PLM_ALL) > 1) {
+			local_irq_restore(irq_flags);
+			return -EOPNOTSUPP;
+		}
+
 		if (ppmu->bhrb_filter_map)
 			bhrb_filter = ppmu->bhrb_filter_map(
 					event->attr.branch_sample_type);
-- 
2.35.1

