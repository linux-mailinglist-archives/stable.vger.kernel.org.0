Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5FF5B7402
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiIMPOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbiIMPMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:12:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC3F7859E;
        Tue, 13 Sep 2022 07:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B0D3614C6;
        Tue, 13 Sep 2022 14:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C5BC433D6;
        Tue, 13 Sep 2022 14:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079134;
        bh=l5OCQkp7AMyhQdvC0Ke3OId9wue2XA3PT9yDUhzvn44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h22WhFz1R3oHPZT6zrUe7NM41FbCr8ep/T6Ce2NmDKQFNo5SXQmm7Ru4IeS8MXyk0
         TU3qralW6mouoks3tWVN5a8VULIhJP+mWar5zMBzd+tqSpQumeEeKsOT8IlyRiFk1o
         3lVC1GkZ6TUCQJheDOd/1JLfWe+Ne/xoILiVVtPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, zdi-disclosures@trendmicro.com
Subject: [PATCH 5.4 017/108] sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
Date:   Tue, 13 Sep 2022 16:05:48 +0200
Message-Id: <20220913140354.324932928@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
index 0eb4d4a568f77..737368c701c53 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1677,6 +1677,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 	idx--;
 	flow = &b->flows[idx];
+	ret = NET_XMIT_SUCCESS;
 
 	/* ensure shaper state isn't stale */
 	if (!b->tin_backlog) {
@@ -1737,6 +1738,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		qdisc_tree_reduce_backlog(sch, 1-numsegs, len-slen);
 		consume_skb(skb);
+		ret |= __NET_XMIT_STOLEN;
 	} else {
 		/* not splitting */
 		cobalt_set_enqueue_time(skb, now);
@@ -1870,7 +1872,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 		b->drop_overlimit += dropped;
 	}
-	return NET_XMIT_SUCCESS;
+	return ret;
 }
 
 static struct sk_buff *cake_dequeue_one(struct Qdisc *sch)
-- 
2.35.1



