Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3BD52901F
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiEPUHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349708AbiEPUAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4532243EEC;
        Mon, 16 May 2022 12:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F3FD60ECF;
        Mon, 16 May 2022 19:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE65C385AA;
        Mon, 16 May 2022 19:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730822;
        bh=/5fSGM6N6EV85s8ReI6IjjWCeqnsuk4NSeXR+ofA39o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUP2ucCJaNPJVEOQmlXDr26IUMYbCL0XgJjJi1wXUk29/P3ygYxgiomrpu2VF1Okl
         ZOJ4DbtjyYeMI3fkeqPtUro0hjfckg3NBNww8NGm9cDke3ZHPiO8QMe6DiGJ9SQbp2
         E+R/7i5bOnYDXBeE9kXGYELu0geIWOmyy7fWdM34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Michalik <michal.michalik@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.17 017/114] ice: fix PTP stale Tx timestamps cleanup
Date:   Mon, 16 May 2022 21:35:51 +0200
Message-Id: <20220516193625.990885627@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Michalik <michal.michalik@intel.com>

[ Upstream commit a11b6c1a383ff092f432e040c20e032503785d47 ]

Read stale PTP Tx timestamps from PHY on cleanup.

After running out of Tx timestamps request handlers, hardware (HW) stops
reporting finished requests. Function ice_ptp_tx_tstamp_cleanup() used
to only clean up stale handlers in driver and was leaving the hardware
registers not read. Not reading stale PTP Tx timestamps prevents next
interrupts from arriving and makes timestamping unusable.

Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 000c39d163a2..45ae97b8b97d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2279,6 +2279,7 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 
 /**
  * ice_ptp_tx_tstamp_cleanup - Cleanup old timestamp requests that got dropped
+ * @hw: pointer to the hw struct
  * @tx: PTP Tx tracker to clean up
  *
  * Loop through the Tx timestamp requests and see if any of them have been
@@ -2287,7 +2288,7 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
  * timestamp will never be captured. This might happen if the packet gets
  * discarded before it reaches the PHY timestamping block.
  */
-static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
+static void ice_ptp_tx_tstamp_cleanup(struct ice_hw *hw, struct ice_ptp_tx *tx)
 {
 	u8 idx;
 
@@ -2296,11 +2297,16 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
 
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct sk_buff *skb;
+		u64 raw_tstamp;
 
 		/* Check if this SKB has been waiting for too long */
 		if (time_is_after_jiffies(tx->tstamps[idx].start + 2 * HZ))
 			continue;
 
+		/* Read tstamp to be able to use this register again */
+		ice_read_phy_tstamp(hw, tx->quad, idx + tx->quad_offset,
+				    &raw_tstamp);
+
 		spin_lock(&tx->lock);
 		skb = tx->tstamps[idx].skb;
 		tx->tstamps[idx].skb = NULL;
@@ -2322,7 +2328,7 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 
 	ice_ptp_update_cached_phctime(pf);
 
-	ice_ptp_tx_tstamp_cleanup(&pf->ptp.port.tx);
+	ice_ptp_tx_tstamp_cleanup(&pf->hw, &pf->ptp.port.tx);
 
 	/* Run twice a second */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
-- 
2.35.1



