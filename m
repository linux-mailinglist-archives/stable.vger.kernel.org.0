Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28C549A413
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371218AbiAYAHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2365132AbiAXXuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2895AC0417CF;
        Mon, 24 Jan 2022 13:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD7461491;
        Mon, 24 Jan 2022 21:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2722C340E4;
        Mon, 24 Jan 2022 21:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060650;
        bh=eXynGo+KjFto3C/Buumq3unNrllJ5PYHTL/A30vhd9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTJvxR8tndHQ8hHZNn5J3kBbn+sHhDLWn/1SfINzoTerSf1V108tpkCK5T2SNeNjP
         25pa23UjZqUIahRYB612FwCQB24rbSUqzIi8OVILf9ikx3+waa8LDQjpFdOAkJFoK6
         BF5z/yW5jKHAN8SG1/1kq+UAU3fXAryjNU71wOm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 1019/1039] net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into account
Date:   Mon, 24 Jan 2022 19:46:48 +0100
Message-Id: <20220124184159.548689447@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 1771afd47430f5e95c9c3a2e3a8a63e67402d3fe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c      |    6 +++---
 drivers/net/ethernet/ti/cpsw_new.c  |    6 +++---
 drivers/net/ethernet/ti/cpsw_priv.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -349,7 +349,7 @@ static void cpsw_rx_handler(void *token,
 	struct cpsw_common	*cpsw = ndev_to_cpsw(xmeta->ndev);
 	int			pkt_size = cpsw->rx_packet_max;
 	int			ret = 0, port, ch = xmeta->ch;
-	int			headroom = CPSW_HEADROOM;
+	int			headroom = CPSW_HEADROOM_NA;
 	struct net_device	*ndev = xmeta->ndev;
 	struct cpsw_priv	*priv;
 	struct page_pool	*pool;
@@ -392,7 +392,7 @@ static void cpsw_rx_handler(void *token,
 	}
 
 	if (priv->xdp_prog) {
-		int headroom = CPSW_HEADROOM, size = len;
+		int size = len;
 
 		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
@@ -442,7 +442,7 @@ requeue:
 	xmeta->ndev = ndev;
 	xmeta->ch = ch;
 
-	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
+	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
 	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
 				       pkt_size, 0);
 	if (ret < 0) {
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -283,7 +283,7 @@ static void cpsw_rx_handler(void *token,
 {
 	struct page *new_page, *page = token;
 	void *pa = page_address(page);
-	int headroom = CPSW_HEADROOM;
+	int headroom = CPSW_HEADROOM_NA;
 	struct cpsw_meta_xdp *xmeta;
 	struct cpsw_common *cpsw;
 	struct net_device *ndev;
@@ -336,7 +336,7 @@ static void cpsw_rx_handler(void *token,
 	}
 
 	if (priv->xdp_prog) {
-		int headroom = CPSW_HEADROOM, size = len;
+		int size = len;
 
 		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
@@ -386,7 +386,7 @@ requeue:
 	xmeta->ndev = ndev;
 	xmeta->ch = ch;
 
-	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
+	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
 	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
 				       pkt_size, 0);
 	if (ret < 0) {
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1120,7 +1120,7 @@ int cpsw_fill_rx_channels(struct cpsw_pr
 			xmeta->ndev = priv->ndev;
 			xmeta->ch = ch;
 
-			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM;
+			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM_NA;
 			ret = cpdma_chan_idle_submit_mapped(cpsw->rxv[ch].ch,
 							    page, dma,
 							    cpsw->rx_packet_max,


