Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2E05B7565
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiIMPkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiIMPkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:40:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B503F1FA;
        Tue, 13 Sep 2022 07:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC7A1B81017;
        Tue, 13 Sep 2022 14:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3684CC433C1;
        Tue, 13 Sep 2022 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079762;
        bh=M73bX+LP+zY4u4erhlSkaoaIApdxC197uCSuRUq4k/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVU7+uIxeJLobHdFCEpbgt9kD1u6OoegvBixR1EdGucVdqEXN8HLIUhN4TP+TkDol
         F2bui9t5LWY2Z1qUdLXCluiLkiyRPjyoyR5NMQtGeoPw6eWbJLSCHDE0jrejG83vP2
         xPLQuTZ6wJujRdIhsOuNyeTBpNQRCC7NLu1w8CNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 56/61] sch_sfb: Also store skb len before calling child enqueue
Date:   Tue, 13 Sep 2022 16:07:58 +0200
Message-Id: <20220913140349.260391735@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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

[ Upstream commit 2f09707d0c972120bf794cfe0f0c67e2c2ddb252 ]

Cong Wang noticed that the previous fix for sch_sfb accessing the queued
skb after enqueueing it to a child qdisc was incomplete: the SFB enqueue
function was also calling qdisc_qstats_backlog_inc() after enqueue, which
reads the pkt len from the skb cb field. Fix this by also storing the skb
len, and using the stored value to increment the backlog after enqueueing.

Fixes: 9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueueing to child")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20220905192137.965549-1-toke@toke.dk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 8f924defa98d0..9962a49989938 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -284,6 +284,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 
 	struct sfb_sched_data *q = qdisc_priv(sch);
+	unsigned int len = qdisc_pkt_len(skb);
 	struct Qdisc *child = q->qdisc;
 	struct tcf_proto *fl;
 	struct sfb_skb_cb cb;
@@ -406,7 +407,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
 		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
-- 
2.35.1



