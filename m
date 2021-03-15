Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD48D33B6D0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhCON6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhCON6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8143664EED;
        Mon, 15 Mar 2021 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816674;
        bh=u5OynKd7iO5/IG2I3kk480sm9gyr1EaQo0TwBUcaQCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNCX632xdhiSeDmzGgN6G7vmixF4nrStGTR5+hXbN9Jw3O+jVG/QshuPexn4+6R0S
         Pp3mExmtjtTwSGkCMY0i0miuK3U2o5yuIt4+wXSh2DOjbVj/oicZjAjshJGGn8Ul8Q
         zCZbyhH3GsUVnOpleqEpuZ0r6Ltftgq2AVDG0RHw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Heyne <mheyne@amazon.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 048/290] net: sched: avoid duplicates in classes dump
Date:   Mon, 15 Mar 2021 14:52:21 +0100
Message-Id: <20210315135543.550617565@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Maximilian Heyne <mheyne@amazon.de>

commit bfc2560563586372212b0a8aeca7428975fa91fe upstream.

This is a follow up of commit ea3274695353 ("net: sched: avoid
duplicates in qdisc dump") which has fixed the issue only for the qdisc
dump.

The duplicate printing also occurs when dumping the classes via
  tc class show dev eth0

Fixes: 59cc1f61f09c ("net: sched: convert qdisc linked list to hashtable")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2167,7 +2167,7 @@ static int tc_dump_tclass_qdisc(struct Q
 
 static int tc_dump_tclass_root(struct Qdisc *root, struct sk_buff *skb,
 			       struct tcmsg *tcm, struct netlink_callback *cb,
-			       int *t_p, int s_t)
+			       int *t_p, int s_t, bool recur)
 {
 	struct Qdisc *q;
 	int b;
@@ -2178,7 +2178,7 @@ static int tc_dump_tclass_root(struct Qd
 	if (tc_dump_tclass_qdisc(root, skb, tcm, cb, t_p, s_t) < 0)
 		return -1;
 
-	if (!qdisc_dev(root))
+	if (!qdisc_dev(root) || !recur)
 		return 0;
 
 	if (tcm->tcm_parent) {
@@ -2213,13 +2213,13 @@ static int tc_dump_tclass(struct sk_buff
 	s_t = cb->args[0];
 	t = 0;
 
-	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t) < 0)
+	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t, true) < 0)
 		goto done;
 
 	dev_queue = dev_ingress_queue(dev);
 	if (dev_queue &&
 	    tc_dump_tclass_root(dev_queue->qdisc_sleeping, skb, tcm, cb,
-				&t, s_t) < 0)
+				&t, s_t, false) < 0)
 		goto done;
 
 done:


