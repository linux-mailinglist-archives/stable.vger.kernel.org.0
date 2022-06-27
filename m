Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0A55CE1B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbiF0Lte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238336AbiF0LsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38229F5A1;
        Mon, 27 Jun 2022 04:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C980861180;
        Mon, 27 Jun 2022 11:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B85C341C7;
        Mon, 27 Jun 2022 11:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330046;
        bh=D1S1Yty5XrdXUr+pNNeKQBUfDvsurleJROtK6ST4Bew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecEGG1iWkk4fuUep0A3C/CEzjft5BagNZqNaD9zj3+Hk1dBzj33TlnI2tf0f9G14f
         P/Gj3zvJ1j2FVjyXJ5VJyO1n8Yg504j1ZjvifVwx7TJZMpMaCrpJWo/RIlKntUUcNG
         5mHv9/Ajw7m67wr2uutCVaaktctMWZW7EDkT1a1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yuming Chen <chenyuming.junnan@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 065/181] net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms
Date:   Mon, 27 Jun 2022 13:20:38 +0200
Message-Id: <20220627111946.450908786@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit a2b1a5d40bd12b44322c2ccd40bb0ec1699708b6 ]

As reported by Yuming, currently tc always show a latency of UINT_MAX
for netem Qdisc's on 32-bit platforms:

    $ tc qdisc add dev dummy0 root netem latency 100ms
    $ tc qdisc show dev dummy0
    qdisc netem 8001: root refcnt 2 limit 1000 delay 275s  275s
                                               ^^^^^^^^^^^^^^^^

Let us take a closer look at netem_dump():

        qopt.latency = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->latency,
                             UINT_MAX);

qopt.latency is __u32, psched_tdiff_t is signed long,
(psched_tdiff_t)(UINT_MAX) is negative for 32-bit platforms, so
qopt.latency is always UINT_MAX.

Fix it by using psched_time_t (u64) instead.

Note: confusingly, users have two ways to specify 'latency':

  1. normally, via '__u32 latency' in struct tc_netem_qopt;
  2. via the TCA_NETEM_LATENCY64 attribute, which is s64.

For the second case, theoretically 'latency' could be negative.  This
patch ignores that corner case, since it is broken (i.e. assigning a
negative s64 to __u32) anyways, and should be handled separately.

Thanks Ted Lin for the analysis [1] .

[1] https://github.com/raspberrypi/linux/issues/3512

Reported-by: Yuming Chen <chenyuming.junnan@bytedance.com>
Fixes: 112f9cb65643 ("netem: convert to qdisc_watchdog_schedule_ns")
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Link: https://lore.kernel.org/r/20220616234336.2443-1-yepeilin.cs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index ed4ccef5d6a8..5449ed114e40 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1146,9 +1146,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_netem_rate rate;
 	struct tc_netem_slot slot;
 
-	qopt.latency = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->latency),
+	qopt.latency = min_t(psched_time_t, PSCHED_NS2TICKS(q->latency),
 			     UINT_MAX);
-	qopt.jitter = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->jitter),
+	qopt.jitter = min_t(psched_time_t, PSCHED_NS2TICKS(q->jitter),
 			    UINT_MAX);
 	qopt.limit = q->limit;
 	qopt.loss = q->loss;
-- 
2.35.1



