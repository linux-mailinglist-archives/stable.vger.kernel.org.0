Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732E2657DF0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiL1Psi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiL1PsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:48:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FD217E18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:48:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77A26B81733
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DBDC433D2;
        Wed, 28 Dec 2022 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242496;
        bh=tBrRq5yisab6ky71x8kdBKUTgTazPU6FQyLlXolWpf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4krU2lEBl2yBRja+o8UGcss3c/vjzlKwaYQRKj9+b5DJO1lCUVxtsBO3xM4YekyF
         Ej16g8g5qDnPVDd8u/x01yA7YatTlUra6u7gCZpEDkofDUNmhylEdDaP1nwo4X+xtD
         fo5AnNOPVOlyHhotUJxHLFr/oPWoC+N4/0+LtB18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 589/731] net: enetc: avoid buffer leaks on xdp_do_redirect() failure
Date:   Wed, 28 Dec 2022 15:41:36 +0100
Message-Id: <20221228144313.619046407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 628050ec952d2e2e46ec9fb6aa07e41139e030c8 ]

Before enetc_clean_rx_ring_xdp() calls xdp_do_redirect(), each software
BD in the RX ring between index orig_i and i can have one of 2 refcount
values on its page.

We are the owner of the current buffer that is being processed, so the
refcount will be at least 1.

If the current owner of the buffer at the diametrically opposed index
in the RX ring (i.o.w, the other half of this page) has not yet called
kfree(), this page's refcount could even be 2.

enetc_page_reusable() in enetc_flip_rx_buff() tests for the page
refcount against 1, and [ if it's 2 ] does not attempt to reuse it.

But if enetc_flip_rx_buff() is put after the xdp_do_redirect() call,
the page refcount can have one of 3 values. It can also be 0, if there
is no owner of the other page half, and xdp_do_redirect() for this
buffer ran so far that it triggered a flush of the devmap/cpumap bulk
queue, and the consumers of those bulk queues also freed the buffer,
all by the time xdp_do_redirect() returns the execution back to enetc.

This is the reason why enetc_flip_rx_buff() is called before
xdp_do_redirect(), but there is a big flaw with that reasoning:
enetc_flip_rx_buff() will set rx_swbd->page = NULL on both sides of the
enetc_page_reusable() branch, and if xdp_do_redirect() returns an error,
we call enetc_xdp_free(), which does not deal gracefully with that.

In fact, what happens is quite special. The page refcounts start as 1.
enetc_flip_rx_buff() figures they're reusable, transfers these
rx_swbd->page pointers to a different rx_swbd in enetc_reuse_page(), and
bumps the refcount to 2. When xdp_do_redirect() later returns an error,
we call the no-op enetc_xdp_free(), but we still haven't lost the
reference to that page. A copy of it is still at rx_ring->next_to_alloc,
but that has refcount 2 (and there are no concurrent owners of it in
flight, to drop the refcount). What really kills the system is when
we'll flip the rx_swbd->page the second time around. With an updated
refcount of 2, the page will not be reusable and we'll really leak it.
Then enetc_new_page() will have to allocate more pages, which will then
eventually leak again on further errors from xdp_do_redirect().

The problem, summarized, is that we zeroize rx_swbd->page before we're
completely done with it, and this makes it impossible for the error path
to do something with it.

Since the packet is potentially multi-buffer and therefore the
rx_swbd->page is potentially an array, manual passing of the old
pointers between enetc_flip_rx_buff() and enetc_xdp_free() is a bit
difficult.

For the sake of going with a simple solution, we accept the possibility
of racing with xdp_do_redirect(), and we move the flip procedure to
execute only on the redirect success path. By racing, I mean that the
page may be deemed as not reusable by enetc (having a refcount of 0),
but there will be no leak in that case, either.

Once we accept that, we have something better to do with buffers on
XDP_REDIRECT failure. Since we haven't performed half-page flipping yet,
we won't, either (and this way, we can avoid enetc_xdp_free()
completely, which gives the entire page to the slab allocator).
Instead, we'll call enetc_xdp_drop(), which will recycle this half of
the buffer back to the RX ring.

Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
Suggested-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20221213001908.2347046-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 35 +++++---------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 222a250fba84..adccb14c1644 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1220,23 +1220,6 @@ static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
 	rx_ring->stats.xdp_drops++;
 }
 
-static void enetc_xdp_free(struct enetc_bdr *rx_ring, int rx_ring_first,
-			   int rx_ring_last)
-{
-	while (rx_ring_first != rx_ring_last) {
-		struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[rx_ring_first];
-
-		if (rx_swbd->page) {
-			dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
-				       rx_swbd->dir);
-			__free_page(rx_swbd->page);
-			rx_swbd->page = NULL;
-		}
-		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
-	}
-	rx_ring->stats.xdp_redirect_failures++;
-}
-
 static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				   struct napi_struct *napi, int work_limit,
 				   struct bpf_prog *prog)
@@ -1258,8 +1241,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		int orig_i, orig_cleaned_cnt;
 		struct xdp_buff xdp_buff;
 		struct sk_buff *skb;
-		int tmp_orig_i, err;
 		u32 bd_status;
+		int err;
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
@@ -1346,18 +1329,16 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				break;
 			}
 
-			tmp_orig_i = orig_i;
-
-			while (orig_i != i) {
-				enetc_flip_rx_buff(rx_ring,
-						   &rx_ring->rx_swbd[orig_i]);
-				enetc_bdr_idx_inc(rx_ring, &orig_i);
-			}
-
 			err = xdp_do_redirect(rx_ring->ndev, &xdp_buff, prog);
 			if (unlikely(err)) {
-				enetc_xdp_free(rx_ring, tmp_orig_i, i);
+				enetc_xdp_drop(rx_ring, orig_i, i);
+				rx_ring->stats.xdp_redirect_failures++;
 			} else {
+				while (orig_i != i) {
+					enetc_flip_rx_buff(rx_ring,
+							   &rx_ring->rx_swbd[orig_i]);
+					enetc_bdr_idx_inc(rx_ring, &orig_i);
+				}
 				xdp_redirect_frm_cnt++;
 				rx_ring->stats.xdp_redirect++;
 			}
-- 
2.35.1



