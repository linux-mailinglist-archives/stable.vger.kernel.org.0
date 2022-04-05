Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1248F4F2DFC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbiDEJau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245161AbiDEIyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171A9BE4;
        Tue,  5 Apr 2022 01:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CFA61504;
        Tue,  5 Apr 2022 08:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5064C385A1;
        Tue,  5 Apr 2022 08:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148701;
        bh=ksj7NaMP7Eh/EV7FFmcfWjOot3c2gY7+vG8k34T7j4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkcbWWedk4Hndh8cy5qlrCGeG+mb5uQbBL6WUHOyH7bgtU2+6SCHbyaCTrtcnkryE
         PjZpAZJ+GenAOpfh9aKCfIihXRc6+Nzc2tJGo/foEuBrQ0Wl1xhfdqL/h/b+rgPUCv
         4ciDBFhVtB5ZPgiZThTZo6BGLhV9L/7hKUtcC/OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0450/1017] powerpc/perf: Dont use perf_hw_context for trace IMC PMU
Date:   Tue,  5 Apr 2022 09:22:43 +0200
Message-Id: <20220405070407.656770484@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index e106909ff9c3..e7583fbcc8fa 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -1457,7 +1457,11 @@ static int trace_imc_event_init(struct perf_event *event)
 
 	event->hw.idx = -1;
 
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



