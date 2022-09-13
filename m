Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478255B7306
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiIMPEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiIMPCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:02:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A07BC0;
        Tue, 13 Sep 2022 07:29:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F857B80F6F;
        Tue, 13 Sep 2022 14:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16850C433C1;
        Tue, 13 Sep 2022 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079344;
        bh=XZ7QZ5fLq/vpZtWqyZMpef7Tz7QP4R97XcrSYVDojN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQUMqmEjjX2eJ/M/i+YrmEvtcr1jhQ3AlEKUM4vbdsrpVsGpQxqSoallziT1iGIyU
         k+LDNACaezqEkDfBxcs7wY0Dc6mxtQY5FP3vL7i2uj7q7dxPpLeDColvGblK8ZOH9h
         Vt5YW+3wZGkrK3ODfzeL7ngJC6QTTHkpQwSdi7+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, zdi-disclosures@trendmicro.com
Subject: [PATCH 5.4 098/108] sch_sfb: Dont assume the skb is still around after enqueueing to child
Date:   Tue, 13 Sep 2022 16:07:09 +0200
Message-Id: <20220913140357.832371776@linuxfoundation.org>
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
index 4074c50ac3d73..085fe06da2a68 100644
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



