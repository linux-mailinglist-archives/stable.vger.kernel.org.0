Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFC94C75C8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbiB1R4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238994AbiB1Ryq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D17BDEE2;
        Mon, 28 Feb 2022 09:44:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E66B60909;
        Mon, 28 Feb 2022 17:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27572C340F0;
        Mon, 28 Feb 2022 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070267;
        bh=ic4faoE/L3WKRHns01+UmgIhVyqu/G6ojlYU9A9fePg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6yGXFdRRDq4JdQ0fMne1NzK84XDVXyX1CFbBE8O6xiwyqvbR7XGUD82q3XXDJMo4
         TdWZ/u7vy4eTjgMoblv6D5tXEz8UgPar8wTjpLEUHhmJtnE7btkv1FC+O1OCTWzoL6
         SOexpIzyagY/2W+dMQmG9KV7u6EZcaORZVws4RYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 046/164] bnxt_en: Fix occasional ethtool -t loopback test failures
Date:   Mon, 28 Feb 2022 18:23:28 +0100
Message-Id: <20220228172404.426336064@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

commit cfcab3b3b61584a02bb523ffa99564eafa761dfe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |    7 +++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |    1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |    2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8623,6 +8623,9 @@ static int bnxt_init_chip(struct bnxt *b
 	vnic->uc_filter_count = 1;
 
 	vnic->rx_mask = 0;
+	if (test_bit(BNXT_STATE_HALF_OPEN, &bp->state))
+		goto skip_rx_mask;
+
 	if (bp->dev->flags & IFF_BROADCAST)
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_BCAST;
 
@@ -8643,6 +8646,7 @@ static int bnxt_init_chip(struct bnxt *b
 	if (rc)
 		goto err_out;
 
+skip_rx_mask:
 	rc = bnxt_hwrm_set_coal(bp);
 	if (rc)
 		netdev_warn(bp->dev, "HWRM set coalescing failure rc: %x\n",
@@ -10315,8 +10319,10 @@ int bnxt_half_open_nic(struct bnxt *bp)
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
@@ -10337,6 +10343,7 @@ void bnxt_half_close_nic(struct bnxt *bp
 	bnxt_hwrm_resource_free(bp, false, true);
 	bnxt_free_skbs(bp);
 	bnxt_free_mem(bp, true);
+	clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 }
 
 void bnxt_reenable_sriov(struct bnxt *bp)
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1919,6 +1919,7 @@ struct bnxt {
 #define BNXT_STATE_RECOVER		12
 #define BNXT_STATE_FW_NON_FATAL_COND	13
 #define BNXT_STATE_FW_ACTIVATE_RESET	14
+#define BNXT_STATE_HALF_OPEN		15	/* For offline ethtool tests */
 
 #define BNXT_NO_FW_ACCESS(bp)					\
 	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3433,7 +3433,7 @@ static int bnxt_run_loopback(struct bnxt
 	if (!skb)
 		return -ENOMEM;
 	data = skb_put(skb, pkt_size);
-	eth_broadcast_addr(data);
+	ether_addr_copy(&data[i], bp->dev->dev_addr);
 	i += ETH_ALEN;
 	ether_addr_copy(&data[i], bp->dev->dev_addr);
 	i += ETH_ALEN;


