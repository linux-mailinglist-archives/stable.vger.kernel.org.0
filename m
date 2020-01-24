Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1A414815E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390502AbgAXLTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:19:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390773AbgAXLTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:19:20 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CDA120704;
        Fri, 24 Jan 2020 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864760;
        bh=xNe8SbaqIwlAm/s478LjA2GxEsdSf+skVhQoiiGm8X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkyyk4jX+As5aG+Hn3rOAfIdDAoo8tfC3VsnQjnPl45CvLtJEt8RYiEj/p90v+pKP
         hwXEu81pkMknYQ9e2TnqS4eUvXXzyUKIBzVcYw3Sv9U8OWLVLQHr9Xi+yUoXk8uR81
         YXAvpxtHh0wljZQ1ZoWCkS83u7ylc38gKIcyxZaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Bshara <saeedb@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 345/639] net: ena: fix swapped parameters when calling ena_com_indirect_table_fill_entry
Date:   Fri, 24 Jan 2020 10:28:35 +0100
Message-Id: <20200124093130.339121896@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 3c6eeff295f01bdf1c6c3addcb0a04c0c6c029e9 ]

second parameter should be the index of the table rather than the value.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Saeed Bshara <saeedb@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 521607bc43937..eb9e07fa427ee 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -695,8 +695,8 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	if (indir) {
 		for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++) {
 			rc = ena_com_indirect_table_fill_entry(ena_dev,
-							       ENA_IO_RXQ_IDX(indir[i]),
-							       i);
+							       i,
+							       ENA_IO_RXQ_IDX(indir[i]));
 			if (unlikely(rc)) {
 				netif_err(adapter, drv, netdev,
 					  "Cannot fill indirect table (index is too large)\n");
-- 
2.20.1



