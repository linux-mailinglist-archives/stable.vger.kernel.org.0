Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3488664AF8
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbjAJSiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbjAJSh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:37:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3B65B4AB
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:32:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC48E61864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B73C433F0;
        Tue, 10 Jan 2023 18:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375567;
        bh=Pg2FGqIHWi9kYe3FyBV8LFPemLhEwC1JLiQqyDGl4LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nw9wXMGTIgBztYXvIbQp90R+9VFi6Mx5USsriD/w4vy+Jx8I4Y+6pO1gyOLU2AW1L
         Y+zBatz5wDSM3pI5F1tNvFDEU6/qnAOGFqPl6pQe0xbhAlMPxN9yNIKyw5e6wNWJ/F
         5EOqarqWGS89HwxczCdEk0vr6eE5y811rzWAtHTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nati Koler <nkoler@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/290] net: ena: Fix toeplitz initial hash value
Date:   Tue, 10 Jan 2023 19:05:22 +0100
Message-Id: <20230110180039.964439961@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 332b49ff637d6c1a75b971022a8b992cf3c57db1 ]

On driver initialization, RSS hash initial value is set to zero,
instead of the default value. This happens because we pass NULL as
the RSS key parameter, which caused us to never initialize
the RSS hash value.

This patch fixes it by making sure the initial value is set, no matter
what the value of the RSS key is.

Fixes: 91a65b7d3ed8 ("net: ena: fix potential crash when rxfh key is NULL")
Signed-off-by: Nati Koler <nkoler@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 29 +++++++----------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index ab413fc1f68e..f0faad149a3b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2392,29 +2392,18 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return -EOPNOTSUPP;
 	}
 
-	switch (func) {
-	case ENA_ADMIN_TOEPLITZ:
-		if (key) {
-			if (key_len != sizeof(hash_key->key)) {
-				netdev_err(ena_dev->net_device,
-					   "key len (%u) doesn't equal the supported size (%zu)\n",
-					   key_len, sizeof(hash_key->key));
-				return -EINVAL;
-			}
-			memcpy(hash_key->key, key, key_len);
-			rss->hash_init_val = init_val;
-			hash_key->key_parts = key_len / sizeof(hash_key->key[0]);
+	if ((func == ENA_ADMIN_TOEPLITZ) && key) {
+		if (key_len != sizeof(hash_key->key)) {
+			netdev_err(ena_dev->net_device,
+				   "key len (%u) doesn't equal the supported size (%zu)\n",
+				   key_len, sizeof(hash_key->key));
+			return -EINVAL;
 		}
-		break;
-	case ENA_ADMIN_CRC32:
-		rss->hash_init_val = init_val;
-		break;
-	default:
-		netdev_err(ena_dev->net_device, "Invalid hash function (%d)\n",
-			   func);
-		return -EINVAL;
+		memcpy(hash_key->key, key, key_len);
+		hash_key->key_parts = key_len / sizeof(hash_key->key[0]);
 	}
 
+	rss->hash_init_val = init_val;
 	old_func = rss->hash_func;
 	rss->hash_func = func;
 	rc = ena_com_set_hash_function(ena_dev);
-- 
2.35.1



