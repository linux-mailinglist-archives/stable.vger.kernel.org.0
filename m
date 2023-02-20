Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6529A69CE97
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbjBTOAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjBTOAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D73B1EFE4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D03AC60EA1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FABC433A0;
        Mon, 20 Feb 2023 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901608;
        bh=i55OZUVORmFuumFjV7MZdYbTAg1yw9HhJyz9DbeehO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EguLVoNFzGzTuk9GOsI28+OcHTjPvjzXLPea36vnTtdEwiYMPUiqKKX936d7UiHo8
         qvyFNI17GEgnSHrpqHt6hfDkRyKKA8Bj2dzQHVjEYpq749z+sIrxzT0vlnMSqOjx3+
         SS4vmNvoCycZJIKo31rtigTzy4vpr3ngRHBU3kAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Xing <kernelxing@tencent.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.1 082/118] ixgbe: allow to increase MTU to 3K with XDP enabled
Date:   Mon, 20 Feb 2023 14:36:38 +0100
Message-Id: <20230220133603.685011722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

commit f9cd6a4418bac6a046ee78382423b1ae7565fb24 upstream.

Recently I encountered one case where I cannot increase the MTU size
directly from 1500 to a much bigger value with XDP enabled if the
server is equipped with IXGBE card, which happened on thousands of
servers in production environment. After applying the current patch,
we can set the maximum MTU size to 3K.

This patch follows the behavior of changing MTU as i40e/ice does.

[1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP")
[2] commit 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6778,6 +6778,18 @@ static void ixgbe_free_all_rx_resources(
 }
 
 /**
+ * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @adapter: device handle, pointer to adapter
+ */
+static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
+{
+	if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
+		return IXGBE_RXBUFFER_2K;
+	else
+		return IXGBE_RXBUFFER_3K;
+}
+
+/**
  * ixgbe_change_mtu - Change the Maximum Transfer Unit
  * @netdev: network interface device structure
  * @new_mtu: new value for maximum frame size
@@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_d
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->xdp_prog) {
+	if (ixgbe_enabled_xdp_adapter(adapter)) {
 		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
 				     VLAN_HLEN;
-		int i;
-
-		for (i = 0; i < adapter->num_rx_queues; i++) {
-			struct ixgbe_ring *ring = adapter->rx_ring[i];
 
-			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
-				e_warn(probe, "Requested MTU size is not supported with XDP\n");
-				return -EINVAL;
-			}
+		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
+			e_warn(probe, "Requested MTU size is not supported with XDP\n");
+			return -EINVAL;
 		}
 	}
 


