Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662F85010E2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344722AbiDNNtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344244AbiDNNkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1331C6;
        Thu, 14 Apr 2022 06:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA95A61B51;
        Thu, 14 Apr 2022 13:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E1AC385A5;
        Thu, 14 Apr 2022 13:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943479;
        bh=bpebWxyOLTY7I9S1yS+K5xy1xLfHNLPReNaaPlGkqdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rVsuH9tYkgZbQ24aPDonsh55mMLb1/gjVVrNLdXNy2sdeoXtl2fKOTFng5cbisTa
         0KncHOB9WUbsVeLsNc9l5B+aw/mMC7dnhh3Cn11wQcNmoBEzRG6BSw5w/KcirufgJZ
         /ImstPI8clp0AboXefKwI/qojfGqAhTvROi8HtxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/475] powerpc/perf: Dont use perf_hw_context for trace IMC PMU
Date:   Thu, 14 Apr 2022 15:09:14 +0200
Message-Id: <20220414110859.866707960@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 0198322379c25215b2778482bf1221743a76e2b5 ]

Trace IMC (In-Memory collection counters) in powerpc is useful for
application level profiling.

For trace_imc, presently task context (task_ctx_nr) is set to
perf_hw_context. But perf_hw_context should only be used for CPU PMU.
See commit 26657848502b ("perf/core: Verify we have a single
perf_hw_context PMU").

So for trace_imc, even though it is per thread PMU, it is preferred to
use sw_context in order to be able to do application level monitoring.
Hence change the task_ctx_nr to use perf_sw_context.

Fixes: 012ae244845f ("powerpc/perf: Trace imc PMU functions")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
[mpe: Update subject & incorporate notes into change log, reflow comment]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220202041837.65968-1-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/imc-pmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index eb82dda884e5..d76e800a1f33 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -1441,7 +1441,11 @@ static int trace_imc_event_init(struct perf_event *event)
 	event->hw.idx = -1;
 	target = event->hw.target;
 
-	event->pmu->task_ctx_nr = perf_hw_context;
+	/*
+	 * There can only be a single PMU for perf_hw_context events which is assigned to
+	 * core PMU. Hence use "perf_sw_context" for trace_imc.
+	 */
+	event->pmu->task_ctx_nr = perf_sw_context;
 	event->destroy = reset_global_refc;
 	return 0;
 }
-- 
2.34.1



