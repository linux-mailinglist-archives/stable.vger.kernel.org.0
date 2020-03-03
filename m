Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D88177EC6
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgCCRqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:46:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbgCCRqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:46:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08A312146E;
        Tue,  3 Mar 2020 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257609;
        bh=9PwNu2g7oUKKYUVITgy4zOf2x0VPzKjJy7pC1BQMiC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wS+MDIk/mpvWqcNIGUsWaY4jzAMDz/Jv8DRDygxLVxvEIVMrqvATn8tOJIOqYEEcS
         lJJ+hvhMqCf3MH0SFLR1q1/A1das4glYuf5nCH3mFvl7xAlO4IRu1y1ZJhh8+BhIu7
         PvsrAn6g4WC+NQqIbTRMmvpfPUjUIWovBIPZgfkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 060/176] net: ena: fix incorrectly saving queue numbers when setting RSS indirection table
Date:   Tue,  3 Mar 2020 18:42:04 +0100
Message-Id: <20200303174311.530512580@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 92569fd27f5cb0ccbdf7c7d70044b690e89a0277 ]

The indirection table has the indices of the Rx queues. When we store it
during set indirection operation, we convert the indices to our internal
representation of the indices.

Our internal representation of the indices is: even indices for Tx and
uneven indices for Rx, where every Tx/Rx pair are in a consecutive order
starting from 0. For example if the driver has 3 queues (3 for Tx and 3
for Rx) then the indices are as follows:
0  1  2  3  4  5
Tx Rx Tx Rx Tx Rx

The BUG:
The issue is that when we satisfy a get request for the indirection
table, we don't convert the indices back to the original representation.

The FIX:
Simply apply the inverse function for the indices of the indirection
table after we set it.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 24 ++++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 ++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 8be9df885bf4f..610a7c63e1742 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -636,6 +636,28 @@ static u32 ena_get_rxfh_key_size(struct net_device *netdev)
 	return ENA_HASH_KEY_SIZE;
 }
 
+static int ena_indirection_table_get(struct ena_adapter *adapter, u32 *indir)
+{
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	int i, rc;
+
+	if (!indir)
+		return 0;
+
+	rc = ena_com_indirect_table_get(ena_dev, indir);
+	if (rc)
+		return rc;
+
+	/* Our internal representation of the indices is: even indices
+	 * for Tx and uneven indices for Rx. We need to convert the Rx
+	 * indices to be consecutive
+	 */
+	for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++)
+		indir[i] = ENA_IO_RXQ_IDX_TO_COMBINED_IDX(indir[i]);
+
+	return rc;
+}
+
 static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 			u8 *hfunc)
 {
@@ -644,7 +666,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	u8 func;
 	int rc;
 
-	rc = ena_com_indirect_table_get(adapter->ena_dev, indir);
+	rc = ena_indirection_table_get(adapter, indir);
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index bffd778f2ce34..2fe5eeea6b695 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -129,6 +129,8 @@
 
 #define ENA_IO_TXQ_IDX(q)	(2 * (q))
 #define ENA_IO_RXQ_IDX(q)	(2 * (q) + 1)
+#define ENA_IO_TXQ_IDX_TO_COMBINED_IDX(q)	((q) / 2)
+#define ENA_IO_RXQ_IDX_TO_COMBINED_IDX(q)	(((q) - 1) / 2)
 
 #define ENA_MGMNT_IRQ_IDX		0
 #define ENA_IO_IRQ_FIRST_IDX		1
-- 
2.20.1



