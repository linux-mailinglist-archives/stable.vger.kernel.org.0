Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB965FFDF8
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJPHe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJPHeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:34:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CE7C21
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:34:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 955406098A
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48BEC433D6;
        Sun, 16 Oct 2022 07:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665905663;
        bh=BcVMvk4/BqgMwzWh6QLWonrtSjceGltSjSJmxhBm3dk=;
        h=Subject:To:Cc:From:Date:From;
        b=dV4NZ59r9UC3EHyIQFoN7ZQNTskKB1naJQBkprSoY+oHIdWwQ+8RIB9DR+I0WcTAa
         Oc4wFYjkyH/I2jwRTnZUklcG/WCPwPiOgbFfPGAmNU8lyQkzeyC+OMAiT/hrFWYVO3
         r8I3IXNzt8GzuEKnDcqQB9VwHoNhXHfC9bstZWiE=
Subject: FAILED: patch "[PATCH] net: thunderbolt: Enable DMA paths only after rings are" failed to apply to 4.19-stable tree
To:     mika.westerberg@linux.intel.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:34:59 +0200
Message-ID: <166590569910111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ff7cd07f3064 ("net: thunderbolt: Enable DMA paths only after rings are enabled")
180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
46b494f28681 ("thunderbolt: Add support for maxhopid XDomain property")
8ccbed2476f2 ("thunderbolt: Do not re-establish XDomain DMA paths automatically")
d29c59b1a4dc ("thunderbolt: Add more logging to XDomain connections")
5ca67688256a ("thunderbolt: Allow disabling XDomain protocol")
a27ea0dfc1cd ("thunderbolt: tunnel: Fix misspelling of 'receive_path'")
9490f71167fe ("thunderbolt: Add connection manager specific hooks for USB4 router operations")
83bab44ada05 ("thunderbolt: Pass TX and RX data directly to usb4_switch_op()")
fe265a06319b ("thunderbolt: Pass metadata directly to usb4_switch_op()")
661b19473bf3 ("thunderbolt: Perform USB4 router NVM upgrade in two phases")
edc0f494ed96 ("thunderbolt: Add DMA traffic test driver")
5bf722df5d37 ("thunderbolt: Make it possible to allocate one directional DMA tunnel")
5cc0df9ce10a ("thunderbolt: Add functions for enabling and disabling lane bonding on XDomain")
4210d50f0b3e ("thunderbolt: Add link_speed and link_width to XDomain")
47844ecb8cec ("thunderbolt: Create XDomain devices for loops back to the host")
d67274bacb8a ("thunderbolt: Find XDomain by route instead of UUID")
8eabfca52333 ("thunderbolt: Use "if USB4" instead of "depends on" in Kconfig")
2c6ea4e2cefe ("thunderbolt: Allow KUnit tests to be built also when CONFIG_USB4=m")
54e418106c76 ("thunderbolt: Add debugfs interface")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ff7cd07f306406493f7b78890475e85b6d0811ed Mon Sep 17 00:00:00 2001
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 30 Aug 2022 18:32:46 +0300
Subject: [PATCH] net: thunderbolt: Enable DMA paths only after rings are
 enabled

If the other host starts sending packets early on it is possible that we
are still in the middle of populating the initial Rx ring packets to the
ring. This causes the tbnet_poll() to mess over the queue and causes
list corruption. This happens specifically when connected with macOS as
it seems start sending various IP discovery packets as soon as its side
of the paths are configured.

To prevent this we move the DMA path enabling to happen after we have
primed the Rx ring. This makes sure no incoming packets can arrive
before we are ready to handle them.

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ff5d0e98a088..ab3f04562980 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -612,18 +612,13 @@ static void tbnet_connected_work(struct work_struct *work)
 		return;
 	}
 
-	/* Both logins successful so enable the high-speed DMA paths and
-	 * start the network device queue.
+	/* Both logins successful so enable the rings, high-speed DMA
+	 * paths and start the network device queue.
+	 *
+	 * Note we enable the DMA paths last to make sure we have primed
+	 * the Rx ring before any incoming packets are allowed to
+	 * arrive.
 	 */
-	ret = tb_xdomain_enable_paths(net->xd, net->local_transmit_path,
-				      net->rx_ring.ring->hop,
-				      net->remote_transmit_path,
-				      net->tx_ring.ring->hop);
-	if (ret) {
-		netdev_err(net->dev, "failed to enable DMA paths\n");
-		return;
-	}
-
 	tb_ring_start(net->tx_ring.ring);
 	tb_ring_start(net->rx_ring.ring);
 
@@ -635,10 +630,21 @@ static void tbnet_connected_work(struct work_struct *work)
 	if (ret)
 		goto err_free_rx_buffers;
 
+	ret = tb_xdomain_enable_paths(net->xd, net->local_transmit_path,
+				      net->rx_ring.ring->hop,
+				      net->remote_transmit_path,
+				      net->tx_ring.ring->hop);
+	if (ret) {
+		netdev_err(net->dev, "failed to enable DMA paths\n");
+		goto err_free_tx_buffers;
+	}
+
 	netif_carrier_on(net->dev);
 	netif_start_queue(net->dev);
 	return;
 
+err_free_tx_buffers:
+	tbnet_free_buffers(&net->tx_ring);
 err_free_rx_buffers:
 	tbnet_free_buffers(&net->rx_ring);
 err_stop_rings:

