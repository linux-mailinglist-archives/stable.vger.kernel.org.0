Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396DE147F52
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbgAXLBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgAXLBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:22 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D2122075D;
        Fri, 24 Jan 2020 11:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863682;
        bh=AC2XZjVqritrwg1TflugtS75Uy1slnslXKIH4VU2cNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xc6DrthRjgdMnLlxPptqxUPAlJp5UnAsVslGVR9fMYUhCqI5Byr18Y2YcR0XpPHJP
         Ma3gW/KFAN+posSAFRRR/w1qHN1qa741AT5m0HYU1yff/seTmwzvip73f1GsmeDimm
         UcHui760z231/gUxtzimZ7HgqB2Dx+EpUiMZ+pSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/639] net: hns3: add error handler for hns3_nic_init_vector_data()
Date:   Fri, 24 Jan 2020 10:23:49 +0100
Message-Id: <20200124093054.805533348@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit ece4bf46e98c9f3775a488f3932a531508d3b1a2 ]

When hns3_nic_init_vector_data() fails to map ring to vector,
it should cancel the netif_napi_add() that has been successfully
done and then exits.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1aaf6e2a3b39d..9df807ec8c840 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2642,7 +2642,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int ret = 0;
-	u16 i;
+	int i;
 
 	for (i = 0; i < priv->vector_num; i++) {
 		tqp_vector = &priv->tqp_vector[i];
@@ -2687,13 +2687,19 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
 
 		if (ret)
-			return ret;
+			goto map_ring_fail;
 
 		netif_napi_add(priv->netdev, &tqp_vector->napi,
 			       hns3_nic_common_poll, NAPI_POLL_WEIGHT);
 	}
 
 	return 0;
+
+map_ring_fail:
+	while (i--)
+		netif_napi_del(&priv->tqp_vector[i].napi);
+
+	return ret;
 }
 
 static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
-- 
2.20.1



