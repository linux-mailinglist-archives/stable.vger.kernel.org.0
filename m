Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAF52F69A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388916AbfE3E5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbfE3DJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D50A2449C;
        Thu, 30 May 2019 03:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185792;
        bh=oddKV1yeYzoI5BnCJbnLiq9Kkmk8WXXws4bnaRGvVLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKw86/bshhVvJ2xJKzc2EUO7YtzMDJhyxUVlRaDGUxsheBQIi3DHwyhP51jBB4BKm
         BEfXzrxkhrnp4+z9DCHvSMkGp6vJaIsqnNJRnaFwY7OneYJzyb0ZSfL4v5z5Nyzh1f
         0i9y2KF2IWcgVoiGBw5QvP3svwWQQxCRBHOnoHWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 065/405] net: ena: fix: set freed objects to NULL to avoid failing future allocations
Date:   Wed, 29 May 2019 20:01:03 -0700
Message-Id: <20190530030544.235021351@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8ee8ee7fe87bf64738ab4e31be036a7165608b27 ]

In some cases when a queue related allocation fails, successful past
allocations are freed but the pointer that pointed to them is not
set to NULL. This is a problem for 2 reasons:
1. This is generally a bad practice since this pointer might be
accidentally accessed in the future.
2. Future allocations using the same pointer check if the pointer
is NULL and fail if it is not.

Fixed this by setting such pointers to NULL in the allocation of
queue related objects.

Also refactored the code of ena_setup_tx_resources() to goto-style
error handling to avoid code duplication of resource freeing.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 25 ++++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 41c1c9acb3246..9b03d7e404f83 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -224,28 +224,23 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	if (!tx_ring->tx_buffer_info) {
 		tx_ring->tx_buffer_info = vzalloc(size);
 		if (!tx_ring->tx_buffer_info)
-			return -ENOMEM;
+			goto err_tx_buffer_info;
 	}
 
 	size = sizeof(u16) * tx_ring->ring_size;
 	tx_ring->free_tx_ids = vzalloc_node(size, node);
 	if (!tx_ring->free_tx_ids) {
 		tx_ring->free_tx_ids = vzalloc(size);
-		if (!tx_ring->free_tx_ids) {
-			vfree(tx_ring->tx_buffer_info);
-			return -ENOMEM;
-		}
+		if (!tx_ring->free_tx_ids)
+			goto err_free_tx_ids;
 	}
 
 	size = tx_ring->tx_max_header_size;
 	tx_ring->push_buf_intermediate_buf = vzalloc_node(size, node);
 	if (!tx_ring->push_buf_intermediate_buf) {
 		tx_ring->push_buf_intermediate_buf = vzalloc(size);
-		if (!tx_ring->push_buf_intermediate_buf) {
-			vfree(tx_ring->tx_buffer_info);
-			vfree(tx_ring->free_tx_ids);
-			return -ENOMEM;
-		}
+		if (!tx_ring->push_buf_intermediate_buf)
+			goto err_push_buf_intermediate_buf;
 	}
 
 	/* Req id ring for TX out of order completions */
@@ -259,6 +254,15 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	tx_ring->next_to_clean = 0;
 	tx_ring->cpu = ena_irq->cpu;
 	return 0;
+
+err_push_buf_intermediate_buf:
+	vfree(tx_ring->free_tx_ids);
+	tx_ring->free_tx_ids = NULL;
+err_free_tx_ids:
+	vfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+err_tx_buffer_info:
+	return -ENOMEM;
 }
 
 /* ena_free_tx_resources - Free I/O Tx Resources per Queue
@@ -378,6 +382,7 @@ static int ena_setup_rx_resources(struct ena_adapter *adapter,
 		rx_ring->free_rx_ids = vzalloc(size);
 		if (!rx_ring->free_rx_ids) {
 			vfree(rx_ring->rx_buffer_info);
+			rx_ring->rx_buffer_info = NULL;
 			return -ENOMEM;
 		}
 	}
-- 
2.20.1



