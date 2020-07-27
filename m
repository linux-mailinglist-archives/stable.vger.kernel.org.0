Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA5C22F155
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgG0Obd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731559AbgG0OUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396952070B;
        Mon, 27 Jul 2020 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859632;
        bh=sq93jyy/5hOdO3MnMsnMTGHwVKWz45e3z6SC8rJ91ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGF9kBsQzfwrshmyXGcRyBzExtl1uqrrPy1O2WOeHJieZrnLOyQb4tqqn6/p+j02g
         V1kSKiL14mxWtznxwRkf7Ne6ES57S58DhcBxCwmKx66Bv3myXibGkKUCBWhBZ7AiTD
         J9XM3Jceiv2aRMEqglchCDZPbVtAqtIVu/GVELHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 045/179] bnxt_en: Fix completion ring sizing with TPA enabled.
Date:   Mon, 27 Jul 2020 16:03:40 +0200
Message-Id: <20200727134934.874432975@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 27640ce68d21e556b66bc5fa022aacd26e53c947 ]

The current completion ring sizing formula is wrong with TPA enabled.
The formula assumes that the number of TPA completions are bound by the
RX ring size, but that's not true.  TPA_START completions are immediately
recycled so they are not bound by the RX ring size.  We must add
bp->max_tpa to the worst case maximum RX and TPA completions.

The completion ring can overflow because of this mistake.  This will
cause hardware to disable the completion ring when this happens,
leading to RX and TX traffic to stall on that ring.  This issue is
generally exposed only when the RX ring size is set very small.

Fix the formula by adding bp->max_tpa to the number of RX completions
if TPA is enabled.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.");
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 198bca9c1e2df..1656dc277af41 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3418,7 +3418,7 @@ void bnxt_set_tpa_flags(struct bnxt *bp)
  */
 void bnxt_set_ring_params(struct bnxt *bp)
 {
-	u32 ring_size, rx_size, rx_space;
+	u32 ring_size, rx_size, rx_space, max_rx_cmpl;
 	u32 agg_factor = 0, agg_ring_size = 0;
 
 	/* 8 for CRC and VLAN */
@@ -3474,7 +3474,15 @@ void bnxt_set_ring_params(struct bnxt *bp)
 	bp->tx_nr_pages = bnxt_calc_nr_ring_pages(ring_size, TX_DESC_CNT);
 	bp->tx_ring_mask = (bp->tx_nr_pages * TX_DESC_CNT) - 1;
 
-	ring_size = bp->rx_ring_size * (2 + agg_factor) + bp->tx_ring_size;
+	max_rx_cmpl = bp->rx_ring_size;
+	/* MAX TPA needs to be added because TPA_START completions are
+	 * immediately recycled, so the TPA completions are not bound by
+	 * the RX ring size.
+	 */
+	if (bp->flags & BNXT_FLAG_TPA)
+		max_rx_cmpl += bp->max_tpa;
+	/* RX and TPA completions are 32-byte, all others are 16-byte */
+	ring_size = max_rx_cmpl * 2 + agg_ring_size + bp->tx_ring_size;
 	bp->cp_ring_size = ring_size;
 
 	bp->cp_nr_pages = bnxt_calc_nr_ring_pages(ring_size, CP_DESC_CNT);
-- 
2.25.1



