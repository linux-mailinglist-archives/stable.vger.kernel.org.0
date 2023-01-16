Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4110766C4E1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjAPP72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjAPP7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:59:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA2C234DB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 173E1B8104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73155C433D2;
        Mon, 16 Jan 2023 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884743;
        bh=FSzIl3Br0IRJ4e/YjR2XgmqTQrKkFeAFEIh8XT+PnGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRdWWNxJnVljO8AMPDv9noenAbfHVihdnzv2lNynTWnfCCWkKsWawNE6sDdpc0/Ot
         1iNywmbI/LHlWmigPkfwgQY1aXstWwU6/f3I/AVRHLDiHDp8C421QetTl2E+BR5o7b
         wIgCy9g19v0zGc6hOJHYWMrnYNw+NnwFUsE2655U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yair Podemsky <ypodemsk@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/183] sched/core: Fix arch_scale_freq_tick() on tickless systems
Date:   Mon, 16 Jan 2023 16:50:45 +0100
Message-Id: <20230116154808.552935737@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yair Podemsky <ypodemsk@redhat.com>

[ Upstream commit 7fb3ff22ad8772bbf0e3ce1ef3eb7b09f431807f ]

In order for the scheduler to be frequency invariant we measure the
ratio between the maximum CPU frequency and the actual CPU frequency.

During long tickless periods of time the calculations that keep track
of that might overflow, in the function scale_freq_tick():

  if (check_shl_overflow(acnt, 2*SCHED_CAPACITY_SHIFT, &acnt))
          goto error;

eventually forcing the kernel to disable the feature for all CPUs,
and show the warning message:

   "Scheduler frequency invariance went wobbly, disabling!".

Let's avoid that by limiting the frequency invariant calculations
to CPUs with regular tick.

Fixes: e2b0d619b400 ("x86, sched: check for counters overflow in frequency invariant accounting")
Suggested-by: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Yair Podemsky <ypodemsk@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Link: https://lore.kernel.org/r/20221130125121.34407-1-ypodemsk@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 981e41cc4121..172ec79b66f6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5498,7 +5498,9 @@ void scheduler_tick(void)
 	unsigned long thermal_pressure;
 	u64 resched_latency;
 
-	arch_scale_freq_tick();
+	if (housekeeping_cpu(cpu, HK_TYPE_TICK))
+		arch_scale_freq_tick();
+
 	sched_clock_tick();
 
 	rq_lock(rq, &rf);
-- 
2.35.1



