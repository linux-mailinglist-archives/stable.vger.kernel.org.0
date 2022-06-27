Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BC855DFC9
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiF0LbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbiF0LbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3661C70;
        Mon, 27 Jun 2022 04:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ADE9B81117;
        Mon, 27 Jun 2022 11:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD88C3411D;
        Mon, 27 Jun 2022 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329319;
        bh=8HHd8s6/5GHoKVXqUt4UT5kPffZIDiUHJ3d5gShlvh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dH2FHbIiYEkkNlv7m3OZYJxZITcBnsxUePgpE8XCW20347H3o+E86EwCzEEyHXEW1
         F08P7ToKtMLf2Od0NjjLvhjNgUHwboa+9w7pgYF2PEb02TpTxrl23AKmuvO2UCGe8N
         4eI/LihwnqmYtiCoWCm2wDYOMctBQkj3sSt71clM=
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
Subject: [PATCH 5.4 20/60] net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms
Date:   Mon, 27 Jun 2022 13:21:31 +0200
Message-Id: <20220627111928.256454221@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
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
index f4101a920d1f..1802f134aa40 100644
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



