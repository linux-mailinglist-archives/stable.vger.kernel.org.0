Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838FA531B61
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240677AbiEWRde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240318AbiEWRZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3697282168;
        Mon, 23 May 2022 10:20:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4147610E8;
        Mon, 23 May 2022 17:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE4BC385A9;
        Mon, 23 May 2022 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326452;
        bh=VJK7TwURwrK0TLfXEBbhNwto/77OQeC3hI0AX6HaA5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxT4/8DpmMnJnPp/puMFT5p97iVPSckChdMDo2cJFOOSos+z2b6qLydEO5K8tbxhQ
         tNuqql1GGy2d+UIQZX4qNdKTci63TkXnybqZyEaWceFElFKMCflC+vgy5V56nP/J2C
         7RO8ouHQTnNfxu87sVKYE9Urpa8Aewkzmt6/7Uws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.15 086/132] ice: Fix interrupt moderation settings getting cleared
Date:   Mon, 23 May 2022 19:04:55 +0200
Message-Id: <20220523165837.348246556@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Wilczynski <michal.wilczynski@intel.com>

[ Upstream commit bf13502ed5f941b0777b3fd1e24dac5d93f3886c ]

Adaptive-rx and Adaptive-tx are interrupt moderation settings
that can be enabled/disabled using ethtool:
ethtool -C ethX adaptive-rx on/off adaptive-tx on/off

Unfortunately those settings are getting cleared after
changing number of queues, or in ethtool world 'channels':
ethtool -L ethX rx 1 tx 1

Clearing was happening due to introduction of bit fields
in ice_ring_container struct. This way only itr_setting
bits were rebuilt during ice_vsi_rebuild_set_coalesce().

Introduce an anonymous struct of bitfields and create a
union to refer to them as a single variable.
This way variable can be easily saved and restored.

Fixes: 61dc79ced7aa ("ice: Restore interrupt throttle settings after VSI rebuild")
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 16 ++++++++--------
 drivers/net/ethernet/intel/ice/ice_txrx.h | 11 ++++++++---
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 653996e8fd30..4417238b0e64 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2980,8 +2980,8 @@ ice_vsi_rebuild_get_coalesce(struct ice_vsi *vsi,
 	ice_for_each_q_vector(vsi, i) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 
-		coalesce[i].itr_tx = q_vector->tx.itr_setting;
-		coalesce[i].itr_rx = q_vector->rx.itr_setting;
+		coalesce[i].itr_tx = q_vector->tx.itr_settings;
+		coalesce[i].itr_rx = q_vector->rx.itr_settings;
 		coalesce[i].intrl = q_vector->intrl;
 
 		if (i < vsi->num_txq)
@@ -3037,21 +3037,21 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 		 */
 		if (i < vsi->alloc_rxq && coalesce[i].rx_valid) {
 			rc = &vsi->q_vectors[i]->rx;
-			rc->itr_setting = coalesce[i].itr_rx;
+			rc->itr_settings = coalesce[i].itr_rx;
 			ice_write_itr(rc, rc->itr_setting);
 		} else if (i < vsi->alloc_rxq) {
 			rc = &vsi->q_vectors[i]->rx;
-			rc->itr_setting = coalesce[0].itr_rx;
+			rc->itr_settings = coalesce[0].itr_rx;
 			ice_write_itr(rc, rc->itr_setting);
 		}
 
 		if (i < vsi->alloc_txq && coalesce[i].tx_valid) {
 			rc = &vsi->q_vectors[i]->tx;
-			rc->itr_setting = coalesce[i].itr_tx;
+			rc->itr_settings = coalesce[i].itr_tx;
 			ice_write_itr(rc, rc->itr_setting);
 		} else if (i < vsi->alloc_txq) {
 			rc = &vsi->q_vectors[i]->tx;
-			rc->itr_setting = coalesce[0].itr_tx;
+			rc->itr_settings = coalesce[0].itr_tx;
 			ice_write_itr(rc, rc->itr_setting);
 		}
 
@@ -3065,12 +3065,12 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 	for (; i < vsi->num_q_vectors; i++) {
 		/* transmit */
 		rc = &vsi->q_vectors[i]->tx;
-		rc->itr_setting = coalesce[0].itr_tx;
+		rc->itr_settings = coalesce[0].itr_tx;
 		ice_write_itr(rc, rc->itr_setting);
 
 		/* receive */
 		rc = &vsi->q_vectors[i]->rx;
-		rc->itr_setting = coalesce[0].itr_rx;
+		rc->itr_settings = coalesce[0].itr_rx;
 		ice_write_itr(rc, rc->itr_setting);
 
 		vsi->q_vectors[i]->intrl = coalesce[0].intrl;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 69f78a1c234f..4adc3dff04ba 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -345,9 +345,14 @@ struct ice_ring_container {
 	/* this matches the maximum number of ITR bits, but in usec
 	 * values, so it is shifted left one bit (bit zero is ignored)
 	 */
-	u16 itr_setting:13;
-	u16 itr_reserved:2;
-	u16 itr_mode:1;
+	union {
+		struct {
+			u16 itr_setting:13;
+			u16 itr_reserved:2;
+			u16 itr_mode:1;
+		};
+		u16 itr_settings;
+	};
 	enum ice_container_type type;
 };
 
-- 
2.35.1



