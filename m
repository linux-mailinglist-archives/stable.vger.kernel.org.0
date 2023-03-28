Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD3F6CC414
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjC1O74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbjC1O7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C58B59D4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 015BA61828
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10360C433D2;
        Tue, 28 Mar 2023 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015577;
        bh=rBkdW1y5B7zp6feinD9rC2EV8ecq3IfIX2h2UfbawzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjVZ65x+J6/2JhDFMv6U0x+8FpuVduMmToFVXhDC6H4ZjtE6UXFTkm2BDJvDBRi2t
         EcrF17D3NJTQJ3X7nXj0S9bRaR4Izu/tqgPsJBVH8NStga4OiUwyCZgu76w6VBu0la
         oHHt1d/72Y+szwdq4HbeRUREy3jtBCGFiEr21z3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Breno Leitao <leitao@debian.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sandipan Das <sandipan.das@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/224] perf/x86/amd/core: Always clear status for idx
Date:   Tue, 28 Mar 2023 16:41:35 +0200
Message-Id: <20230328142621.467028663@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 263f5ecaf7080513efc248ec739b6d9e00f4129f ]

The variable 'status' (which contains the unhandled overflow bits) is
not being properly masked in some cases, displaying the following
warning:

  WARNING: CPU: 156 PID: 475601 at arch/x86/events/amd/core.c:972 amd_pmu_v2_handle_irq+0x216/0x270

This seems to be happening because the loop is being continued before
the status bit being unset, in case x86_perf_event_set_period()
returns 0. This is also causing an inconsistency because the "handled"
counter is incremented, but the status bit is not cleaned.

Move the bit cleaning together above, together when the "handled"
counter is incremented.

Fixes: 7685665c390d ("perf/x86/amd/core: Add PerfMonV2 overflow handling")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Link: https://lore.kernel.org/r/20230321113338.1669660-1-leitao@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 4386b10682ce4..8ca5e827f30b2 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -923,6 +923,7 @@ static int amd_pmu_v2_handle_irq(struct pt_regs *regs)
 
 		/* Event overflow */
 		handled++;
+		status &= ~mask;
 		perf_sample_data_init(&data, 0, hwc->last_period);
 
 		if (!x86_perf_event_set_period(event))
@@ -935,8 +936,6 @@ static int amd_pmu_v2_handle_irq(struct pt_regs *regs)
 
 		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
-
-		status &= ~mask;
 	}
 
 	/*
-- 
2.39.2



