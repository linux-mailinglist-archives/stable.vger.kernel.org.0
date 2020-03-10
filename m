Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7517FE67
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgCJNfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgCJMp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:45:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8072246A3;
        Tue, 10 Mar 2020 12:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844326;
        bh=b3a7LXAN/jY9XCOOcUPYLK2gXw1etQtmbR5yY1H325s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViSAN+YpLY8yUfVT8jn4pAQbOqPn/Y1QGZmUeJucIZVza2x4qCgomd39fQXxYXIFM
         AJ54OcIOBfuAKOCoMa4ZJX6AaZY1ZfnY7ceX2lFZG5YK76hS+di5iPkjcfhI782HEE
         yQzhmWMt3l1FG+UGrBxCGpGHQ10AJzGfRvcMrvZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 41/88] net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE
Date:   Tue, 10 Mar 2020 13:38:49 +0100
Message-Id: <20200310123615.977525680@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

commit 470793a78ce344bd53d31e0c2d537f71ba957547 upstream.

As the name suggests ETH_RSS_HASH_NO_CHANGE is received upon changing
the key or indirection table using ethtool while keeping the same hash
function.

Also add a function for retrieving the current hash function from
the ena-com layer.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Saeed Bshara <saeedb@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/amazon/ena/ena_com.c     |    5 +++++
 drivers/net/ethernet/amazon/ena/ena_com.h     |    8 ++++++++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |    3 +++
 3 files changed, 16 insertions(+)

--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -857,6 +857,11 @@ static void ena_com_hash_key_fill_defaul
 	hash_key->keys_num = sizeof(hash_key->key) / sizeof(u32);
 }
 
+int ena_com_get_current_hash_function(struct ena_com_dev *ena_dev)
+{
+	return ena_dev->rss.hash_func;
+}
+
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
 {
 	struct ena_rss *rss = &ena_dev->rss;
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -623,6 +623,14 @@ int ena_com_rss_init(struct ena_com_dev
  */
 void ena_com_rss_destroy(struct ena_com_dev *ena_dev);
 
+/* ena_com_get_current_hash_function - Get RSS hash function
+ * @ena_dev: ENA communication layer struct
+ *
+ * Return the current hash function.
+ * @return: 0 or one of the ena_admin_hash_functions values.
+ */
+int ena_com_get_current_hash_function(struct ena_com_dev *ena_dev);
+
 /* ena_com_fill_hash_function - Fill RSS hash function
  * @ena_dev: ENA communication layer struct
  * @func: The hash function (Toeplitz or crc)
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -751,6 +751,9 @@ static int ena_set_rxfh(struct net_devic
 	}
 
 	switch (hfunc) {
+	case ETH_RSS_HASH_NO_CHANGE:
+		func = ena_com_get_current_hash_function(ena_dev);
+		break;
 	case ETH_RSS_HASH_TOP:
 		func = ENA_ADMIN_TOEPLITZ;
 		break;


