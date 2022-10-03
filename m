Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D07A5F29E8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiJCH1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiJCH1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:27:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B884C422E9;
        Mon,  3 Oct 2022 00:18:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48FEBB80E7D;
        Mon,  3 Oct 2022 07:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7BCC433D6;
        Mon,  3 Oct 2022 07:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781400;
        bh=Igf9UU74ITk1IWqdl+JkpDC1/G783bDledmbtt7/jcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoLPGvJ12UFYkOTibZ8vA3VZ7uBHO+MNcv2W8xfsDqEKOZ0B5cHRLLWTX245/zbu3
         De8njpQhnGGCMEiIFDMDQvf4V3704/hOfvVuhcZGOThN7P9PPvaW8O/C8SggtiX9bA
         qnPB/TDn3j7x/c9Vhoi+cbQjUHkP0WOKJOl8aAjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alasdair McWilliam <alasdair.mcwilliam@outlook.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 085/101] ice: xsk: drop power of 2 ring size restriction for AF_XDP
Date:   Mon,  3 Oct 2022 09:11:21 +0200
Message-Id: <20221003070726.563402354@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit b3056ae2b57858b02b376b3fed6077040caf14b4 ]

We had multiple customers in the past months that reported commit
296f13ff3854 ("ice: xsk: Force rings to be sized to power of 2")
makes them unable to use ring size of 8160 in conjunction with AF_XDP.
Remove this restriction.

Fixes: 296f13ff3854 ("ice: xsk: Force rings to be sized to power of 2")
CC: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 8833b66b4e54..056c904b83cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -392,13 +392,6 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 		goto failure;
 	}
 
-	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
-	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
-		netdev_err(vsi->netdev, "Please align ring sizes to power of 2\n");
-		pool_failure = -EINVAL;
-		goto failure;
-	}
-
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
 	if (if_running) {
@@ -534,11 +527,10 @@ static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 {
 	u16 rx_thresh = ICE_RING_QUARTER(rx_ring);
-	u16 batched, leftover, i, tail_bumps;
+	u16 leftover, i, tail_bumps;
 
-	batched = ALIGN_DOWN(count, rx_thresh);
-	tail_bumps = batched / rx_thresh;
-	leftover = count & (rx_thresh - 1);
+	tail_bumps = count / rx_thresh;
+	leftover = count - (tail_bumps * rx_thresh);
 
 	for (i = 0; i < tail_bumps; i++)
 		if (!__ice_alloc_rx_bufs_zc(rx_ring, rx_thresh))
@@ -1037,14 +1029,16 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
  */
 void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 {
-	u16 count_mask = rx_ring->count - 1;
 	u16 ntc = rx_ring->next_to_clean;
 	u16 ntu = rx_ring->next_to_use;
 
-	for ( ; ntc != ntu; ntc = (ntc + 1) & count_mask) {
+	while (ntc != ntu) {
 		struct xdp_buff *xdp = *ice_xdp_buf(rx_ring, ntc);
 
 		xsk_buff_free(xdp);
+		ntc++;
+		if (ntc >= rx_ring->count)
+			ntc = 0;
 	}
 }
 
-- 
2.35.1



