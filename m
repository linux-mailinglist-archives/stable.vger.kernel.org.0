Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FAD4F2C64
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbiDEJgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbiDEI6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:58:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463EA2497E;
        Tue,  5 Apr 2022 01:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8782B81A0C;
        Tue,  5 Apr 2022 08:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144FDC385A0;
        Tue,  5 Apr 2022 08:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148790;
        bh=lHH2U2c4N+cimVlUZ+DAFWCbYaHiZ5I3DlIyPSGvxpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBcKJgKj34amFdVBtfNtmWbBMQHaOxqWpasJ1sJQ4hu9KMzY9j86MbKsjVhnlVf8y
         fcsW8SNBnMUFznyOd6JLbvY6zxBJ8mv23wREH3U6fqrPEXJO0d9sFEHYnSVhv9GCT2
         FvBWXbDbO+al0gNLyB1PHm2CNhSWd4nKHXuv5eHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corinna Vinschen <vinschen@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0483/1017] igb: refactor XDP registration
Date:   Tue,  5 Apr 2022 09:23:16 +0200
Message-Id: <20220405070408.636412639@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Corinna Vinschen <vinschen@redhat.com>

[ Upstream commit e62ad74aa534404b3ee7e250b114a3536ac56987 ]

On changing the RX ring parameters igb uses a hack to avoid a warning
when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
clears the struct xdp_rxq_info content.

Instead, change this to unregister if we're already registered.  Align
code to the igc code.

Fixes: 9cbc948b5a20c ("igb: add XDP support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 19 +++++++++++++------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index fb1029352c3e..3cbb5a89b336 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -961,10 +961,6 @@ static int igb_set_ringparam(struct net_device *netdev,
 			memcpy(&temp_ring[i], adapter->rx_ring[i],
 			       sizeof(struct igb_ring));
 
-			/* Clear copied XDP RX-queue info */
-			memset(&temp_ring[i].xdp_rxq, 0,
-			       sizeof(temp_ring[i].xdp_rxq));
-
 			temp_ring[i].count = new_rx_count;
 			err = igb_setup_rx_resources(&temp_ring[i]);
 			if (err) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 446894dde182..5034ebb57b65 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4352,7 +4352,18 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 {
 	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
 	struct device *dev = rx_ring->dev;
-	int size;
+	int size, res;
+
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
+			       rx_ring->queue_index, 0);
+	if (res < 0) {
+		dev_err(dev, "Failed to register xdp_rxq index %u\n",
+			rx_ring->queue_index);
+		return res;
+	}
 
 	size = sizeof(struct igb_rx_buffer) * rx_ring->count;
 
@@ -4375,14 +4386,10 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 
 	rx_ring->xdp_prog = adapter->xdp_prog;
 
-	/* XDP RX-queue info */
-	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-			     rx_ring->queue_index, 0) < 0)
-		goto err;
-
 	return 0;
 
 err:
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
-- 
2.34.1



