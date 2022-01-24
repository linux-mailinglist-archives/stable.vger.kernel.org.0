Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A6249814E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiAXNnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiAXNnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:43:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AC6C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:43:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D5BFB80FBD
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCFDC340E1;
        Mon, 24 Jan 2022 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643031814;
        bh=9EQ8E3kUUifj41sGaq6hwwQi79PJar+XXCISD/vS7QM=;
        h=Subject:To:Cc:From:Date:From;
        b=RFMraG4ojDF4QheKyaerDWBPmAsvpqdEGZRn4Rc59VeJ0Y/omzpuyMaIn94XN0ty5
         6uMPXI+FBnMBdxOkbL6kkmcUSfTKJ2+7JwHuu5yeafiFqrHWFLZA/d75dn8LJooMcI
         C4myMljiLom9DA8lBX0HWAC5xDj0SfXrm5AMplT0=
Subject: FAILED: patch "[PATCH] net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into" failed to apply to 5.10-stable tree
To:     ardb@kernel.org, davem@davemloft.net, grygorii.strashko@ti.com,
        ilias.apalodimas@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:43:23 +0100
Message-ID: <164303180380217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1771afd47430f5e95c9c3a2e3a8a63e67402d3fe Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 18 Jan 2022 11:22:04 +0100
Subject: [PATCH] net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into
 account

Both versions of the CPSW driver declare a CPSW_HEADROOM_NA macro that
takes NET_IP_ALIGN into account, but fail to use it appropriately when
storing incoming packets in memory. This results in the IPv4 source and
destination addresses to appear misaligned in memory, which causes
aligment faults that need to be fixed up in software.

So let's switch from CPSW_HEADROOM to CPSW_HEADROOM_NA where needed.
This gets rid of any alignment faults on the RX path on a Beaglebone
White.

Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 33142d505fc8..03575c017500 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -349,7 +349,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	struct cpsw_common	*cpsw = ndev_to_cpsw(xmeta->ndev);
 	int			pkt_size = cpsw->rx_packet_max;
 	int			ret = 0, port, ch = xmeta->ch;
-	int			headroom = CPSW_HEADROOM;
+	int			headroom = CPSW_HEADROOM_NA;
 	struct net_device	*ndev = xmeta->ndev;
 	struct cpsw_priv	*priv;
 	struct page_pool	*pool;
@@ -392,7 +392,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
-		int headroom = CPSW_HEADROOM, size = len;
+		int size = len;
 
 		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
@@ -442,7 +442,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	xmeta->ndev = ndev;
 	xmeta->ch = ch;
 
-	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
+	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
 	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
 				       pkt_size, 0);
 	if (ret < 0) {
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 279e261e4720..bd4b1528cf99 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -283,7 +283,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 {
 	struct page *new_page, *page = token;
 	void *pa = page_address(page);
-	int headroom = CPSW_HEADROOM;
+	int headroom = CPSW_HEADROOM_NA;
 	struct cpsw_meta_xdp *xmeta;
 	struct cpsw_common *cpsw;
 	struct net_device *ndev;
@@ -336,7 +336,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
-		int headroom = CPSW_HEADROOM, size = len;
+		int size = len;
 
 		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
@@ -386,7 +386,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	xmeta->ndev = ndev;
 	xmeta->ch = ch;
 
-	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
+	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
 	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
 				       pkt_size, 0);
 	if (ret < 0) {
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 3537502e5e8b..ba220593e6db 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1122,7 +1122,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 			xmeta->ndev = priv->ndev;
 			xmeta->ch = ch;
 
-			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM;
+			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM_NA;
 			ret = cpdma_chan_idle_submit_mapped(cpsw->rxv[ch].ch,
 							    page, dma,
 							    cpsw->rx_packet_max,

