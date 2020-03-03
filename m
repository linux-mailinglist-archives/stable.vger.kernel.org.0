Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5901780D8
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbgCCR7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:59:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733082AbgCCR7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:59:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0381C20656;
        Tue,  3 Mar 2020 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258347;
        bh=3e93H9hKUcz5QbUSGjf9au83mTkA3AVksZMm/ZBw/qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Po9Quhtf6qVyHmvclFdfvuIZiOeyR7APE3ycG5Yzx+JrSkUkQlemK1Vufa06Mpbc9
         1J1WHQcmmj5iTM/dr/g7eV3I2j6enXrDE1/OzFf4R02TVuAm9xMI79j0gR7OgPTs6S
         Q0DDPPZerl8LEFZNDdR0RxtgRZ0/jygYRomOF5Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/87] net: ena: fix potential crash when rxfh key is NULL
Date:   Tue,  3 Mar 2020 18:43:06 +0100
Message-Id: <20200303174350.925745996@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 91a65b7d3ed8450f31ab717a65dcb5f9ceb5ab02 ]

When ethtool -X is called without an hkey, ena_com_fill_hash_function()
is called with key=NULL, which is passed to memcpy causing a crash.

This commit fixes this issue by checking key is not NULL.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 92261c946e2a3..c9b21306cf6c4 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2075,15 +2075,16 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 
 	switch (func) {
 	case ENA_ADMIN_TOEPLITZ:
-		if (key_len > sizeof(hash_key->key)) {
-			pr_err("key len (%hu) is bigger than the max supported (%zu)\n",
-			       key_len, sizeof(hash_key->key));
-			return -EINVAL;
+		if (key) {
+			if (key_len != sizeof(hash_key->key)) {
+				pr_err("key len (%hu) doesn't equal the supported size (%zu)\n",
+				       key_len, sizeof(hash_key->key));
+				return -EINVAL;
+			}
+			memcpy(hash_key->key, key, key_len);
+			rss->hash_init_val = init_val;
+			hash_key->keys_num = key_len >> 2;
 		}
-
-		memcpy(hash_key->key, key, key_len);
-		rss->hash_init_val = init_val;
-		hash_key->keys_num = key_len >> 2;
 		break;
 	case ENA_ADMIN_CRC32:
 		rss->hash_init_val = init_val;
-- 
2.20.1



