Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7C84FD55C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353098AbiDLH2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351665AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ACF29C8E;
        Mon, 11 Apr 2022 23:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA655B81B35;
        Tue, 12 Apr 2022 06:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE87C385A1;
        Tue, 12 Apr 2022 06:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746268;
        bh=AGBVQlLxtLHQ/cD9D4vrrkSGguPmRNtPfuPJC9dpciY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYYJ2kNQ60I6cRUFFr9zG7b94vG7gNnEfCGIW0MJEofBSfJs3p3z4B6oJWew+LH/r
         CBh5jnckKFGQghjvzIN54Z9lJBCGzbF9sUEebB+/5ud4s28yg6by9IKDNNxq3suW7/
         maYwVklI19kgU/uhL6ZF9GmgCmhn8UkyBq9nLEtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Shwetha Nagaraju <shwetha.nagaraju@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/277] ice: synchronize_rcu() when terminating rings
Date:   Tue, 12 Apr 2022 08:29:47 +0200
Message-Id: <20220412062947.360941932@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit f9124c68f05ffdb87a47e3ea6d5fae9dad7cb6eb ]

Unfortunately, the ice driver doesn't respect the RCU critical section that
XSK wakeup is surrounded with. To fix this, add synchronize_rcu() calls to
paths that destroy resources that might be in use.

This was addressed in other AF_XDP ZC enabled drivers, for reference see
for example commit b3873a5be757 ("net/i40e: Fix concurrency issues
between config flow and XSK")

Fixes: efc2214b6047 ("ice: Add support for XDP")
Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Shwetha Nagaraju <shwetha.nagaraju@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 4 +++-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7e5daede3a2e..df65bb494695 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -552,7 +552,7 @@ static inline struct ice_pf *ice_netdev_to_pf(struct net_device *netdev)
 
 static inline bool ice_is_xdp_ena_vsi(struct ice_vsi *vsi)
 {
-	return !!vsi->xdp_prog;
+	return !!READ_ONCE(vsi->xdp_prog);
 }
 
 static inline void ice_set_ring_xdp(struct ice_ring *ring)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7f68132b8a1f..f330bd0acf9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2612,8 +2612,10 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 
 	for (i = 0; i < vsi->num_xdp_txq; i++)
 		if (vsi->xdp_rings[i]) {
-			if (vsi->xdp_rings[i]->desc)
+			if (vsi->xdp_rings[i]->desc) {
+				synchronize_rcu();
 				ice_free_tx_ring(vsi->xdp_rings[i]);
+			}
 			kfree_rcu(vsi->xdp_rings[i], rcu);
 			vsi->xdp_rings[i] = NULL;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 37c7dc6b44a9..03ba08fdcee8 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -36,8 +36,10 @@ static void ice_qp_reset_stats(struct ice_vsi *vsi, u16 q_idx)
 static void ice_qp_clean_rings(struct ice_vsi *vsi, u16 q_idx)
 {
 	ice_clean_tx_ring(vsi->tx_rings[q_idx]);
-	if (ice_is_xdp_ena_vsi(vsi))
+	if (ice_is_xdp_ena_vsi(vsi)) {
+		synchronize_rcu();
 		ice_clean_tx_ring(vsi->xdp_rings[q_idx]);
+	}
 	ice_clean_rx_ring(vsi->rx_rings[q_idx]);
 }
 
-- 
2.35.1



