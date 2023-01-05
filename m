Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBECF65EBC0
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjAENCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjAENBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:01:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37CA5006D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 765B5B81A84
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3558C433D2;
        Thu,  5 Jan 2023 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923710;
        bh=mM6VjqRXupPPw0y6BTdjQKoV7SCy+SywU1D5+YZh42s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADui5XrpTpInBVQUGDD8qz7UPF+WYTHU5MCO2ut9MmUL9WQkSs6+G9HAW+dJrvBcC
         MfHNDs2s+psEsnG92DDTA7DqV68uFx6qVa/TFTgh2e6RzSjyqC3mTr3dqxOFEIYgvS
         BLU21YqUjrUtnFrG1aA/q4KsYzgjskfAWeGRrvaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Pilmore <epilmore@gigaio.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 108/251] ntb_netdev: Use dev_kfree_skb_any() in interrupt context
Date:   Thu,  5 Jan 2023 13:54:05 +0100
Message-Id: <20230105125339.771061324@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Eric Pilmore <epilmore@gigaio.com>

[ Upstream commit 5f7d78b2b12a9d561f48fa00bab29b40f4616dad ]

TX/RX callback handlers (ntb_netdev_tx_handler(),
ntb_netdev_rx_handler()) can be called in interrupt
context via the DMA framework when the respective
DMA operations have completed. As such, any calls
by these routines to free skb's, should use the
interrupt context safe dev_kfree_skb_any() function.

Previously, these callback handlers would call the
interrupt unsafe version of dev_kfree_skb(). This has
not presented an issue on Intel IOAT DMA engines as
that driver utilizes tasklets rather than a hard
interrupt handler, like the AMD PTDMA DMA driver.
On AMD systems, a kernel WARNING message is
encountered, which is being issued from
skb_release_head_state() due to in_hardirq()
being true.

Besides the user visible WARNING from the kernel,
the other symptom of this bug was that TCP/IP performance
across the ntb_netdev interface was very poor, i.e.
approximately an order of magnitude below what was
expected. With the repair to use dev_kfree_skb_any(),
kernel WARNINGs from skb_release_head_state() ceased
and TCP/IP performance, as measured by iperf, was on
par with expected results, approximately 20 Gb/s on
AMD Milan based server. Note that this performance
is comparable with Intel based servers.

Fixes: 765ccc7bc3d91 ("ntb_netdev: correct skb leak")
Fixes: 548c237c0a997 ("net: Add support for NTB virtual ethernet device")
Signed-off-by: Eric Pilmore <epilmore@gigaio.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20221209000659.8318-1-epilmore@gigaio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ntb_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index bd6c19ceab30..c4a3143cef25 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -140,7 +140,7 @@ static void ntb_netdev_rx_handler(struct ntb_transport_qp *qp, void *qp_data,
 enqueue_again:
 	rc = ntb_transport_rx_enqueue(qp, skb, skb->data, ndev->mtu + ETH_HLEN);
 	if (rc) {
-		dev_kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		ndev->stats.rx_errors++;
 		ndev->stats.rx_fifo_errors++;
 	}
@@ -195,7 +195,7 @@ static void ntb_netdev_tx_handler(struct ntb_transport_qp *qp, void *qp_data,
 		ndev->stats.tx_aborted_errors++;
 	}
 
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 
 	if (ntb_transport_tx_free_entry(dev->qp) >= tx_start) {
 		/* Make sure anybody stopping the queue after this sees the new
-- 
2.35.1



