Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E4733B533
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhCONxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhCONxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 388A364EE3;
        Mon, 15 Mar 2021 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816392;
        bh=CXDrykB2YTXWYcveyql7HCHu+NhUEXIlNh+/o7fFvTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtCYqdgUpPG2NqOAuc63B4y0oPHqqEovv0W0U8ow3CRBlXjgUxCBJxA2Ve7Oy5J4H
         UG7POpW0bXPzl274KNbo582KSZZf6CuBtmcVOdqQeIN1AYfhQPK/wM9cnmI0TVLC0H
         wnz/6CUqGDpSqWeYtUx8pHj4utAKLEEP3vQXCy8U=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Heyne <mheyne@amazon.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 13/78] net: sched: avoid duplicates in classes dump
Date:   Mon, 15 Mar 2021 14:51:36 +0100
Message-Id: <20210315135212.505232270@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
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
@@ -1789,7 +1789,7 @@ static int tc_dump_tclass_qdisc(struct Q
 
 static int tc_dump_tclass_root(struct Qdisc *root, struct sk_buff *skb,
 			       struct tcmsg *tcm, struct netlink_callback *cb,
-			       int *t_p, int s_t)
+			       int *t_p, int s_t, bool recur)
 {
 	struct Qdisc *q;
 	int b;
@@ -1800,7 +1800,7 @@ static int tc_dump_tclass_root(struct Qd
 	if (tc_dump_tclass_qdisc(root, skb, tcm, cb, t_p, s_t) < 0)
 		return -1;
 
-	if (!qdisc_dev(root))
+	if (!qdisc_dev(root) || !recur)
 		return 0;
 
 	hash_for_each(qdisc_dev(root)->qdisc_hash, b, q, hash) {
@@ -1828,13 +1828,13 @@ static int tc_dump_tclass(struct sk_buff
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


