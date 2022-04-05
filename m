Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB44F404D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352330AbiDEMIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358095AbiDEK16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8107B67D09;
        Tue,  5 Apr 2022 03:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18C9A6179E;
        Tue,  5 Apr 2022 10:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25081C385A1;
        Tue,  5 Apr 2022 10:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153720;
        bh=F75QK3b5VpnA6kPG801y/3GqfGHfIZ0qKHqGfPz+aOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaSc3Hiok4biqAqXsVG86fVrfahd7ON0Tolh5RLWeeTUYumjgl3Q4m8o8rgr3p0ay
         tgWgj3p9GBFVQ8qT8UBuimOjVdenViowKM/do25IgfDycjGU12ECM28ZhAi/rX1kVT
         zKwPvkiBrtlYqbv6T3y6zAPjDRH9Hqyt5FGbbsOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/599] powerpc/perf: Dont use perf_hw_context for trace IMC PMU
Date:   Tue,  5 Apr 2022 09:29:40 +0200
Message-Id: <20220405070307.345828570@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 7b25548ec42b..e8074d7f2401 100644
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



