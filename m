Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F72D10BE2F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfK0Uuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730373AbfK0Uuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:50:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861CF21852;
        Wed, 27 Nov 2019 20:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887854;
        bh=gnyAIKlrNJ5aelo1XrWF4FeI3PBPvjVGwofmo4745j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJzRfPkEeXIuVxpIwen0Gp66OxCjY4/8D+ozOryMvg/IWG/7Ue3rPEkxP75R/qnkq
         opZRALvygzbNZu/yRArPHwtNa6hZUmGskO+mW6z+YabrEzvSCDJ7J0cmfwCqLYt/kt
         spRymnA7Iy0FYzuVeYudKm3EEBS6m2awL6b2PYoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 120/211] net: hns3: bugfix for buffer not free problem during resetting
Date:   Wed, 27 Nov 2019 21:30:53 +0100
Message-Id: <20191127203105.515962408@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 73b907a083b8a8c1c62cb494bc9fbe6ae086c460 ]

When hns3_get_ring_config()/hns3_queue_to_ring()/
hns3_get_vector_ring_chain() failed during resetting, the allocated
memory has not been freed before these three functions return. So
this patch adds error handler in these functions to fix it.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hns3_enet.c         | 24 ++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
index 5483cb23c08a3..e9cff8ed5e076 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
@@ -2300,7 +2300,7 @@ static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 			chain = devm_kzalloc(&pdev->dev, sizeof(*chain),
 					     GFP_KERNEL);
 			if (!chain)
-				return -ENOMEM;
+				goto err_free_chain;
 
 			cur_chain->next = chain;
 			chain->tqp_index = tx_ring->tqp->tqp_index;
@@ -2324,7 +2324,7 @@ static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 	while (rx_ring) {
 		chain = devm_kzalloc(&pdev->dev, sizeof(*chain), GFP_KERNEL);
 		if (!chain)
-			return -ENOMEM;
+			goto err_free_chain;
 
 		cur_chain->next = chain;
 		chain->tqp_index = rx_ring->tqp->tqp_index;
@@ -2336,6 +2336,16 @@ static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 	}
 
 	return 0;
+
+err_free_chain:
+	cur_chain = head->next;
+	while (cur_chain) {
+		chain = cur_chain->next;
+		devm_kfree(&pdev->dev, chain);
+		cur_chain = chain;
+	}
+
+	return -ENOMEM;
 }
 
 static void hns3_free_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
@@ -2530,8 +2540,10 @@ static int hns3_queue_to_ring(struct hnae3_queue *tqp,
 		return ret;
 
 	ret = hns3_ring_get_cfg(tqp, priv, HNAE3_RING_TYPE_RX);
-	if (ret)
+	if (ret) {
+		devm_kfree(priv->dev, priv->ring_data[tqp->tqp_index].ring);
 		return ret;
+	}
 
 	return 0;
 }
@@ -2556,6 +2568,12 @@ static int hns3_get_ring_config(struct hns3_nic_priv *priv)
 
 	return 0;
 err:
+	while (i--) {
+		devm_kfree(priv->dev, priv->ring_data[i].ring);
+		devm_kfree(priv->dev,
+			   priv->ring_data[i + h->kinfo.num_tqps].ring);
+	}
+
 	devm_kfree(&pdev->dev, priv->ring_data);
 	return ret;
 }
-- 
2.20.1



