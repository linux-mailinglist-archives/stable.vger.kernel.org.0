Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5F027C6AB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgI2Lra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgI2LrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E6B2083B;
        Tue, 29 Sep 2020 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380042;
        bh=g1EGPMclhwrL0wZzyYiI09ZgygyYALcabYEOu0at/SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhq87MNTfqfehtFebB5IgpEAw4cS0fLjXRcTjHZGXaunpsfDbzWC+XjtZqNXBCNcJ
         /jiDiPzAsXZsxzDP4p7sM/kj5hCRgG0DWFqcsBaWPfanPv6x6ZFwY6wmTbicRjn4cC
         u4Y3o9wsuvBEECUhM59OCKdLz24G5g/c71vM0rAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 41/99] igc: Fix not considering the TX delay for timestamps
Date:   Tue, 29 Sep 2020 13:01:24 +0200
Message-Id: <20200929105931.747257855@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 4406e977a4a1e997818b6d77c3218ef8d15b2abf ]

When timestamping a packet there's a delay between the start of the
packet and the point where the hardware actually captures the
timestamp. This difference needs to be considered if we want accurate
timestamps.

This was done on the RX side, but not on the TX side.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 61e38853aa47d..9f191a7f3c71a 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -471,12 +471,31 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	struct sk_buff *skb = adapter->ptp_tx_skb;
 	struct skb_shared_hwtstamps shhwtstamps;
 	struct igc_hw *hw = &adapter->hw;
+	int adjust = 0;
 	u64 regval;
 
 	regval = rd32(IGC_TXSTMPL);
 	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
 	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
 
+	switch (adapter->link_speed) {
+	case SPEED_10:
+		adjust = IGC_I225_TX_LATENCY_10;
+		break;
+	case SPEED_100:
+		adjust = IGC_I225_TX_LATENCY_100;
+		break;
+	case SPEED_1000:
+		adjust = IGC_I225_TX_LATENCY_1000;
+		break;
+	case SPEED_2500:
+		adjust = IGC_I225_TX_LATENCY_2500;
+		break;
+	}
+
+	shhwtstamps.hwtstamp =
+		ktime_add_ns(shhwtstamps.hwtstamp, adjust);
+
 	/* Clear the lock early before calling skb_tstamp_tx so that
 	 * applications are not woken up before the lock bit is clear. We use
 	 * a copy of the skb pointer to ensure other threads can't change it
-- 
2.25.1



