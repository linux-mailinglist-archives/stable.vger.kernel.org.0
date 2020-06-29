Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6DC20E7B8
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404661AbgF2V7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgF2Sf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 751172409A;
        Mon, 29 Jun 2020 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443934;
        bh=kGWb1hpKE7ju2/NwV1xV9/JAHkWmmnyHZ5zcq8MrUdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EClYa6FcKBpIxaplEHvQyW+u+3Canzm52i4jHpqPwavg5KWctN9tVYmZACW1hYEru
         ud8OQdYsavextz5iLsKfBUOQoDtdQUUyNA834bDtYuL9UXk+R9yKYdqHB3EWd4+BOI
         V72L2txNZ+smwTmw9seeg/2b4PVVCDWumi53RmMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 035/265] sch_cake: don't call diffserv parsing code when it is not needed
Date:   Mon, 29 Jun 2020 11:14:28 -0400
Message-Id: <20200629151818.2493727-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index a92d6c57aa9a5..3482f9569dce5 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1514,7 +1514,7 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	return idx + (tin << 16);
 }
 
-static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
+static u8 cake_handle_diffserv(struct sk_buff *skb, bool wash)
 {
 	const int offset = skb_network_offset(skb);
 	u16 *buf, buf_;
@@ -1575,14 +1575,17 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 {
 	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 tin, mark;
+	bool wash;
 	u8 dscp;
 
 	/* Tin selection: Default to diffserv-based selection, allow overriding
-	 * using firewall marks or skb->priority.
+	 * using firewall marks or skb->priority. Call DSCP parsing early if
+	 * wash is enabled, otherwise defer to below to skip unneeded parsing.
 	 */
-	dscp = cake_handle_diffserv(skb,
-				    q->rate_flags & CAKE_FLAG_WASH);
 	mark = (skb->mark & q->fwmark_mask) >> q->fwmark_shft;
+	wash = !!(q->rate_flags & CAKE_FLAG_WASH);
+	if (wash)
+		dscp = cake_handle_diffserv(skb, wash);
 
 	if (q->tin_mode == CAKE_DIFFSERV_BESTEFFORT)
 		tin = 0;
@@ -1596,6 +1599,8 @@ static struct cake_tin_data *cake_select_tin(struct Qdisc *sch,
 		tin = q->tin_order[TC_H_MIN(skb->priority) - 1];
 
 	else {
+		if (!wash)
+			dscp = cake_handle_diffserv(skb, wash);
 		tin = q->tin_index[dscp];
 
 		if (unlikely(tin >= q->tin_cnt))
-- 
2.25.1

