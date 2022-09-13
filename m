Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B909C5B73B1
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiIMPJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiIMPI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE2175FEC;
        Tue, 13 Sep 2022 07:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E3B1B80F10;
        Tue, 13 Sep 2022 14:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813E7C433D6;
        Tue, 13 Sep 2022 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079411;
        bh=Skxu6Kv5ssBQyZSPlWI5KDMZ8WTZbUPGO4+ITBNnGfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTwo6VA+9SQ/Il+r0qqixblJBIDDY9fykAjOI87MP5aSIM0MOxgbSJi1t/oXkfUef
         ssyOlw5SsZwH/vPqn739CrFlQ8ZAO9xB61kzjLN7Fk6gH3Cp5BQuapicFsZ8b5lbr+
         Bbt+YK2OXjbzAYkYl4+AH563cM5EiUBjuzneaD48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, zdi-disclosures@trendmicro.com
Subject: [PATCH 4.19 16/79] sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
Date:   Tue, 13 Sep 2022 16:06:34 +0200
Message-Id: <20220913140349.652764189@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
index 18c207b85d513..c0a6947545280 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1666,6 +1666,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 	idx--;
 	flow = &b->flows[idx];
+	ret = NET_XMIT_SUCCESS;
 
 	/* ensure shaper state isn't stale */
 	if (!b->tin_backlog) {
@@ -1726,6 +1727,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		qdisc_tree_reduce_backlog(sch, 1-numsegs, len-slen);
 		consume_skb(skb);
+		ret |= __NET_XMIT_STOLEN;
 	} else {
 		/* not splitting */
 		cobalt_set_enqueue_time(skb, now);
@@ -1849,7 +1851,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 		b->drop_overlimit += dropped;
 	}
-	return NET_XMIT_SUCCESS;
+	return ret;
 }
 
 static struct sk_buff *cake_dequeue_one(struct Qdisc *sch)
-- 
2.35.1



