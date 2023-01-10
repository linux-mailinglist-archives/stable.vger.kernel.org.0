Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E050B664B51
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbjAJSlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbjAJSlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:41:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33D85D895
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:35:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96DEAB81902
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5711C433EF;
        Tue, 10 Jan 2023 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375703;
        bh=c4l+5b5kwebcU8irDqq4ifj0wYyLox3WF5JPzrgR8qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiWQ4/0WC1w3WPkI1qBc9Yp3NEkxr/diCt23S3SOOcn200Sp9yI0pHIhYF5dIWtJX
         R45++jO7fupTV+51Ap/QsPgCGSYzeO4Okuew7xh6YGcGGNiiwocQ2yDpSAYorpuBFw
         ZxrqCD/As8qtxpRJwP185uLgivXLXJa2aDKIQPBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Agroskin <shayagr@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/290] net: ena: Use bitmask to indicate packet redirection
Date:   Tue, 10 Jan 2023 19:05:25 +0100
Message-Id: <20230110180040.055812280@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 59811faa2c54dbcf44d575b5a8f6e7077da88dc2 ]

Redirecting packets with XDP Redirect is done in two phases:
1. A packet is passed by the driver to the kernel using
   xdp_do_redirect().
2. After finishing polling for new packets the driver lets the kernel
   know that it can now process the redirected packet using
   xdp_do_flush_map().
   The packets' redirection is handled in the napi context of the
   queue that called xdp_do_redirect()

To avoid calling xdp_do_flush_map() each time the driver first checks
whether any packets were redirected, using
	xdp_flags |= xdp_verdict;
and
	if (xdp_flags & XDP_REDIRECT)
	    xdp_do_flush_map()

essentially treating XDP instructions as a bitmask, which isn't the case:
    enum xdp_action {
	    XDP_ABORTED = 0,
	    XDP_DROP,
	    XDP_PASS,
	    XDP_TX,
	    XDP_REDIRECT,
    };

Given the current possible values of xdp_action, the current design
doesn't have a bug (since XDP_REDIRECT = 100b), but it is still
flawed.

This patch makes the driver use a bitmask instead, to avoid future
issues.

Fixes: a318c70ad152 ("net: ena: introduce XDP redirect implementation")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 26 ++++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  9 +++++++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 31afbd17e690..294f21a839cf 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -378,9 +378,9 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 
 static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 {
+	u32 verdict = ENA_XDP_PASS;
 	struct bpf_prog *xdp_prog;
 	struct ena_ring *xdp_ring;
-	u32 verdict = XDP_PASS;
 	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
 
@@ -397,7 +397,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		if (unlikely(!xdpf)) {
 			trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 			xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-			verdict = XDP_ABORTED;
+			verdict = ENA_XDP_DROP;
 			break;
 		}
 
@@ -413,29 +413,35 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 		spin_unlock(&xdp_ring->xdp_tx_lock);
 		xdp_stat = &rx_ring->rx_stats.xdp_tx;
+		verdict = ENA_XDP_TX;
 		break;
 	case XDP_REDIRECT:
 		if (likely(!xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog))) {
 			xdp_stat = &rx_ring->rx_stats.xdp_redirect;
+			verdict = ENA_XDP_REDIRECT;
 			break;
 		}
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-		verdict = XDP_ABORTED;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_DROP:
 		xdp_stat = &rx_ring->rx_stats.xdp_drop;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_PASS:
 		xdp_stat = &rx_ring->rx_stats.xdp_pass;
+		verdict = ENA_XDP_PASS;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
+		verdict = ENA_XDP_DROP;
 	}
 
 	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
@@ -1631,12 +1637,12 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	 * we expect, then we simply drop it
 	 */
 	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
-		return XDP_DROP;
+		return ENA_XDP_DROP;
 
 	ret = ena_xdp_execute(rx_ring, xdp);
 
 	/* The xdp program might expand the headers */
-	if (ret == XDP_PASS) {
+	if (ret == ENA_XDP_PASS) {
 		rx_info->page_offset = xdp->data - xdp->data_hard_start;
 		rx_ring->ena_bufs[0].len = xdp->data_end - xdp->data;
 	}
@@ -1675,7 +1681,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	xdp_init_buff(&xdp, ENA_PAGE_SIZE, &rx_ring->xdp_rxq);
 
 	do {
-		xdp_verdict = XDP_PASS;
+		xdp_verdict = ENA_XDP_PASS;
 		skb = NULL;
 		ena_rx_ctx.ena_bufs = rx_ring->ena_bufs;
 		ena_rx_ctx.max_bufs = rx_ring->sgl_size;
@@ -1703,7 +1709,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp);
 
 		/* allocate skb and fill it */
-		if (xdp_verdict == XDP_PASS)
+		if (xdp_verdict == ENA_XDP_PASS)
 			skb = ena_rx_skb(rx_ring,
 					 rx_ring->ena_bufs,
 					 ena_rx_ctx.descs,
@@ -1721,13 +1727,13 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 				/* Packets was passed for transmission, unmap it
 				 * from RX side.
 				 */
-				if (xdp_verdict == XDP_TX || xdp_verdict == XDP_REDIRECT) {
+				if (xdp_verdict & ENA_XDP_FORWARDED) {
 					ena_unmap_rx_buff(rx_ring,
 							  &rx_ring->rx_buffer_info[req_id]);
 					rx_ring->rx_buffer_info[req_id].page = NULL;
 				}
 			}
-			if (xdp_verdict != XDP_PASS) {
+			if (xdp_verdict != ENA_XDP_PASS) {
 				xdp_flags |= xdp_verdict;
 				total_len += ena_rx_ctx.ena_bufs[0].len;
 				res_budget--;
@@ -1773,7 +1779,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		ena_refill_rx_bufs(rx_ring, refill_required);
 	}
 
-	if (xdp_flags & XDP_REDIRECT)
+	if (xdp_flags & ENA_XDP_REDIRECT)
 		xdp_do_flush_map();
 
 	return work_done;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 0c39fc2fa345..ada2f8faa33a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -412,6 +412,15 @@ enum ena_xdp_errors_t {
 	ENA_XDP_NO_ENOUGH_QUEUES,
 };
 
+enum ENA_XDP_ACTIONS {
+	ENA_XDP_PASS		= 0,
+	ENA_XDP_TX		= BIT(0),
+	ENA_XDP_REDIRECT	= BIT(1),
+	ENA_XDP_DROP		= BIT(2)
+};
+
+#define ENA_XDP_FORWARDED (ENA_XDP_TX | ENA_XDP_REDIRECT)
+
 static inline bool ena_xdp_present(struct ena_adapter *adapter)
 {
 	return !!adapter->xdp_bpf_prog;
-- 
2.35.1



