Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B9F14DAC
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfEFOqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbfEFOqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2CC1214AF;
        Mon,  6 May 2019 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154004;
        bh=gTVn1jqglTyEHundzBHlgp3WYOkBrl7KR+sLXdDxgDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILKkfwEmpFtYwPMzH/PoXv3NZfNZMCwnlETKzTpnFWZF0/xuLy370XpYbb7EJ/5wg
         86fMMzlh/sJkCeJHN0r067IcPGbMfi34Sx3N1Kx5OhX+9Xigwfg6faNsEDreK3UB4V
         fjFwFvhW/sYcsYYKgE1YRf/DqaLDRspw4+drlXYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liubin Shu <shuliubin@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 47/75] net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()
Date:   Mon,  6 May 2019 16:32:55 +0200
Message-Id: <20190506143057.469925564@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3a39a12ad364a9acd1038ba8da67cd8430f30de4 ]

This patch is trying to fix the issue due to:
[27237.844750] BUG: KASAN: use-after-free in hns_nic_net_xmit_hw+0x708/0xa18[hns_enet_drv]

After hnae_queue_xmit() in hns_nic_net_xmit_hw(), can be
interrupted by interruptions, and than call hns_nic_tx_poll_one()
to handle the new packets, and free the skb. So, when turn back to
hns_nic_net_xmit_hw(), calling skb->len will cause use-after-free.

This patch update tx ring statistics in hns_nic_tx_poll_one() to
fix the bug.

Signed-off-by: Liubin Shu <shuliubin@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index d30c28fba249..15739eae3da1 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -376,8 +376,6 @@ netdev_tx_t hns_nic_net_xmit_hw(struct net_device *ndev,
 	wmb(); /* commit all data before submit */
 	assert(skb->queue_mapping < priv->ae_handle->q_num);
 	hnae_queue_xmit(priv->ae_handle->qs[skb->queue_mapping], buf_num);
-	ring->stats.tx_pkts++;
-	ring->stats.tx_bytes += skb->len;
 
 	return NETDEV_TX_OK;
 
@@ -1099,6 +1097,9 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data *ring_data,
 		/* issue prefetch for next Tx descriptor */
 		prefetch(&ring->desc_cb[ring->next_to_clean]);
 	}
+	/* update tx ring statistics. */
+	ring->stats.tx_pkts += pkts;
+	ring->stats.tx_bytes += bytes;
 
 	NETIF_TX_UNLOCK(ring);
 
-- 
2.20.1



