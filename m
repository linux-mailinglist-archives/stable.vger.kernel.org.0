Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3861F315
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfEOLHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbfEOLHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:07:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DACE621734;
        Wed, 15 May 2019 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918430;
        bh=JlwyHEohO2xv4+EVF62uG8Sb9qrBFeL13jZxwz/qLaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZJAm6MMpkcnIYlsALhGzauByraeXxfNZOv3kg0KUA6o05RcAcmdVUmUcRm7Hl77L
         O2FfGonQ3kHpeRQKZAKoZdb6eQQf4USpSQuZl3KuWWJU5yI50bxnqYLnjHsZlEHcXb
         tiNYO+zGLjyOGprJ0/Cr9Ndaop57Q6GkxKR46+3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 129/266] net: hns: Use NAPI_POLL_WEIGHT for hns driver
Date:   Wed, 15 May 2019 12:53:56 +0200
Message-Id: <20190515090727.330762691@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit acb1ce15a61154aa501891d67ebf79bc9ea26818 ]

When the HNS driver loaded, always have an error print:
"netif_napi_add() called with weight 256"

This is because the kernel checks the NAPI polling weights
requested by drivers and it prints an error message if a driver
requests a weight bigger than 64.

So use NAPI_POLL_WEIGHT to fix it.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 2fa54b0b0679..6d649e7b45a9 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -28,9 +28,6 @@
 
 #define SERVICE_TIMER_HZ (1 * HZ)
 
-#define NIC_TX_CLEAN_MAX_NUM 256
-#define NIC_RX_CLEAN_MAX_NUM 64
-
 #define RCB_IRQ_NOT_INITED 0
 #define RCB_IRQ_INITED 1
 
@@ -1408,7 +1405,7 @@ static int hns_nic_init_ring_data(struct hns_nic_priv *priv)
 		rd->fini_process = hns_nic_tx_fini_pro;
 
 		netif_napi_add(priv->netdev, &rd->napi,
-			       hns_nic_common_poll, NIC_TX_CLEAN_MAX_NUM);
+			       hns_nic_common_poll, NAPI_POLL_WEIGHT);
 		rd->ring->irq_init_flag = RCB_IRQ_NOT_INITED;
 	}
 	for (i = h->q_num; i < h->q_num * 2; i++) {
@@ -1420,7 +1417,7 @@ static int hns_nic_init_ring_data(struct hns_nic_priv *priv)
 		rd->fini_process = hns_nic_rx_fini_pro;
 
 		netif_napi_add(priv->netdev, &rd->napi,
-			       hns_nic_common_poll, NIC_RX_CLEAN_MAX_NUM);
+			       hns_nic_common_poll, NAPI_POLL_WEIGHT);
 		rd->ring->irq_init_flag = RCB_IRQ_NOT_INITED;
 	}
 
-- 
2.20.1



