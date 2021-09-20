Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47C2411EE4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347894AbhITRfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351472AbhITReI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:34:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EC461B1C;
        Mon, 20 Sep 2021 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157533;
        bh=0TXdpRkqGRNx4duYNjsaFZXMmm/oZ/3Wnf09RaYRU4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpAQ0c9u0UYGlArHA4nG1X+bsETkh2HIG8vcxyTIp8MjIsYQP6GK1i3pGkOXDQwbz
         C7rPVO+hrO012E/tRhyXO3Chixf5VRWio4u5/YL7aAO/xGuUQ6v2hJgPv52YxyHne2
         wN5yFIrEuYQkZxr3hbFc+iZAOXjZ4eSK7arltGQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/293] net: macb: Add a NULL check on desc_ptp
Date:   Mon, 20 Sep 2021 18:39:27 +0200
Message-Id: <20210920163933.437331699@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit 85520079afce885b80647fbd0d13d8f03d057167 ]

macb_ptp_desc will not return NULL under most circumstances with correct
Kconfig and IP design config register. But for the sake of the extreme
corner case, check for NULL when using the helper. In case of rx_tstamp,
no action is necessary except to return (similar to timestamp disabled)
and warn. In case of TX, return -EINVAL to let the skb be free. Perform
this check before marking skb in progress.
Fixes coverity warning:
(4) Event dereference:
Dereferencing a null pointer "desc_ptp"

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 8f912de44def..ecb0fb1ddde7 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -286,6 +286,12 @@ void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb,
 
 	if (GEM_BFEXT(DMA_RXVALID, desc->addr)) {
 		desc_ptp = macb_ptp_desc(bp, desc);
+		/* Unlikely but check */
+		if (!desc_ptp) {
+			dev_warn_ratelimited(&bp->pdev->dev,
+					     "Timestamp not supported in BD\n");
+			return;
+		}
 		gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
 		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamps->hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
@@ -318,8 +324,11 @@ int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb,
 	if (CIRC_SPACE(head, tail, PTP_TS_BUFFER_SIZE) == 0)
 		return -ENOMEM;
 
-	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	desc_ptp = macb_ptp_desc(queue->bp, desc);
+	/* Unlikely but check */
+	if (!desc_ptp)
+		return -EINVAL;
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	tx_timestamp = &queue->tx_timestamps[head];
 	tx_timestamp->skb = skb;
 	/* ensure ts_1/ts_2 is loaded after ctrl (TX_USED check) */
-- 
2.30.2



