Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C5D3FDC02
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245055AbhIAMqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345274AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B27161131;
        Wed,  1 Sep 2021 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499886;
        bh=6OFHSmKEKrDUREAXDz+Y8sOrmIDcdzmXzRIiyjy0UMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bv6CqCHkHpbOKOt0bnDGPNoeUQsR4Ee9YorRNP8e+mpPS27S4KCRTO0YoJ4a2Dv1+
         GOIzXehoqwhhYx2KTQJtOMP/+nirMLHfyrlGdnbI41Sxd0HFkGn/K0A8j2S4ph1LKN
         OPxHzulgNrgntAt/81B+rdZRvVeGSaf1CILaX9aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 021/113] net: stmmac: fix kernel panic due to NULL pointer dereference of xsk_pool
Date:   Wed,  1 Sep 2021 14:27:36 +0200
Message-Id: <20210901122302.689964010@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Yoong Siang <yoong.siang.song@intel.com>

commit a6451192da2691dcf39507bd758dde35d4606ee1 upstream.

After free xsk_pool, there is possibility that napi polling is still
running in the middle, thus causes a kernel crash due to kernel NULL
pointer dereference of rx_q->xsk_pool and tx_q->xsk_pool.

Fix this by changing the XDP pool setup sequence to:
 1. disable napi before free xsk_pool
 2. enable napi after init xsk_pool

The following kernel panic is observed without this patch:

RIP: 0010:xsk_uses_need_wakeup+0x5/0x10
Call Trace:
stmmac_napi_poll_rxtx+0x3a9/0xae0 [stmmac]
__napi_poll+0x27/0x130
net_rx_action+0x233/0x280
__do_softirq+0xe2/0x2b6
run_ksoftirqd+0x1a/0x20
smpboot_thread_fn+0xac/0x140
? sort_range+0x20/0x20
kthread+0x124/0x150
? set_kthread_struct+0x40/0x40
ret_from_fork+0x1f/0x30
---[ end trace a77c8956b79ac107 ]---

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
@@ -34,18 +34,18 @@ static int stmmac_xdp_enable_pool(struct
 	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
 
 	if (need_update) {
-		stmmac_disable_rx_queue(priv, queue);
-		stmmac_disable_tx_queue(priv, queue);
 		napi_disable(&ch->rx_napi);
 		napi_disable(&ch->tx_napi);
+		stmmac_disable_rx_queue(priv, queue);
+		stmmac_disable_tx_queue(priv, queue);
 	}
 
 	set_bit(queue, priv->af_xdp_zc_qps);
 
 	if (need_update) {
-		napi_enable(&ch->rxtx_napi);
 		stmmac_enable_rx_queue(priv, queue);
 		stmmac_enable_tx_queue(priv, queue);
+		napi_enable(&ch->rxtx_napi);
 
 		err = stmmac_xsk_wakeup(priv->dev, queue, XDP_WAKEUP_RX);
 		if (err)
@@ -72,10 +72,10 @@ static int stmmac_xdp_disable_pool(struc
 	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
 
 	if (need_update) {
+		napi_disable(&ch->rxtx_napi);
 		stmmac_disable_rx_queue(priv, queue);
 		stmmac_disable_tx_queue(priv, queue);
 		synchronize_rcu();
-		napi_disable(&ch->rxtx_napi);
 	}
 
 	xsk_pool_dma_unmap(pool, STMMAC_RX_DMA_ATTR);
@@ -83,10 +83,10 @@ static int stmmac_xdp_disable_pool(struc
 	clear_bit(queue, priv->af_xdp_zc_qps);
 
 	if (need_update) {
-		napi_enable(&ch->rx_napi);
-		napi_enable(&ch->tx_napi);
 		stmmac_enable_rx_queue(priv, queue);
 		stmmac_enable_tx_queue(priv, queue);
+		napi_enable(&ch->rx_napi);
+		napi_enable(&ch->tx_napi);
 	}
 
 	return 0;


