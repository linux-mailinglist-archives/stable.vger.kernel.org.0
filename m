Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476863DD9EF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhHBOFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236175AbhHBOEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BED56121E;
        Mon,  2 Aug 2021 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912659;
        bh=zekbjAEzmKogv8HgFlDiu0zRaMcTYJiEcQ98we9uW7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybY1JrDpI9YLxBgmWaw4Gq+q2D2D6ClYaMp4ESvvjD3Qa8lgOtxJwXCTVl1Z3CQnU
         AVHVnZ6/VycML6OG2keCvb2JZinwWLcip7EFLoeCsTb6hloDi/kMVeFHoEBUW3Fi+a
         J5mKW6l0ZFPujJcnUXY7M5ITfPVG2GT8Lmi3QXhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 059/104] ionic: count csum_none when offload enabled
Date:   Mon,  2 Aug 2021 15:44:56 +0200
Message-Id: <20210802134345.945753655@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
index 1c6e2b9fc96b..08870190e4d2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -274,12 +274,11 @@ static void ionic_rx_clean(struct ionic_queue *q,
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



