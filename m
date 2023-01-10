Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31166648A1
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbjAJSM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbjAJSMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:12:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F7A5FC5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 904956186E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AEEC433D2;
        Tue, 10 Jan 2023 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374267;
        bh=D91RMQ0G/ES9Evykr0eugd3+aShZD2wcaUaHl9DnH6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr+c77PGaKady5fn8uqsOfbk6fgJFh35gkOzkrSOMR+xz3QEkK3wxe9JiS7RBVas9
         JROWiK1XtmEmW7AeBGrdMkGjPT2LM5sG3KT0qNN0mpH+GZma+rCJhqrChO3IRrzemr
         U9yLKpTF4x6uqWeWgSURawlpFcz6eXUNDnMX795U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Agroskin <shayagr@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 067/148] net: ena: Use bitmask to indicate packet redirection
Date:   Tue, 10 Jan 2023 19:02:51 +0100
Message-Id: <20230110180019.348676490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
index 614f27f18164..a27a7963df76 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -374,9 +374,9 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 
 static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 {
+	u32 verdict = ENA_XDP_PASS;
 	struct bpf_prog *xdp_prog;
 	struct ena_ring *xdp_ring;
-	u32 verdict = XDP_PASS;
 	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
 
@@ -393,7 +393,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		if (unlikely(!xdpf)) {
 			trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 			xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-			verdict = XDP_ABORTED;
+			verdict = ENA_XDP_DROP;
 			break;
 		}
 
@@ -409,29 +409,35 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
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
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
+		verdict = ENA_XDP_DROP;
 	}
 
 	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
@@ -1621,12 +1627,12 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
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
@@ -1665,7 +1671,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	xdp_init_buff(&xdp, ENA_PAGE_SIZE, &rx_ring->xdp_rxq);
 
 	do {
-		xdp_verdict = XDP_PASS;
+		xdp_verdict = ENA_XDP_PASS;
 		skb = NULL;
 		ena_rx_ctx.ena_bufs = rx_ring->ena_bufs;
 		ena_rx_ctx.max_bufs = rx_ring->sgl_size;
@@ -1693,7 +1699,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp);
 
 		/* allocate skb and fill it */
-		if (xdp_verdict == XDP_PASS)
+		if (xdp_verdict == ENA_XDP_PASS)
 			skb = ena_rx_skb(rx_ring,
 					 rx_ring->ena_bufs,
 					 ena_rx_ctx.descs,
@@ -1711,13 +1717,13 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
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
@@ -1763,7 +1769,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		ena_refill_rx_bufs(rx_ring, refill_required);
 	}
 
-	if (xdp_flags & XDP_REDIRECT)
+	if (xdp_flags & ENA_XDP_REDIRECT)
 		xdp_do_flush_map();
 
 	return work_done;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 1bdce99bf688..290ae9bf47ee 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -409,6 +409,15 @@ enum ena_xdp_errors_t {
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



