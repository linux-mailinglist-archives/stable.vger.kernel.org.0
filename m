Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69112200F8D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392272AbgFSPTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390364AbgFSPR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:17:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 837F9206DB;
        Fri, 19 Jun 2020 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579847;
        bh=uyTL2Lu6aIQbzbN9xNngetGgXUNcmBdT+z3cenf8g70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPEznpxMl71i7LqyS/bK05iomjlk3hhmML8SPKLcUdkX5UgrwIqVngYXxDQ4Qhy4v
         gkXV9vusDePI2BzaYDuc1Jtj/xDSPWXyeDWG3VSKAo/rkDx2YYbF9bVvACFAARQY2Y
         UdM/0AFQEUhLkpNYkUEkDMIA3YdQK9Uil1iEgzT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 027/376] net: ena: fix error returning in ena_com_get_hash_function()
Date:   Fri, 19 Jun 2020 16:29:05 +0200
Message-Id: <20200619141711.648570465@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit e9a1de378dd46375f9abfd8de1e6f59ee114a793 ]

In case the "func" parameter is NULL we now return "-EINVAL".
This shouldn't happen in general, but when it does happen, this is the
proper way to handle it.

We also check func for NULL in the beginning of the function, as there
is no reason to do all the work and realize in the end of the function
it was useless.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index a250046b8e18..07b0f396d3c2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2345,6 +2345,9 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 		rss->hash_key;
 	int rc;
 
+	if (unlikely(!func))
+		return -EINVAL;
+
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
 				    ENA_ADMIN_RSS_HASH_FUNCTION,
 				    rss->hash_key_dma_addr,
@@ -2357,8 +2360,7 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 	if (rss->hash_func)
 		rss->hash_func--;
 
-	if (func)
-		*func = rss->hash_func;
+	*func = rss->hash_func;
 
 	if (key)
 		memcpy(key, hash_key->key, (size_t)(hash_key->keys_num) << 2);
-- 
2.25.1



