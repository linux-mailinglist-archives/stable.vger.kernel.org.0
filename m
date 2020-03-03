Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7F917806F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbgCCR4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:56:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732962AbgCCR4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC6120656;
        Tue,  3 Mar 2020 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258204;
        bh=I4Gf8slb2n8tPWEyQEcec+l/JX2CkkOdb3AmE9CO1OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9hIqTf89BdocGNkxqrDg8UvM9ixTkG2HeBFdRbDrytmAajHUo0GDYtb0lIosro2s
         VMsE/CyLqhn6pfMzRIVOL+c+ggviSpnGoWEMfnn/9apLXGM7eEG8aviTtn/GNnkYI2
         /AfjurMcdpw/z2TMTSyvTAE5skI4kxqIJEb6qZWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 111/152] net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE
Date:   Tue,  3 Mar 2020 18:43:29 +0100
Message-Id: <20200303174315.366817258@linuxfoundation.org>
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
@@ -1059,6 +1059,11 @@ static void ena_com_hash_key_fill_defaul
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
@@ -656,6 +656,14 @@ int ena_com_rss_init(struct ena_com_dev
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
@@ -736,6 +736,9 @@ static int ena_set_rxfh(struct net_devic
 	}
 
 	switch (hfunc) {
+	case ETH_RSS_HASH_NO_CHANGE:
+		func = ena_com_get_current_hash_function(ena_dev);
+		break;
 	case ETH_RSS_HASH_TOP:
 		func = ENA_ADMIN_TOEPLITZ;
 		break;


