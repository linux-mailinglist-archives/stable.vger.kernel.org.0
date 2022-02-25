Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763D64C48A9
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiBYPXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242067AbiBYPW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:22:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED0956234
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:22:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EB30611CB
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B289FC340E7;
        Fri, 25 Feb 2022 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802545;
        bh=R/PnJEQsUNSESXvovPpQovdM3vlh+N5E8pH5yVHzIOY=;
        h=Subject:To:Cc:From:Date:From;
        b=TMWkVZU6pu3PIx3eIgFQ0w1MdKpStS5mB+mgSNniEWJMtemobWsXLanRPyDr4S7bN
         cc+HZOIWfC+RPE9r9Hr2iAsuJznVagH3B/XgH1RDNGr6Rwvmi37hzFC0JJ4h0UyfsT
         Xm10N3kdCPpOMCEtuWYKh6XXrfDyBkwMyQd3v9BQ=
Subject: FAILED: patch "[PATCH] bnxt_en: Fix occasional ethtool -t loopback test failures" failed to apply to 5.15-stable tree
To:     michael.chan@broadcom.com, davem@davemloft.net,
        edwin.peer@broadcom.com, gospo@broadcom.com,
        pavan.chebbi@broadcom.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:22:22 +0100
Message-ID: <164580254288200@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cfcab3b3b61584a02bb523ffa99564eafa761dfe Mon Sep 17 00:00:00 2001
From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 20 Feb 2022 04:05:49 -0500
Subject: [PATCH] bnxt_en: Fix occasional ethtool -t loopback test failures

In the current code, we setup the port to PHY or MAC loopback mode
and then transmit a test broadcast packet for the loopback test.  This
scheme fails sometime if the port is shared with management firmware
that can also send packets.  The driver may receive the management
firmware's packet and the test will fail when the contents don't
match the test packet.

Change the test packet to use it's own MAC address as the destination
and setup the port to only receive it's own MAC address.  This should
filter out other packets sent by management firmware.

Fixes: 91725d89b97a ("bnxt_en: Add PHY loopback to ethtool self-test.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 23bbb1c5812d..785436f6dd24 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8639,6 +8639,9 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	vnic->uc_filter_count = 1;
 
 	vnic->rx_mask = 0;
+	if (test_bit(BNXT_STATE_HALF_OPEN, &bp->state))
+		goto skip_rx_mask;
+
 	if (bp->dev->flags & IFF_BROADCAST)
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_BCAST;
 
@@ -8659,6 +8662,7 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	if (rc)
 		goto err_out;
 
+skip_rx_mask:
 	rc = bnxt_hwrm_set_coal(bp);
 	if (rc)
 		netdev_warn(bp->dev, "HWRM set coalescing failure rc: %x\n",
@@ -10335,8 +10339,10 @@ int bnxt_half_open_nic(struct bnxt *bp)
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
 		goto half_open_err;
 	}
+	set_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 	rc = bnxt_init_nic(bp, true);
 	if (rc) {
+		clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
 		goto half_open_err;
 	}
@@ -10357,6 +10363,7 @@ void bnxt_half_close_nic(struct bnxt *bp)
 	bnxt_hwrm_resource_free(bp, false, true);
 	bnxt_free_skbs(bp);
 	bnxt_free_mem(bp, true);
+	clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 }
 
 void bnxt_reenable_sriov(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 440dfeb4948b..666fc1e7a7d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1921,6 +1921,7 @@ struct bnxt {
 #define BNXT_STATE_RECOVER		12
 #define BNXT_STATE_FW_NON_FATAL_COND	13
 #define BNXT_STATE_FW_ACTIVATE_RESET	14
+#define BNXT_STATE_HALF_OPEN		15	/* For offline ethtool tests */
 
 #define BNXT_NO_FW_ACCESS(bp)					\
 	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a85b18858b32..8aaa2335f848 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3458,7 +3458,7 @@ static int bnxt_run_loopback(struct bnxt *bp)
 	if (!skb)
 		return -ENOMEM;
 	data = skb_put(skb, pkt_size);
-	eth_broadcast_addr(data);
+	ether_addr_copy(&data[i], bp->dev->dev_addr);
 	i += ETH_ALEN;
 	ether_addr_copy(&data[i], bp->dev->dev_addr);
 	i += ETH_ALEN;

