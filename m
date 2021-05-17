Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6684038341F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241376AbhEQPFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241444AbhEQPDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419E661A24;
        Mon, 17 May 2021 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261675;
        bh=Trfeuq6Q0ahZhCuNwyABn487JjldYgKeSC/PphltxvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WB7i1ICUcD5OxfBWtIbCkSxtyUWytz6bs6UhEhaGKV0yTt5mpdz9PF5kFa7YKVJzb
         2x/1eCJ0Rmh8q8wOlgx3yoHdMHpIvHu5cWovZzKX2LEPZp5WvehNeGNUVQGz2jC++B
         Cjpbx+B8G/em8TwudgQXMzeQbGZx2O740PeCQU3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Govindarajulu Varadarajan <gvaradar@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/141] ethernet:enic: Fix a use after free bug in enic_hard_start_xmit
Date:   Mon, 17 May 2021 16:02:07 +0200
Message-Id: <20210517140245.316717013@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 643001b47adc844ae33510c4bb93c236667008a3 ]

In enic_hard_start_xmit, it calls enic_queue_wq_skb(). Inside
enic_queue_wq_skb, if some error happens, the skb will be freed
by dev_kfree_skb(skb). But the freed skb is still used in
skb_tx_timestamp(skb).

My patch makes enic_queue_wq_skb() return error and goto spin_unlock()
incase of error. The solution is provided by Govind.
See https://lkml.org/lkml/2021/4/30/961.

Fixes: fb7516d42478e ("enic: add sw timestamp support")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Acked-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 8314102002b0..03c8af58050c 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -803,7 +803,7 @@ static inline int enic_queue_wq_skb_encap(struct enic *enic, struct vnic_wq *wq,
 	return err;
 }
 
-static inline void enic_queue_wq_skb(struct enic *enic,
+static inline int enic_queue_wq_skb(struct enic *enic,
 	struct vnic_wq *wq, struct sk_buff *skb)
 {
 	unsigned int mss = skb_shinfo(skb)->gso_size;
@@ -849,6 +849,7 @@ static inline void enic_queue_wq_skb(struct enic *enic,
 		wq->to_use = buf->next;
 		dev_kfree_skb(skb);
 	}
+	return err;
 }
 
 /* netif_tx_lock held, process context with BHs disabled, or BH */
@@ -892,7 +893,8 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
-	enic_queue_wq_skb(enic, wq, skb);
+	if (enic_queue_wq_skb(enic, wq, skb))
+		goto error;
 
 	if (vnic_wq_desc_avail(wq) < MAX_SKB_FRAGS + ENIC_DESC_MAX_SPLITS)
 		netif_tx_stop_queue(txq);
@@ -900,6 +902,7 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 	if (!netdev_xmit_more() || netif_xmit_stopped(txq))
 		vnic_wq_doorbell(wq);
 
+error:
 	spin_unlock(&enic->wq_lock[txq_map]);
 
 	return NETDEV_TX_OK;
-- 
2.30.2



