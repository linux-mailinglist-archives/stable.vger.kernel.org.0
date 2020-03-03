Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301B41781D4
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732851AbgCCSGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730877AbgCCRzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:55:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F22720728;
        Tue,  3 Mar 2020 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258147;
        bh=DrogBba9msTbngHtLmWtxQahOenWiF9iZhri+C8iWa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WanNwfAm1LmUdDDybiS9QOat0XAqeJwPyvU2mq4zKKmzsgiUQqdyfZxR/tgjSLoSu
         RDhQW4DhZ8I2uPr4t8OnTvJadQnIJskm5eiEVA2nEe0lQ4WRwdWEioq9O2Ucpg7a1a
         CBKWAC4zAN5r62Nl7MCNQHzibLDPOJLrbn5bgiyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/152] net: ena: rss: do not allocate key when not supported
Date:   Tue,  3 Mar 2020 18:42:31 +0100
Message-Id: <20200303174308.456949614@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 6a4f7dc82d1e3abd3feb0c60b5041056fcd9880c ]

Currently we allocate the key whether the device supports setting the
key or not. This commit adds a check to the allocation function and
handles the error accordingly.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 24 ++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index d6b894b06fa30..6f758ece86f60 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1057,6 +1057,20 @@ static void ena_com_hash_key_fill_default_key(struct ena_com_dev *ena_dev)
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
 {
 	struct ena_rss *rss = &ena_dev->rss;
+	struct ena_admin_feature_rss_flow_hash_control *hash_key;
+	struct ena_admin_get_feat_resp get_resp;
+	int rc;
+
+	hash_key = (ena_dev->rss).hash_key;
+
+	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
+				    ENA_ADMIN_RSS_HASH_FUNCTION,
+				    ena_dev->rss.hash_key_dma_addr,
+				    sizeof(ena_dev->rss.hash_key), 0);
+	if (unlikely(rc)) {
+		hash_key = NULL;
+		return -EOPNOTSUPP;
+	}
 
 	rss->hash_key =
 		dma_alloc_coherent(ena_dev->dmadev, sizeof(*rss->hash_key),
@@ -2640,11 +2654,15 @@ int ena_com_rss_init(struct ena_com_dev *ena_dev, u16 indr_tbl_log_size)
 	if (unlikely(rc))
 		goto err_indr_tbl;
 
+	/* The following function might return unsupported in case the
+	 * device doesn't support setting the key / hash function. We can safely
+	 * ignore this error and have indirection table support only.
+	 */
 	rc = ena_com_hash_key_allocate(ena_dev);
-	if (unlikely(rc))
+	if (unlikely(rc) && rc != -EOPNOTSUPP)
 		goto err_hash_key;
-
-	ena_com_hash_key_fill_default_key(ena_dev);
+	else if (rc != -EOPNOTSUPP)
+		ena_com_hash_key_fill_default_key(ena_dev);
 
 	rc = ena_com_hash_ctrl_init(ena_dev);
 	if (unlikely(rc))
-- 
2.20.1



