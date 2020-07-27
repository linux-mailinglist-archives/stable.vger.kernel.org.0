Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024DE22F122
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgG0OWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731818AbgG0OWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36C42173E;
        Mon, 27 Jul 2020 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859719;
        bh=oSzFurCyrGQjX0jPXdIDKNdb710vTtsvKMsBnEcvLW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3EBrMq6txtARYDSihjBJV9RlX6II1NnK0qiQSQAluvxNroRiasLiYbCS/JgFezYw
         VESK5yN9uxrnp0eNbIQQbe/6lTt8LR1AZJEZULVHvwn+okeQ8PfWt7Qp9mnxkrI+iX
         UK9IHlOhqm8dt/L+zzuNAg1IPVrlw1TNQkRx6L8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 078/179] net: hns3: fix for not calculating TX BD send size correctly
Date:   Mon, 27 Jul 2020 16:04:13 +0200
Message-Id: <20200727134936.483910343@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 48ae74c9d89f827b39b5c07a1f02fc13637a3cd6 ]

With GRO and fraglist support, the SKB can be aggregated to
a total size of 65535, and when that SKB is forwarded through
a bridge, the size of the SKB may be pushed to exceed the size
of 65535 when br_dev_queue_push_xmit() is called.

The max send size of BD supported by the HW is 65535, when a SKB
with a headlen of over 65535 is sent to the driver, the driver
needs to use multi BD to send the linear data, and the send size
of the last BD is calculated incorrectly by the driver who is
using '&' operation, which causes a TX error.

Use '%' operation to fix this problem.

Fixes: 3fe13ed95dd3 ("net: hns3: avoid mult + div op in critical data path")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3003eecd5263b..5dab84aa3afd5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1140,7 +1140,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	}
 
 	frag_buf_num = hns3_tx_bd_count(size);
-	sizeoflast = size & HNS3_TX_LAST_SIZE_M;
+	sizeoflast = size % HNS3_MAX_BD_SIZE;
 	sizeoflast = sizeoflast ? sizeoflast : HNS3_MAX_BD_SIZE;
 
 	/* When frag size is bigger than hardware limit, split this frag */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index abefd7a179f7b..e6b29a35cdb24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -186,8 +186,6 @@ enum hns3_nic_state {
 #define HNS3_TXD_MSS_S				0
 #define HNS3_TXD_MSS_M				(0x3fff << HNS3_TXD_MSS_S)
 
-#define HNS3_TX_LAST_SIZE_M			0xffff
-
 #define HNS3_VECTOR_TX_IRQ			BIT_ULL(0)
 #define HNS3_VECTOR_RX_IRQ			BIT_ULL(1)
 
-- 
2.25.1



