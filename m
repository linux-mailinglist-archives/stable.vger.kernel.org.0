Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A74B6085CA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiJVHjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiJVHin (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:38:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5687029B88B;
        Sat, 22 Oct 2022 00:36:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A65EFB82D9F;
        Sat, 22 Oct 2022 07:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27B3C433C1;
        Sat, 22 Oct 2022 07:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424162;
        bh=qzNPjTgfZEYYgdxUncWZqKaKdlo8w1SbSuDFg3W8BnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsoShnUtufvycgSoX6JXO2BrK8EoeZInnkG38/zZ1SXTsVjTtncFZar/bR2Zx84WS
         R5Pv/NVnJmh9TcBvwlSQmGKARp//8cg69GNrdGkxHELBOVDgIOwfhTIXr0nZ2goy4N
         GpprgUDy6ReJjUuk2OJ/LVPZAZOqyuXrChvOHNcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 047/717] net: thunderbolt: Enable DMA paths only after rings are enabled
Date:   Sat, 22 Oct 2022 09:18:46 +0200
Message-Id: <20221022072423.447662635@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit ff7cd07f306406493f7b78890475e85b6d0811ed upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/thunderbolt.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -612,18 +612,13 @@ static void tbnet_connected_work(struct
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
 
@@ -635,10 +630,21 @@ static void tbnet_connected_work(struct
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


