Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E824B24F505
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgHXInn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729052AbgHXInn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC752074D;
        Mon, 24 Aug 2020 08:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258622;
        bh=+qJ9DRu0GxvMwF2BD+XIGfnfHZ/3jdNdQiqfxdn1Et8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4j2sNbTs9eO0Vi4VbZlvIh/tlFUVPD6mhcxrFINfMupA3N53WjSWEKtE+5I7+x6o
         laB47JA1gSbHnaNCmy0bhoiGZDB5sFAKqnMKGGpQ2jEtCcbhuxkjDIvBkmh1RGIubX
         8EAFpjS4fG8BBdLIoaekpe415fHKV+vSDMsTaHLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Agroskin <shayagr@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 112/124] net: ena: Change WARN_ON expression in ena_del_napi_in_range()
Date:   Mon, 24 Aug 2020 10:30:46 +0200
Message-Id: <20200824082414.914299559@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>

[ Upstream commit 8b147f6f3e7de4e51113e3e9ec44aa2debc02c58 ]

The ena_del_napi_in_range() function unregisters the napi handler for
rings in a given range.
This function had the following WARN_ON macro:

    WARN_ON(ENA_IS_XDP_INDEX(adapter, i) &&
	    adapter->ena_napi[i].xdp_ring);

This macro prints the call stack if the expression inside of it is
true [1], but the expression inside of it is the wanted situation.
The expression checks whether the ring has an XDP queue and its index
corresponds to a XDP one.

This patch changes the expression to
    !ENA_IS_XDP_INDEX(adapter, i) && adapter->ena_napi[i].xdp_ring
which indicates an unwanted situation.

Also, change the structure of the function. The napi handler is
unregistered for all rings, and so there's no need to check whether the
index is an XDP index or not. By removing this check the code becomes
much more readable.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index dc3fda4599242..c501a4edc34d6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2166,13 +2166,10 @@ static void ena_del_napi_in_range(struct ena_adapter *adapter,
 	int i;
 
 	for (i = first_index; i < first_index + count; i++) {
-		/* Check if napi was initialized before */
-		if (!ENA_IS_XDP_INDEX(adapter, i) ||
-		    adapter->ena_napi[i].xdp_ring)
-			netif_napi_del(&adapter->ena_napi[i].napi);
-		else
-			WARN_ON(ENA_IS_XDP_INDEX(adapter, i) &&
-				adapter->ena_napi[i].xdp_ring);
+		netif_napi_del(&adapter->ena_napi[i].napi);
+
+		WARN_ON(!ENA_IS_XDP_INDEX(adapter, i) &&
+			adapter->ena_napi[i].xdp_ring);
 	}
 }
 
-- 
2.25.1



