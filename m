Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE8177EC8
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgCCRqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbgCCRqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:46:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930FB20870;
        Tue,  3 Mar 2020 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257612;
        bh=/wvHWtSABa6XrGoPvgU/g74uNC1TiUDqH775k+bJX6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/Vt2wRk9bopVW4wxixvtlWgsU+cuemeBCK/bnvRtJSxG1FHHl5UHfuTOcFDtV9x/
         Fc42y78N5dENGRzG02vVvKtijTjzBzeZLCxklm3xMjSmuasxd8RZbfYFz++KnC6hd1
         w9AfCNHZQFJn/J3B/EcEa8vRYhLUcK9bdt1yUdxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 061/176] net: ena: fix corruption of dev_idx_to_host_tbl
Date:   Tue,  3 Mar 2020 18:42:05 +0100
Message-Id: <20200303174311.676580695@linuxfoundation.org>
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

[ Upstream commit e3f89f91e98ce07dc0f121a3b70d21aca749ba39 ]

The function ena_com_ind_tbl_convert_from_device() has an overflow
bug as explained below. Either way, this function is not needed at
all since we don't retrieve the indirection table from the device
at any point which means that this conversion is not needed.

The bug:
The for loop iterates over all io_sq_queues, when passing the actual
number of used queues the io_sq_queues[i].idx equals 0 since they are
uninitialized which results in the following code to be executed till
the end of the loop:

dev_idx_to_host_tbl[0] = i;

This results dev_idx_to_host_tbl[0] in being equal to
ENA_TOTAL_NUM_QUEUES - 1.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 28 -----------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 8ab192cb26b74..74743fd8a1e0a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1281,30 +1281,6 @@ static int ena_com_ind_tbl_convert_to_device(struct ena_com_dev *ena_dev)
 	return 0;
 }
 
-static int ena_com_ind_tbl_convert_from_device(struct ena_com_dev *ena_dev)
-{
-	u16 dev_idx_to_host_tbl[ENA_TOTAL_NUM_QUEUES] = { (u16)-1 };
-	struct ena_rss *rss = &ena_dev->rss;
-	u8 idx;
-	u16 i;
-
-	for (i = 0; i < ENA_TOTAL_NUM_QUEUES; i++)
-		dev_idx_to_host_tbl[ena_dev->io_sq_queues[i].idx] = i;
-
-	for (i = 0; i < 1 << rss->tbl_log_size; i++) {
-		if (rss->rss_ind_tbl[i].cq_idx > ENA_TOTAL_NUM_QUEUES)
-			return -EINVAL;
-		idx = (u8)rss->rss_ind_tbl[i].cq_idx;
-
-		if (dev_idx_to_host_tbl[idx] > ENA_TOTAL_NUM_QUEUES)
-			return -EINVAL;
-
-		rss->host_rss_ind_tbl[i] = dev_idx_to_host_tbl[idx];
-	}
-
-	return 0;
-}
-
 static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 						 u16 intr_delay_resolution)
 {
@@ -2638,10 +2614,6 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
 	if (!ind_tbl)
 		return 0;
 
-	rc = ena_com_ind_tbl_convert_from_device(ena_dev);
-	if (unlikely(rc))
-		return rc;
-
 	for (i = 0; i < (1 << rss->tbl_log_size); i++)
 		ind_tbl[i] = rss->host_rss_ind_tbl[i];
 
-- 
2.20.1



