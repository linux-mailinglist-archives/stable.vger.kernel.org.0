Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED73520DB4B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgF2UF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbgF2Ta2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C4325222;
        Mon, 29 Jun 2020 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444940;
        bh=NWUUJ1ukVy0W+JRdz6CTMeUjSDfAUf92Fvbytatqz4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jv/saoPFwZKxPlWqaM2tSxQiwktyMYuLKyVacJBLvqPp9iw7QeJUNS7AK5nmjSzjo
         YagJ8zQskBctFNvmbJLYE7e0z7PDxQ1ZV1kcxDD12LkJkj1aLrtFnW9SJOquvca7OR
         QxlPRkmVcIbixAUwymKRyMD2lDNjg65ekCnv2+zg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 037/131] sch_cake: don't call diffserv parsing code when it is not needed
Date:   Mon, 29 Jun 2020 11:33:28 -0400
Message-Id: <20200629153502.2494656-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 8c95eca0bb8c4bd2231a0d581f1ad0d50c90488c ]

As a further optimisation of the diffserv parsing codepath, we can skip it
entirely if CAKE is configured to neither use diffserv-based
classification, nor to zero out the diffserv bits.

Fixes: c87b4ecdbe8d ("sch_cake: Make sure we can write the IP header before changing DSCP bits")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cake.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index d8064cb521c4c..d03f843647aea 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1508,7 +1508,7 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	return idx + (tin << 16);
 }
 
-static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
+static u8 cake_handle_diffserv(struct sk_buff *skb, bool wash)
 {
 	const int offset = skb_network_offset(skb);
 	u16 *buf, buf_;
@@ -1569,13 +1569,16 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 {
 	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 tin;
+	bool wash;
 	u8 dscp;
 
 	/* Tin selection: Default to diffserv-based selection, allow overriding
-	 * using firewall marks or skb->priority.
+	 * using firewall marks or skb->priority. Call DSCP parsing early if
+	 * wash is enabled, otherwise defer to below to skip unneeded parsing.
 	 */
-	dscp = cake_handle_diffserv(skb,
-				    q->rate_flags & CAKE_FLAG_WASH);
+	wash = !!(q->rate_flags & CAKE_FLAG_WASH);
+	if (wash)
+		dscp = cake_handle_diffserv(skb, wash);
 
 	if (q->tin_mode == CAKE_DIFFSERV_BESTEFFORT)
 		tin = 0;
@@ -1586,6 +1589,8 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 		tin = q->tin_order[TC_H_MIN(skb->priority) - 1];
 
 	else {
+		if (!wash)
+			dscp = cake_handle_diffserv(skb, wash);
 		tin = q->tin_index[dscp];
 
 		if (unlikely(tin >= q->tin_cnt))
-- 
2.25.1

