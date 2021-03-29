Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1AF34CA97
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhC2IjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234911AbhC2Ihe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D82ED6193B;
        Mon, 29 Mar 2021 08:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007042;
        bh=bnvZo+zIGgZyYZX34fgg3eoAfBuKhFvhF86T9nmRv/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f12duVa+EkqH+MV2HqHnYR+vUPQ/WyOGi+upgFwLtF5Je3TXfET8ZdDl150BlxBee
         9tsD12kyCFl6B3B21kedfsoyaThTnCgHNChuTnBq27G3AX9EozMAj0rO44AhFLK4o4
         ROOgc/+zXP/kKHGJ66pt/lg2fDrE+j41VjcZWmPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 164/254] ionic: linearize tso skb with too many frags
Date:   Mon, 29 Mar 2021 09:58:00 +0200
Message-Id: <20210329075638.572336377@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit d2c21422323b06938b3c070361dc544f047489d7 ]

We were linearizing non-TSO skbs that had too many frags, but
we weren't checking number of frags on TSO skbs.  This could
lead to a bad page reference when we received a TSO skb with
more frags than the Tx descriptor could support.

v2: use gso_segs rather than yet another division
    don't rework the check on the nr_frags

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index ac4cd5d82e69..b7601cadcb8c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -1079,15 +1079,17 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 {
 	int sg_elems = q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	int ndescs;
 	int err;
 
-	/* If TSO, need roundup(skb->len/mss) descs */
+	/* Each desc is mss long max, so a descriptor for each gso_seg */
 	if (skb_is_gso(skb))
-		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
+		ndescs = skb_shinfo(skb)->gso_segs;
+	else
+		ndescs = 1;
 
-	/* If non-TSO, just need 1 desc and nr_frags sg elems */
 	if (skb_shinfo(skb)->nr_frags <= sg_elems)
-		return 1;
+		return ndescs;
 
 	/* Too many frags, so linearize */
 	err = skb_linearize(skb);
@@ -1096,8 +1098,7 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 
 	stats->linearize++;
 
-	/* Need 1 desc and zero sg elems */
-	return 1;
+	return ndescs;
 }
 
 static int ionic_maybe_stop_tx(struct ionic_queue *q, int ndescs)
-- 
2.30.1



