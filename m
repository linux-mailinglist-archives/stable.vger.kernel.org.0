Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BFE5AEA1B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiIFNjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240675AbiIFNin (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:38:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362D076449;
        Tue,  6 Sep 2022 06:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A7C061548;
        Tue,  6 Sep 2022 13:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A58C433C1;
        Tue,  6 Sep 2022 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471289;
        bh=V8KfkY9Z3LzwSc0dKcGeIHwZTwBbtxyXlAkRQ28XaYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RG7tW2yyP+YGR/1jwFnbjxhkcYQo59Q2GjA+THy1Jgh2V8+a0b5Y6CS62ugG2+kVh
         cAl9JZL6ttAofEVALauWRT+/RqcUnGYs/dofGiakHH9neNhuaV3X5ZQMQfkTLD3wm3
         UxyP1bRvQBIbRulvsPIY7MSqMtVYQxaCgj9dyaME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, zdi-disclosures@trendmicro.com
Subject: [PATCH 5.10 17/80] sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
Date:   Tue,  6 Sep 2022 15:30:14 +0200
Message-Id: <20220906132817.654141837@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit 90fabae8a2c225c4e4936723c38857887edde5cc ]

When the GSO splitting feature of sch_cake is enabled, GSO superpackets
will be broken up and the resulting segments enqueued in place of the
original skb. In this case, CAKE calls consume_skb() on the original skb,
but still returns NET_XMIT_SUCCESS. This can confuse parent qdiscs into
assuming the original skb still exists, when it really has been freed. Fix
this by adding the __NET_XMIT_STOLEN flag to the return value in this case.

Fixes: 0c850344d388 ("sch_cake: Conditionally split GSO segments")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18231
Link: https://lore.kernel.org/r/20220831092103.442868-1-toke@toke.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index c580139fcedec..4e380534dbc92 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1713,6 +1713,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 	idx--;
 	flow = &b->flows[idx];
+	ret = NET_XMIT_SUCCESS;
 
 	/* ensure shaper state isn't stale */
 	if (!b->tin_backlog) {
@@ -1771,6 +1772,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		qdisc_tree_reduce_backlog(sch, 1-numsegs, len-slen);
 		consume_skb(skb);
+		ret |= __NET_XMIT_STOLEN;
 	} else {
 		/* not splitting */
 		cobalt_set_enqueue_time(skb, now);
@@ -1904,7 +1906,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 		b->drop_overlimit += dropped;
 	}
-	return NET_XMIT_SUCCESS;
+	return ret;
 }
 
 static struct sk_buff *cake_dequeue_one(struct Qdisc *sch)
-- 
2.35.1



