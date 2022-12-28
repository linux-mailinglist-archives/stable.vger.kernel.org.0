Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5170865849D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiL1Q6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiL1Q6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:58:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BA320193
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC69B8188D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949D6C433F0;
        Wed, 28 Dec 2022 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246459;
        bh=B6WGf5Mz8SgeST3xpYSXXRbwW/Ae6pRLshq8wjtPeVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddyI287lmblXM19mGw75V7kpyk8CDrrbxVW9npzzusptA1tbPWanV1XhQOIAAnNqi
         dh0eWaGPG/6cz5Khfg3wsROc8ieam+rEcWDUpA+I/ZV1WtXh0ow8O0MzQZCGrDHPWJ
         v6iKJQzSJOuc8QZu1PzBSITh4xETqsqt+UANKpa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 1045/1146] ice: synchronize the misc IRQ when tearing down Tx tracker
Date:   Wed, 28 Dec 2022 15:43:04 +0100
Message-Id: <20221228144358.713924763@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit f0ae124019faaa03f8b4c3fbe52ae35ab3a8dbda ]

Since commit 1229b33973c7 ("ice: Add low latency Tx timestamp read") the
ice driver has used a threaded IRQ for handling Tx timestamps. This change
did not add a call to synchronize_irq during ice_ptp_release_tx_tracker.
Thus it is possible that an interrupt could occur just as the tracker is
being removed. This could lead to a use-after-free of the Tx tracker
structure data.

Fix this by calling sychronize_irq in ice_ptp_release_tx_tracker after
we've cleared the init flag. In addition, make sure that we re-check the
init flag at the end of ice_ptp_tx_tstamp before we exit ensuring that we
will stop polling for new timestamps once the tracker de-initialization has
begun.

Refactor the ts_handled variable into "more_timestamps" so that we can
simply directly assign this boolean instead of relying on an initialized
value of true. This makes the new combined check easier to read.

With this change, the ice_ptp_release_tx_tracker function will now wait for
the threaded interrupt to complete if it was executing while the init flag
was cleared.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 0f668468d141..53fec5bbe6e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -639,7 +639,7 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
 static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 {
 	struct ice_ptp_port *ptp_port;
-	bool ts_handled = true;
+	bool more_timestamps;
 	struct ice_pf *pf;
 	u8 idx;
 
@@ -701,11 +701,10 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	 * poll for remaining timestamps.
 	 */
 	spin_lock(&tx->lock);
-	if (!bitmap_empty(tx->in_use, tx->len))
-		ts_handled = false;
+	more_timestamps = tx->init && !bitmap_empty(tx->in_use, tx->len);
 	spin_unlock(&tx->lock);
 
-	return ts_handled;
+	return !more_timestamps;
 }
 
 /**
@@ -776,6 +775,9 @@ ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
 	tx->init = 0;
 
+	/* wait for potentially outstanding interrupt to complete */
+	synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
+
 	ice_ptp_flush_tx_tracker(pf, tx);
 
 	kfree(tx->tstamps);
-- 
2.35.1



