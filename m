Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BD638A113
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhETJ2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhETJ1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:27:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76E946124C;
        Thu, 20 May 2021 09:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502759;
        bh=5EPzffGvsdOFYPX4tm9bVja+aoL9dILhXUE4Y/w9V5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTjv4x8Gp25GyL3zSE2xa/e6p7obDWhdy40XQG8Y/Xh4pMhMlJLWpUPmWDzL2g77U
         0ZBRBODan1ofvLC4crMgclSSiwKE8K19FLbENYum+bN6EtESqQ4IhRvsHz1oic8cma
         zyXkIpCBFy0QWmlnhfdorzUsPMt6UcwladIKnd4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 37/45] net:CXGB4: fix leak if sk_buff is not used
Date:   Thu, 20 May 2021 11:22:25 +0200
Message-Id: <20210520092054.726023705@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 52bfcdd87e83d9e69d22da5f26b1512ffc81deed ]

An sk_buff is allocated to send a flow control message, but it's not
sent in all cases: in case the state is not appropiate to send it or if
it can't be enqueued.

In the first of these 2 cases, the sk_buff was discarded but not freed,
producing a memory leak.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 256fae15e032..1e5f2edb70cf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2563,12 +2563,12 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 	spin_lock_bh(&eosw_txq->lock);
 	if (tc != FW_SCHED_CLS_NONE) {
 		if (eosw_txq->state != CXGB4_EO_STATE_CLOSED)
-			goto out_unlock;
+			goto out_free_skb;
 
 		next_state = CXGB4_EO_STATE_FLOWC_OPEN_SEND;
 	} else {
 		if (eosw_txq->state != CXGB4_EO_STATE_ACTIVE)
-			goto out_unlock;
+			goto out_free_skb;
 
 		next_state = CXGB4_EO_STATE_FLOWC_CLOSE_SEND;
 	}
@@ -2604,17 +2604,19 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 		eosw_txq_flush_pending_skbs(eosw_txq);
 
 	ret = eosw_txq_enqueue(eosw_txq, skb);
-	if (ret) {
-		dev_consume_skb_any(skb);
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_skb;
 
 	eosw_txq->state = next_state;
 	eosw_txq->flowc_idx = eosw_txq->pidx;
 	eosw_txq_advance(eosw_txq, 1);
 	ethofld_xmit(dev, eosw_txq);
 
-out_unlock:
+	spin_unlock_bh(&eosw_txq->lock);
+	return 0;
+
+out_free_skb:
+	dev_consume_skb_any(skb);
 	spin_unlock_bh(&eosw_txq->lock);
 	return ret;
 }
-- 
2.30.2



