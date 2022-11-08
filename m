Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406376212A4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiKHNlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiKHNlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:41:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1776950F15
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:41:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE0C8B81AEE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2696C433D6;
        Tue,  8 Nov 2022 13:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914880;
        bh=oAXbz6J3jZ31rm9BL8lvh+dBkegsaOcoRhHsgjAsfoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC2yrcWz7bpf506zn1Y6/v2cjLqlr+M3VgmF2od54MZEhnjMLqPQtwkzSZ5u+8doy
         Ilzjzl5u8JC+uAUOuUmiY1Z58kfXPoOTw7tZGzyoNEpTfpfLZsRqBRc+pRefvpb4AK
         1CnV+7A+B6fGo5hUDgFpBd6C6USIwqNrf+oLpo/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/30] net: sched: Fix use after free in red_enqueue()
Date:   Tue,  8 Nov 2022 14:38:56 +0100
Message-Id: <20221108133327.003687785@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
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
index d6abf5c5a5b8..27142950827a 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -61,6 +61,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct red_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *child = q->qdisc;
+	unsigned int len;
 	int ret;
 
 	q->vars.qavg = red_calc_qavg(&q->parms,
@@ -96,9 +97,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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



