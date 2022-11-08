Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A594621530
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiKHOJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbiKHOJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EECB3F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92D2BB81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31CDC433C1;
        Tue,  8 Nov 2022 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916550;
        bh=MV3LsN1YBAo3F0nQ11qgRDKoUTwrZ1JCo+rs848gggE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOPFAJRDH6VUkNTE8pUMGNf58XrAfaJ+7vlbCnH7lFy+Z1YK8y2MGFIDdKjD6wGYr
         ijAzNgZyIZUb1g2XIvpXmX3OThynVhFYcfw6FpxWBipGk0NSk7Be6F3h/BfS4jbF+i
         VhOavkkXnOKM4rLQYBnayRI6R2rSHXzJ0LR/OU+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 028/197] net: sched: Fix use after free in red_enqueue()
Date:   Tue,  8 Nov 2022 14:37:46 +0100
Message-Id: <20221108133356.074582327@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8bdc2acd420c6f3dd1f1c78750ec989f02a1e2b9 ]

We can't use "skb" again after passing it to qdisc_enqueue().  This is
basically identical to commit 2f09707d0c97 ("sch_sfb: Also store skb
len before calling child enqueue").

Fixes: d7f4f332f082 ("sch_red: update backlog as well")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_red.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index f1e013e3f04a..935d90874b1b 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -72,6 +72,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct red_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *child = q->qdisc;
+	unsigned int len;
 	int ret;
 
 	q->vars.qavg = red_calc_qavg(&q->parms,
@@ -126,9 +127,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		break;
 	}
 
+	len = qdisc_pkt_len(skb);
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
 	} else if (net_xmit_drop_count(ret)) {
 		q->stats.pdrop++;
-- 
2.35.1



