Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBDCC17F7FD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgCJMoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgCJMoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:44:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DBE6246D8;
        Tue, 10 Mar 2020 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844245;
        bh=k/1DM/98TU/ijAoGfLniJako7x1XJ5bDAuIAfvSeJbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvoBwX7XDNwUK1q8Lh3grbfngjRkO1va8VdQzFUIbf9Ng25qlFqCZrSxYnsau+HiX
         /qkCll/+GciWB2S5oh87iPlwme/pn2/0+dRvzkvJs4uMQGOPTSrjPdDNXbVVSd+7sL
         vYF8HhNoel+FAlCh69wsPoGF/Z6jyiJODCo6kV8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/88] net: ena: fix incorrect default RSS key
Date:   Tue, 10 Mar 2020 13:38:20 +0100
Message-Id: <20200310123609.368720060@linuxfoundation.org>
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

[ Upstream commit 0d1c3de7b8c78a5e44b74b62ede4a63629f5d811 ]

Bug description:
When running "ethtool -x <if_name>" the key shows up as all zeros.

When we use "ethtool -X <if_name> hfunc toeplitz hkey <some:random:key>" to
set the key and then try to retrieve it using "ethtool -x <if_name>" then
we return the correct key because we return the one we saved.

Bug cause:
We don't fetch the key from the device but instead return the key
that we have saved internally which is by default set to zero upon
allocation.

Fix:
This commit fixes the issue by initializing the key to a random value
using netdev_rss_key_fill().

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 15 +++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_com.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index f09b7887039a2..be8a2d48c98f2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -839,6 +839,19 @@ static int ena_com_get_feature(struct ena_com_dev *ena_dev,
 				      0);
 }
 
+static void ena_com_hash_key_fill_default_key(struct ena_com_dev *ena_dev)
+{
+	struct ena_admin_feature_rss_flow_hash_control *hash_key =
+		(ena_dev->rss).hash_key;
+
+	netdev_rss_key_fill(&hash_key->key, sizeof(hash_key->key));
+	/* The key is stored in the device in u32 array
+	 * as well as the API requires the key to be passed in this
+	 * format. Thus the size of our array should be divided by 4
+	 */
+	hash_key->keys_num = sizeof(hash_key->key) / sizeof(u32);
+}
+
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
 {
 	struct ena_rss *rss = &ena_dev->rss;
@@ -2367,6 +2380,8 @@ int ena_com_rss_init(struct ena_com_dev *ena_dev, u16 indr_tbl_log_size)
 	if (unlikely(rc))
 		goto err_hash_key;
 
+	ena_com_hash_key_fill_default_key(ena_dev);
+
 	rc = ena_com_hash_ctrl_init(ena_dev);
 	if (unlikely(rc))
 		goto err_hash_ctrl;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 509d7b8e15ab9..628bf7a8fc0cb 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -41,6 +41,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/netdevice.h>
 
 #include "ena_common_defs.h"
 #include "ena_admin_defs.h"
-- 
2.20.1



