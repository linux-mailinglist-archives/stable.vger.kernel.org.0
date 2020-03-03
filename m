Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572DF178053
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbgCCR4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730841AbgCCR4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B9B2072D;
        Tue,  3 Mar 2020 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258162;
        bh=Wn/4Yi/m96hOLe/jzp6H24+r/KiD9+YMjhMDtg05hG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnNb8Nck8d4GvrffsOQBhst7p5z0RQx++eZyvGgAGGlDYI2JUuKP2Prdw1ufy9i4x
         IAL2/JXZJsHbn4Ghhl/Q47wkBAOHG3IOYdr5wSq5NeDYOoDKIVoEP2t4kJuD83woJ+
         LWGYgIFoV+KYm31WmmzZVipSX87Qs/2vt3KYOYSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/152] net: ena: fix potential crash when rxfh key is NULL
Date:   Tue,  3 Mar 2020 18:42:27 +0100
Message-Id: <20200303174308.000110422@linuxfoundation.org>
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
index ea62604fdf8ca..e54c44fdcaa73 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2297,15 +2297,16 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 
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



