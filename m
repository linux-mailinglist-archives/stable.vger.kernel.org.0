Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D506A4C48AB
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241981AbiBYPXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbiBYPXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:23:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D08182D89
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F5B0B830B8
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF6DC340F0;
        Fri, 25 Feb 2022 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802569;
        bh=x331+wP9N4aGlKo0WS5ixUrOyupdIoHvupzV5ih2JOg=;
        h=Subject:To:Cc:From:Date:From;
        b=GkkSkt4u9XjL12Ua54W68ov6Y2LP384RNQbTHLJBzSFw/Gc9rRIY2ZN/MYrdEDMgW
         PbISgZ1cVQlnADh4GUvHAgTxVIgrn1K46KjMM7UCczTEMfhL0WmkocDWCbebURlTa9
         c+ANw9NPeTFrDGZEHgNv9/4hOild12UFqaDCtlxU=
Subject: FAILED: patch "[PATCH] bnxt_en: Fix incorrect multicast rx mask setting when not" failed to apply to 4.9-stable tree
To:     pavan.chebbi@broadcom.com, davem@davemloft.net,
        michael.chan@broadcom.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:22:38 +0100
Message-ID: <164580255819455@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8cdb15924252e27af16c4a8fe0fc606ce5fd04dc Mon Sep 17 00:00:00 2001
From: Pavan Chebbi <pavan.chebbi@broadcom.com>
Date: Sun, 20 Feb 2022 04:05:50 -0500
Subject: [PATCH] bnxt_en: Fix incorrect multicast rx mask setting when not
 requested

We should setup multicast only when net_device flags explicitly
has IFF_MULTICAST set. Otherwise we will incorrectly turn it on
even when not asked.  Fix it by only passing the multicast table
to the firmware if IFF_MULTICAST is set.

Fixes: 7d2837dd7a32 ("bnxt_en: Setup multicast properly after resetting device.")
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 785436f6dd24..fc5b1d816bdb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4747,8 +4747,10 @@ static int bnxt_hwrm_cfa_l2_set_rx_mask(struct bnxt *bp, u16 vnic_id)
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
@@ -8651,7 +8653,7 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	if (bp->dev->flags & IFF_ALLMULTI) {
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
-	} else {
+	} else if (bp->dev->flags & IFF_MULTICAST) {
 		u32 mask = 0;
 
 		bnxt_mc_list_updated(bp, &mask);
@@ -10779,7 +10781,7 @@ static void bnxt_set_rx_mode(struct net_device *dev)
 	if (dev->flags & IFF_ALLMULTI) {
 		mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
-	} else {
+	} else if (dev->flags & IFF_MULTICAST) {
 		mc_update = bnxt_mc_list_updated(bp, &mask);
 	}
 
@@ -10856,9 +10858,10 @@ static int bnxt_cfg_rx_mode(struct bnxt *bp)
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

