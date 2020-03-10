Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56B617FA8D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgCJNGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgCJNGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:06:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 890BB208E4;
        Tue, 10 Mar 2020 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845562;
        bh=NMUthfhve5dk4Fxr53AUfDVdU9WEEE2r2cZ48UukxO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeKd2csFKvZHyNam2risXQznAcCBNA2b2/Ava7zBoOHBuY4D5EecrH1T+QPrYH8Pm
         eO3CdDqVTez+IIf5YRtvxuy3i1YFrilsniUL3VbJfmuUmrjQ/PWo5zJA3LLYaP3YNP
         pO5gi+ZvZf6yR5Lmr1zCu6cFNy4w7Vl+hankROio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 020/126] net: ena: ethtool: use correct value for crc32 hash
Date:   Tue, 10 Mar 2020 13:40:41 +0100
Message-Id: <20200310124205.633622431@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 886d2089276e40d460731765083a741c5c762461 ]

Up till kernel 4.11 there was no enum defined for crc32 hash in ethtool,
thus the xor enum was used for supporting crc32.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 9601ddc274274..22238f25e0713 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -705,7 +705,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		func = ETH_RSS_HASH_TOP;
 		break;
 	case ENA_ADMIN_CRC32:
-		func = ETH_RSS_HASH_XOR;
+		func = ETH_RSS_HASH_CRC32;
 		break;
 	default:
 		netif_err(adapter, drv, netdev,
@@ -751,7 +751,7 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	case ETH_RSS_HASH_TOP:
 		func = ENA_ADMIN_TOEPLITZ;
 		break;
-	case ETH_RSS_HASH_XOR:
+	case ETH_RSS_HASH_CRC32:
 		func = ENA_ADMIN_CRC32;
 		break;
 	default:
-- 
2.20.1



