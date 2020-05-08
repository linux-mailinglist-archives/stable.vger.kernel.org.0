Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B81C1CAFF1
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgEHNWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgEHMjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABBCD21835;
        Fri,  8 May 2020 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941591;
        bh=fqYCYsMj3FRkkusxwvdVSk6u1Kx3PseH0zozENmZTUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGviC6XhG9cjLLwSbPw45LKMmtXz1N7+RO329ai+cXS+fYuGtR/SR6n97LBcoD+2p
         Q7EYwrLP4o86R84EI3PS44iLQ/Oc0KQ0DD7TwNzX+IzvOcraCuUq0sSB9QicColk9+
         A80sr28/17RmQ3heOuptvkGJrm7Ue46ngYs7cgZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 092/312] sch_sfb: keep backlog updated with qlen
Date:   Fri,  8 May 2020 14:31:23 +0200
Message-Id: <20200508123131.004275632@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

commit 3d4357fba82b3cf19ebf0a04d1c9cb086af15d02 upstream.

Fixes: 2ccccf5fb43f ("net_sched: update hierarchical backlog too")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_sfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -400,6 +400,7 @@ static int sfb_enqueue(struct sk_buff *s
 enqueue:
 	ret = qdisc_enqueue(skb, child);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
+		qdisc_qstats_backlog_inc(sch, skb);
 		sch->q.qlen++;
 		increment_qlen(skb, q);
 	} else if (net_xmit_drop_count(ret)) {
@@ -428,6 +429,7 @@ static struct sk_buff *sfb_dequeue(struc
 
 	if (skb) {
 		qdisc_bstats_update(sch, skb);
+		qdisc_qstats_backlog_dec(sch, skb);
 		sch->q.qlen--;
 		decrement_qlen(skb, q);
 	}
@@ -450,6 +452,7 @@ static void sfb_reset(struct Qdisc *sch)
 	struct sfb_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
+	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
 	q->slot = 0;
 	q->double_buffering = false;


