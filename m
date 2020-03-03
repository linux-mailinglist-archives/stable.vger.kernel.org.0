Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD3D178034
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732694AbgCCRzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732090AbgCCRzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:55:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAC95206D5;
        Tue,  3 Mar 2020 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258121;
        bh=e1SKCZPdGa2avM3Ux/3r2Ge8S6FtgQ3cCJFYoRw0Vzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L041XZ+5lGmnP5b26A5GGktLNSP88tWbGPKihONYyvdLrxa8yuk/X/GHXHb0we81u
         7w/QMFrhaYbbZkNoQ83Gs4Z3mRa7zvSPhZwdVjOrhjuEcArZbnnT8WcEucAxLTj4MM
         7mj8hvbuxYEEEDtZvgLsZ9jCONL+skwDiE/FM/28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/152] net: ena: fix incorrect default RSS key
Date:   Tue,  3 Mar 2020 18:42:30 +0100
Message-Id: <20200303174308.333750993@linuxfoundation.org>
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
index e54c44fdcaa73..d6b894b06fa30 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1041,6 +1041,19 @@ static int ena_com_get_feature(struct ena_com_dev *ena_dev,
 				      feature_ver);
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
@@ -2631,6 +2644,8 @@ int ena_com_rss_init(struct ena_com_dev *ena_dev, u16 indr_tbl_log_size)
 	if (unlikely(rc))
 		goto err_hash_key;
 
+	ena_com_hash_key_fill_default_key(ena_dev);
+
 	rc = ena_com_hash_ctrl_init(ena_dev);
 	if (unlikely(rc))
 		goto err_hash_ctrl;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 0ce37d54ed108..9b5bd28ed0ac6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -44,6 +44,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/netdevice.h>
 
 #include "ena_common_defs.h"
 #include "ena_admin_defs.h"
-- 
2.20.1



