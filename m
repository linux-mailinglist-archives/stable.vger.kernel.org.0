Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB463DD8E6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhHBNzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236136AbhHBNzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C243661154;
        Mon,  2 Aug 2021 13:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912402;
        bh=m0C8kAZoPsq6olJP700FwWPh1M+fNjYI/O7wHlYoRm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+T7mhj/5sye4VwWwTKj8JH171gZOeAP3Mac7AYJlE/AdyYlUi+9DO5bkmlrHuK/T
         qDYiu93erIemFAfzDPnjBHii+sq12acvm5IonyuDIZsCQcRW9buhC0fgvqX3esrtcN
         BbujlJ7jOnBQTfZXa3qrlynWnjkQLErSoq6WtVTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/67] ionic: count csum_none when offload enabled
Date:   Mon,  2 Aug 2021 15:45:06 +0200
Message-Id: <20210802134340.483627490@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit f07f9815b7046e25cc32bf8542c9c0bbc5eb6e0e ]

Be sure to count the csum_none cases when csum offload is
enabled.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 52213fee054d..46dbb49f837c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -197,12 +197,11 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		}
 	}
 
-	if (likely(netdev->features & NETIF_F_RXCSUM)) {
-		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC) {
-			skb->ip_summed = CHECKSUM_COMPLETE;
-			skb->csum = (__force __wsum)le16_to_cpu(comp->csum);
-			stats->csum_complete++;
-		}
+	if (likely(netdev->features & NETIF_F_RXCSUM) &&
+	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC)) {
+		skb->ip_summed = CHECKSUM_COMPLETE;
+		skb->csum = (__force __wsum)le16_to_cpu(comp->csum);
+		stats->csum_complete++;
 	} else {
 		stats->csum_none++;
 	}
-- 
2.30.2



