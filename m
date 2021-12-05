Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBA6468B1C
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhLENml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhLENml (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:42:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BEEC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 05:39:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D515B80E18
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6D6C341C5;
        Sun,  5 Dec 2021 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638711551;
        bh=HsH047zFhqksN7/fNRMNRwpVvXoqvDfmCLkqmklt7Aw=;
        h=Subject:To:Cc:From:Date:From;
        b=twObPNmmQJaYekMI53KjiXVgU7rzYA18sB0Lq8hMlITkhu5zGP18zR/0ze6L99wlA
         Lhp0beMk75qHPRqu4QI+8pqgMzZFTc8T4GfRBmcBLTpx8texTfsF2JyrT5BLRa19/L
         mNIYVZgUgnMnrQTr3NmO2N9ck/jQ23J3wTptCk3E=
Subject: FAILED: patch "[PATCH] net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split Header" failed to apply to 5.10-stable tree
To:     vincent.whitchurch@axis.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:39:08 +0100
Message-ID: <1638711548199241@kroah.com>
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

From f8e7dfd6fdabb831846ab1970a875746559d491b Mon Sep 17 00:00:00 2001
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Fri, 26 Nov 2021 16:51:15 +0100
Subject: [PATCH] net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split Header
 support

The driver assumes that split headers can be enabled/disabled without
stopping/starting the device, so it writes DMA_CHAN_CONTROL from
stmmac_set_features().  However, on my system (IP v5.10a without Split
Header support), simply writing DMA_CHAN_CONTROL when DMA is running
(for example, with the commands below) leads to a TX watchdog timeout.

 host$ socat TCP-LISTEN:1024,fork,reuseaddr - &
 device$ ethtool -K eth0 tso off
 device$ ethtool -K eth0 tso on
 device$ dd if=/dev/zero bs=1M count=10 | socat - TCP4:host:1024
 <tx watchdog timeout>

Note that since my IP is configured without Split Header support, the
driver always just reads and writes the same value to the
DMA_CHAN_CONTROL register.

I don't have access to any platforms with Split Header support so I
don't know if these writes to the DMA_CHAN_CONTROL while DMA is running
actually work properly on such systems.  I could not find anything in
the databook that says that DMA_CHAN_CONTROL should not be written when
the DMA is running.

But on systems without Split Header support, there is in any case no
need to call enable_sph() in stmmac_set_features() at all since SPH can
never be toggled, so we can avoid the watchdog timeout there by skipping
this call.

Fixes: 8c6fc097a2f4acf ("net: stmmac: gmac4+: Add Split Header support")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 748195697e5a..da8306f60730 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5540,8 +5540,6 @@ static int stmmac_set_features(struct net_device *netdev,
 			       netdev_features_t features)
 {
 	struct stmmac_priv *priv = netdev_priv(netdev);
-	bool sph_en;
-	u32 chan;
 
 	/* Keep the COE Type in case of csum is supporting */
 	if (features & NETIF_F_RXCSUM)
@@ -5553,10 +5551,13 @@ static int stmmac_set_features(struct net_device *netdev,
 	 */
 	stmmac_rx_ipc(priv, priv->hw);
 
-	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
+	if (priv->sph_cap) {
+		bool sph_en = (priv->hw->rx_csum > 0) && priv->sph;
+		u32 chan;
 
-	for (chan = 0; chan < priv->plat->rx_queues_to_use; chan++)
-		stmmac_enable_sph(priv, priv->ioaddr, sph_en, chan);
+		for (chan = 0; chan < priv->plat->rx_queues_to_use; chan++)
+			stmmac_enable_sph(priv, priv->ioaddr, sph_en, chan);
+	}
 
 	return 0;
 }

