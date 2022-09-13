Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC42F5B721C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiIMOuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiIMOrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:47:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E79315FF7;
        Tue, 13 Sep 2022 07:24:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11EAD614D1;
        Tue, 13 Sep 2022 14:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DCCC433D6;
        Tue, 13 Sep 2022 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079074;
        bh=Z1DqO47BFrDbZG++f2rX/wbcetEoP13iZAVe6wxbpqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cS0sffY+w29GMGkPpduXEgzYtAweGeFP6/bbIYf7zstSGmzt/WmLL18DotLWwcwRj
         t8vfXXZn4H+55qfzPTNUUgL6vdC2Jrs5JrgfF0//EX0kLYupeAZ3j3Z6J1q88vELCb
         JGpG1uW5/EDtAqHqSKDLnJ6sq2r0odqi1mDsnIBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, zdi-disclosures@trendmicro.com
Subject: [PATCH 5.10 55/79] sch_sfb: Dont assume the skb is still around after enqueueing to child
Date:   Tue, 13 Sep 2022 16:05:00 +0200
Message-Id: <20220913140352.882604311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

[ Upstream commit 9efd23297cca530bb35e1848665805d3fcdd7889 ]

The sch_sfb enqueue() routine assumes the skb is still alive after it has
been enqueued into a child qdisc, using the data in the skb cb field in the
increment_qlen() routine after enqueue. However, the skb may in fact have
been freed, causing a use-after-free in this case. In particular, this
happens if sch_cake is used as a child of sfb, and the GSO splitting mode
of CAKE is enabled (in which case the skb will be split into segments and
the original skb freed).

Fix this by copying the sfb cb data to the stack before enqueueing the skb,
and using this stack copy in increment_qlen() instead of the skb pointer
itself.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18231
Fixes: e13e02a3c68d ("net_sched: SFB flow scheduler")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index da047a37a3bf3..f180cf95cfc97 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -135,15 +135,15 @@ static void increment_one_qlen(u32 sfbhash, u32 slot, struct sfb_sched_data *q)
 	}
 }
 
-static void increment_qlen(const struct sk_buff *skb, struct sfb_sched_data *q)
+static void increment_qlen(const struct sfb_skb_cb *cb, struct sfb_sched_data *q)
 {
 	u32 sfbhash;
 
-	sfbhash = sfb_hash(skb, 0);
+	sfbhash = cb->hashes[0];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 0, q);
 
-	sfbhash = sfb_hash(skb, 1);
+	sfbhash = cb->hashes[1];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 1, q);
 }
@@ -283,6 +283,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct sfb_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *child = q->qdisc;
 	struct tcf_proto *fl;
+	struct sfb_skb_cb cb;
 	int i;
 	u32 p_min = ~0;
 	u32 minqlen = ~0;
@@ -399,11 +400,12 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 enqueue:
+	memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		qdisc_qstats_backlog_inc(sch, skb);
 		sch->q.qlen++;
-		increment_qlen(skb, q);
+		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
 		q->stats.childdrop++;
 		qdisc_qstats_drop(sch);
-- 
2.35.1



