Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10CA664872
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjAJSLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbjAJSKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA7965BC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B40F6186D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2180DC433EF;
        Tue, 10 Jan 2023 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374154;
        bh=i81+vgyo5eoEMD33WPTo3oucR8Vtafk+UhU2oREnPhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTiDZEXfP2Iug9TTIHur7nCNLvyZz2NXazWTFMMSyO4siLJyia/uLvMXsGW+nQgNU
         HjzOcbiiagsmIi1Eb4xUecHPbRyBRiouHfwlwzHfMnv58ml7y1uuqwN81Yr1cfW+P6
         fhFKN4e0MPNZpvPhEHxW+A7qlGSvS+QlXDz4ccyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nati Koler <nkoler@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 064/148] net: ena: Fix toeplitz initial hash value
Date:   Tue, 10 Jan 2023 19:02:48 +0100
Message-Id: <20230110180019.260778575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
index 8c8b4c88c7de..451c3a1b6255 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2400,29 +2400,18 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
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



