Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA878561D55
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbiF3OC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbiF3OC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6F25073A;
        Thu, 30 Jun 2022 06:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CD9BB82AF3;
        Thu, 30 Jun 2022 13:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C545C34115;
        Thu, 30 Jun 2022 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597171;
        bh=3KY1oaQSn0G41Rhl1/3pb9fLEjbbzfQpc6xmm+S8BKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VT6hAUd3ZSJeg92CuESZuSpmHvhhYlKPbAUzuB929eXzqf32EWG1vxCV6YSVYl31
         PMmMrfuerv+4BaVL9wIHbpz8X7Bz+Uf2F7PrG3UF50F4VeYak1aMuqhzoWTIIhLgsx
         fB11664Ii8rkt1u7IO5QV9nZJcd6BWQ8iu7IAneU=
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
Subject: [PATCH 4.19 13/49] net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms
Date:   Thu, 30 Jun 2022 15:46:26 +0200
Message-Id: <20220630133234.292428034@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
index ad400f4f9a2d..31793af1a77b 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1120,9 +1120,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_buff *skb)
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



