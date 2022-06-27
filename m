Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4849655DAFD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbiF0LYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbiF0LYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAC56573;
        Mon, 27 Jun 2022 04:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9D82B81122;
        Mon, 27 Jun 2022 11:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3090FC3411D;
        Mon, 27 Jun 2022 11:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329058;
        bh=jCMUa1qxy25zcTSppi5OnwFRN6ISO/vpezVuczdRk88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGgZ8sR54dPQCH/aVm4HTgdY2D+ZrxM2ayakwGReEckQP50svK0sOplbiGhX+xcSp
         2TcV9wtZ56lQYppRNXXSsp49Qnwc99ektyqIa35Aciwi80cYGtJLOCF8eWr0b/n4TX
         hBwFcXcjYaXSfcB0Dl7llJScoElkD1lnniJEdEjU=
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
Subject: [PATCH 5.10 035/102] net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms
Date:   Mon, 27 Jun 2022 13:20:46 +0200
Message-Id: <20220627111934.506359210@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
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
index 0c345e43a09a..adc5407fd5d5 100644
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



