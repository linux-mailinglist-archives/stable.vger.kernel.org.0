Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B55177EC1
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgCCRqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731222AbgCCRqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:46:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB17B20870;
        Tue,  3 Mar 2020 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257604;
        bh=t3RTH/1EKJs2kaKk4nsQZy3sCwlomYb2ILJy2SmbQ94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIY0BI02ifxctRPI/XjSpsOmGu2St6Lxo4SNw7a6thBnX9lKZ9GdZUHT2OogcM65Z
         0f3B2E/Hhv5He5C1ulZOW4kTXhrMjZqPo2x44G1fvR1ozH0jMTS7PrjJR4rjxThKy7
         Mgu3ato0pFvZ14s2HwOQX0aN0rRXhfnp+akmTZKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 058/176] net: ena: rss: fix failure to get indirection table
Date:   Tue,  3 Mar 2020 18:42:02 +0100
Message-Id: <20200303174311.293027134@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 0c8923c0a64fb5d14bebb9a9065d2dc25ac5e600 ]

On old hardware, getting / setting the hash function is not supported while
gettting / setting the indirection table is.

This commit enables us to still show the indirection table on older
hardwares by setting the hash function and key to NULL.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 8b56383b64aea..8be9df885bf4f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -648,7 +648,21 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	if (rc)
 		return rc;
 
+	/* We call this function in order to check if the device
+	 * supports getting/setting the hash function.
+	 */
 	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func, key);
+
+	if (rc) {
+		if (rc == -EOPNOTSUPP) {
+			key = NULL;
+			hfunc = NULL;
+			rc = 0;
+		}
+
+		return rc;
+	}
+
 	if (rc)
 		return rc;
 
-- 
2.20.1



