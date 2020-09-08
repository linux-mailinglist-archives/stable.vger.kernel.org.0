Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1175A261405
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgIHP7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 11:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730965AbgIHP5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:57:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B8222464;
        Tue,  8 Sep 2020 15:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579417;
        bh=Jw+huAHP71CeVkiBIyz7flK1ZB7LpeIb1UyLPp+X+2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRAiqaJYfnx2M0hdhWXmV40or2e7fEoTbFIRbfaM+GipG6y1CxWLJdSYW3PK4tNlZ
         ZH3WByrpVv/PB6HaLzhyNDhhPof6ZSoMrrVqQh+4wnZWr085D3/I2VZa00RwbEixpB
         v/14uZjHBwN4ETEeWk/1RWO5wTQLwEdwCkjryHxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 069/186] bnxt_en: Fix ethtool -S statitics with XDP or TCs enabled.
Date:   Tue,  8 Sep 2020 17:23:31 +0200
Message-Id: <20200908152245.002213518@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 7de651490c27ebc5edb5c7224c368bd0cd5b3862 ]

We are returning the wrong count for ETH_SS_STATS in get_sset_count()
when XDP or TCs are enabled.  In a recent commit, we got rid of
irrelevant counters when the ring is RX only or TX only, but we
did not make the proper adjustments for the count.  As a result,
when we have XDP or TCs enabled, we are returning an excess count
because some of the rings are TX only.  This causes ethtool -S to
display extra counters with no counter names.

Fix bnxt_get_num_ring_stats() by not assuming that all rings will
always have RX and TX counters in combined mode.

Fixes: 125592fbf467 ("bnxt_en: show only relevant ethtool stats for a TX or RX ring")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 309b73a665ba2..bc2c76fa54cad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -494,20 +494,13 @@ static int bnxt_get_num_tpa_ring_stats(struct bnxt *bp)
 static int bnxt_get_num_ring_stats(struct bnxt *bp)
 {
 	int rx, tx, cmn;
-	bool sh = false;
-
-	if (bp->flags & BNXT_FLAG_SHARED_RINGS)
-		sh = true;
 
 	rx = NUM_RING_RX_HW_STATS + NUM_RING_RX_SW_STATS +
 	     bnxt_get_num_tpa_ring_stats(bp);
 	tx = NUM_RING_TX_HW_STATS;
 	cmn = NUM_RING_CMN_SW_STATS;
-	if (sh)
-		return (rx + tx + cmn) * bp->cp_nr_rings;
-	else
-		return rx * bp->rx_nr_rings + tx * bp->tx_nr_rings +
-		       cmn * bp->cp_nr_rings;
+	return rx * bp->rx_nr_rings + tx * bp->tx_nr_rings +
+	       cmn * bp->cp_nr_rings;
 }
 
 static int bnxt_get_num_stats(struct bnxt *bp)
-- 
2.25.1



