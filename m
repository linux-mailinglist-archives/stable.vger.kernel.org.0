Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0966CA9A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjAPREY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjAPRDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:03:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F214C6F7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C750B8108F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2446C433D2;
        Mon, 16 Jan 2023 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887574;
        bh=fmTl9L0LGI6dAV1eOH+ukGGUNMBs1nt2hfg/7FjgvhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7DeSzTuUOIF5mlMxItmul3cdC7Ex/tct5QXeiMWA0v9m2EcxcxGhbuh6Od4IeQ26
         ooS4IyBeoGCR89dtrDgYvyhTFc41RrEy6oFLG5Vgj/YDfgNLzcpzNrxfPGVfRQQScp
         2F7s9Nu4uza1YjMuo40MLs8uXXQv19VMJCZQUCYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Pilmore <epilmore@gigaio.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/521] ntb_netdev: Use dev_kfree_skb_any() in interrupt context
Date:   Mon, 16 Jan 2023 16:47:14 +0100
Message-Id: <20230116154854.799487767@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 33974e7519ce..ca0053775d3f 100644
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



