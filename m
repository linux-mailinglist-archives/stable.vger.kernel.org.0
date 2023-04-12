Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687A36DEFAC
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjDLIwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjDLIwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551CD93D3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33EF0631AC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460E5C433D2;
        Wed, 12 Apr 2023 08:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289543;
        bh=Lopcdp1Clx17cFPIKdazuHwRuYr/qovSXWFq4JdE/90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyJXvg9Vq1NcLqaQin/ed5e26nydlnIobUXENLS/YukH8P6BDbz5bhMWyvRBOYWBS
         5Xt/BgT2JFtFLKOoMn8mG3YLhlUnYJ9HZ2G5IvNm3LPHMlr1J5XppB991K4LpI2bLq
         iyzdkzAj0zy/K/imeOWFTJVNGxVB6koT3fLTBAJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 139/173] perf: Optimize perf_pmu_migrate_context()
Date:   Wed, 12 Apr 2023 10:34:25 +0200
Message-Id: <20230412082843.730351966@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit b168098912926236bbeebaf7795eb7aab76d2b45 ]

Thomas reported that offlining CPUs spends a lot of time in
synchronize_rcu() as called from perf_pmu_migrate_context() even though
he's not actually using uncore events.

Turns out, the thing is unconditionally waiting for RCU, even if there's
no actual events to migrate.

Fixes: 0cda4c023132 ("perf: Introduce perf_pmu_migrate_context()")
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lkml.kernel.org/r/20230403090858.GT4253@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fad170b475921..4b3205f6bed5e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12875,12 +12875,14 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->pinned_groups, &events);
 	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->flexible_groups, &events);
 
-	/*
-	 * Wait for the events to quiesce before re-instating them.
-	 */
-	synchronize_rcu();
+	if (!list_empty(&events)) {
+		/*
+		 * Wait for the events to quiesce before re-instating them.
+		 */
+		synchronize_rcu();
 
-	__perf_pmu_install(dst_ctx, dst_cpu, pmu, &events);
+		__perf_pmu_install(dst_ctx, dst_cpu, pmu, &events);
+	}
 
 	mutex_unlock(&dst_ctx->mutex);
 	mutex_unlock(&src_ctx->mutex);
-- 
2.39.2



