Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84AF60B762
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiJXTXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiJXTV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:21:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B69AE46;
        Mon, 24 Oct 2022 10:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BD03CE1621;
        Mon, 24 Oct 2022 12:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC73EC433B5;
        Mon, 24 Oct 2022 12:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614955;
        bh=qzNPjTgfZEYYgdxUncWZqKaKdlo8w1SbSuDFg3W8BnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aj+wYq1wxaBgicbNWyPgG4GT1M2j2LmLR1a2cAubS1/jiwTyBMlnbDotqQb9xb5fh
         xls8l1o+qKJlFfbbZqtezzOqWwCyRs+Xhuqw14c1xMJrfGTPSEB7Eq9JdFdxzeaozR
         gQIv+5hjxKGngxLd+kTer5ZwTUJjxLLLAurYxwIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 036/530] net: thunderbolt: Enable DMA paths only after rings are enabled
Date:   Mon, 24 Oct 2022 13:26:20 +0200
Message-Id: <20221024113046.631669915@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


