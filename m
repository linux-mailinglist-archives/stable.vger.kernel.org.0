Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC60047AF44
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhLTPKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238815AbhLTPJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EA6C07E5C7;
        Mon, 20 Dec 2021 06:55:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB88661141;
        Mon, 20 Dec 2021 14:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A50C36AE8;
        Mon, 20 Dec 2021 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012120;
        bh=ygM8k471rAYFLejb6MDMO+Pra+UQNHoOiFilkcz89dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBcbxdy86r9OlmdR6hLQ4gHZ1ZcHmQVwZdJLnhDVPLPF3L6+7IvntqKHlwZ7gmvF8
         M8zQOkbrj8CdMA/FJHuH9/OxTah227wKtU5G/KV4WNOYH4lXqrOk/58QP8GWb6mSm9
         BDlFGG4PWS+MKLOoxvI2hEcJPmvkqoN8Vmz8ePEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/177] ice: Dont put stale timestamps in the skb
Date:   Mon, 20 Dec 2021 15:33:57 +0100
Message-Id: <20211220143043.035905854@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 37e738b6fdb14529534dca441e0222313688fde3 ]

The driver has to check if it does not accidentally put the timestamp in
the SKB before previous timestamp gets overwritten.
Timestamp values in the PHY are read only and do not get cleared except
at hardware reset or when a new timestamp value is captured.
The cached_tstamp field is used to detect the case where a new timestamp
has not yet been captured, ensuring that we avoid sending stale
timestamp data to the stack.

Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 11 ++++-------
 drivers/net/ethernet/intel/ice/ice_ptp.h |  6 ++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 9df546984de25..ac27a4fe8b94c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1182,19 +1182,16 @@ static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
 		if (err)
 			continue;
 
-		/* Check if the timestamp is valid */
-		if (!(raw_tstamp & ICE_PTP_TS_VALID))
+		/* Check if the timestamp is invalid or stale */
+		if (!(raw_tstamp & ICE_PTP_TS_VALID) ||
+		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
 			continue;
 
-		/* clear the timestamp register, so that it won't show valid
-		 * again when re-used.
-		 */
-		ice_clear_phy_tstamp(hw, tx->quad, phy_idx);
-
 		/* The timestamp is valid, so we'll go ahead and clear this
 		 * index and then send the timestamp up to the stack.
 		 */
 		spin_lock(&tx->lock);
+		tx->tstamps[idx].cached_tstamp = raw_tstamp;
 		clear_bit(idx, tx->in_use);
 		skb = tx->tstamps[idx].skb;
 		tx->tstamps[idx].skb = NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index e1c787bd5b967..8cdd6f7046b73 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -46,15 +46,21 @@ struct ice_perout_channel {
  * struct ice_tx_tstamp - Tracking for a single Tx timestamp
  * @skb: pointer to the SKB for this timestamp request
  * @start: jiffies when the timestamp was first requested
+ * @cached_tstamp: last read timestamp
  *
  * This structure tracks a single timestamp request. The SKB pointer is
  * provided when initiating a request. The start time is used to ensure that
  * we discard old requests that were not fulfilled within a 2 second time
  * window.
+ * Timestamp values in the PHY are read only and do not get cleared except at
+ * hardware reset or when a new timestamp value is captured. The cached_tstamp
+ * field is used to detect the case where a new timestamp has not yet been
+ * captured, ensuring that we avoid sending stale timestamp data to the stack.
  */
 struct ice_tx_tstamp {
 	struct sk_buff *skb;
 	unsigned long start;
+	u64 cached_tstamp;
 };
 
 /**
-- 
2.33.0



