Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93030328AEA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhCASZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239557AbhCASTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F3564F8B;
        Mon,  1 Mar 2021 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618560;
        bh=TjDURP06y401qt2B1JMeexCKMrKYdN1TiUVmVIg/9TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2Dcq8pk9E+5iHM/PJzI9QTVuMaftsXnjEG183fDRADnqNQckwucMUvZsM9lbQito
         ohH7qUTBmHprf/lOasV0nj6KyLUyuobgdy9mK9ROUzhACXDi0Oo46R5jFFOEZQbglN
         Fab97naWg2B3R1v/Cah8SWXHiP/b6Wb0moHDnyb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/663] dpaa2-eth: fix memory leak in XDP_REDIRECT
Date:   Mon,  1 Mar 2021 17:05:49 +0100
Message-Id: <20210301161146.730734226@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit e12be9139cca26d689fe1a9257054b76752f725b ]

If xdp_do_redirect() fails, the calling driver should handle recycling
or freeing of the page associated with the frame. The dpaa2-eth driver
didn't do either of them and just incremented a counter.
Fix this by trying to DMA map back the page and recycle it or, if the
mapping fails, just free it.

Fixes: d678be1dc1ec ("dpaa2-eth: add XDP_REDIRECT support")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index d880ab2a7d962..f91c67489e629 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -399,10 +399,20 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 		xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE;
 
 		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
-		if (unlikely(err))
+		if (unlikely(err)) {
+			addr = dma_map_page(priv->net_dev->dev.parent,
+					    virt_to_page(vaddr), 0,
+					    priv->rx_buf_size, DMA_BIDIRECTIONAL);
+			if (unlikely(dma_mapping_error(priv->net_dev->dev.parent, addr))) {
+				free_pages((unsigned long)vaddr, 0);
+			} else {
+				ch->buf_count++;
+				dpaa2_eth_xdp_release_buf(priv, ch, addr);
+			}
 			ch->stats.xdp_drop++;
-		else
+		} else {
 			ch->stats.xdp_redirect++;
+		}
 		break;
 	}
 
-- 
2.27.0



