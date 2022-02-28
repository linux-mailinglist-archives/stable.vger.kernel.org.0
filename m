Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAE64C75DC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiB1R4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbiB1Ryr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BC05FC6;
        Mon, 28 Feb 2022 09:44:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B62E7CE17E9;
        Mon, 28 Feb 2022 17:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD9CC340FB;
        Mon, 28 Feb 2022 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070270;
        bh=fztsZQE20ylFt2BY88p8IK/HVJS33e0NcUsKZ+xpejw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJbY5cipYMu4pmS/BEY6DIBNd3kVBw4QkIC7OXJ9DBy4+w4WBdJqQwA7xmRRQ8pjm
         VJlcvONljiJFTg8CFDTxqxhCwJx5KF3jWCb9JOSQ+HQ2dVbWKNpvju5zOT2CSVSCQn
         u64zd7EiTISr7ieJK6QcTDkdsOsjI1xFVPvO8pFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 047/164] bnxt_en: Fix incorrect multicast rx mask setting when not requested
Date:   Mon, 28 Feb 2022 18:23:29 +0100
Message-Id: <20220228172404.502173640@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

commit 8cdb15924252e27af16c4a8fe0fc606ce5fd04dc upstream.

We should setup multicast only when net_device flags explicitly
has IFF_MULTICAST set. Otherwise we will incorrectly turn it on
even when not asked.  Fix it by only passing the multicast table
to the firmware if IFF_MULTICAST is set.

Fixes: 7d2837dd7a32 ("bnxt_en: Setup multicast properly after resetting device.")
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4719,8 +4719,10 @@ static int bnxt_hwrm_cfa_l2_set_rx_mask(
 		return rc;
 
 	req->vnic_id = cpu_to_le32(vnic->fw_vnic_id);
-	req->num_mc_entries = cpu_to_le32(vnic->mc_list_count);
-	req->mc_tbl_addr = cpu_to_le64(vnic->mc_list_mapping);
+	if (vnic->rx_mask & CFA_L2_SET_RX_MASK_REQ_MASK_MCAST) {
+		req->num_mc_entries = cpu_to_le32(vnic->mc_list_count);
+		req->mc_tbl_addr = cpu_to_le64(vnic->mc_list_mapping);
+	}
 	req->mask = cpu_to_le32(vnic->rx_mask);
 	return hwrm_req_send_silent(bp, req);
 }
@@ -8635,7 +8637,7 @@ static int bnxt_init_chip(struct bnxt *b
 	if (bp->dev->flags & IFF_ALLMULTI) {
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
-	} else {
+	} else if (bp->dev->flags & IFF_MULTICAST) {
 		u32 mask = 0;
 
 		bnxt_mc_list_updated(bp, &mask);
@@ -10759,7 +10761,7 @@ static void bnxt_set_rx_mode(struct net_
 	if (dev->flags & IFF_ALLMULTI) {
 		mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
-	} else {
+	} else if (dev->flags & IFF_MULTICAST) {
 		mc_update = bnxt_mc_list_updated(bp, &mask);
 	}
 
@@ -10827,9 +10829,10 @@ skip_uc:
 	    !bnxt_promisc_ok(bp))
 		vnic->rx_mask &= ~CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS;
 	rc = bnxt_hwrm_cfa_l2_set_rx_mask(bp, 0);
-	if (rc && vnic->mc_list_count) {
+	if (rc && (vnic->rx_mask & CFA_L2_SET_RX_MASK_REQ_MASK_MCAST)) {
 		netdev_info(bp->dev, "Failed setting MC filters rc: %d, turning on ALL_MCAST mode\n",
 			    rc);
+		vnic->rx_mask &= ~CFA_L2_SET_RX_MASK_REQ_MASK_MCAST;
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
 		rc = bnxt_hwrm_cfa_l2_set_rx_mask(bp, 0);


