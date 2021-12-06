Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DB1469F0B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391292AbhLFPpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390465AbhLFPmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B488C0A8868;
        Mon,  6 Dec 2021 07:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06187B8111C;
        Mon,  6 Dec 2021 15:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D416C34901;
        Mon,  6 Dec 2021 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804383;
        bh=iUq+OvZtEOq6qJ1FxHqpjzhSggg3oRz2LDjl4wcWOk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL9dn4T8mTxP1Me9AOsc3xgqsYiQ9qSl76Nw0es1+hRocyqyj5w2P0inSN1DLnQPe
         ROOVzDaeoU/BIm5/UjxzhSlCHe+rQW7zbWGIP12aVuprU/apvvVpYMybGse6Kby2YD
         wd0TT6qs2LS597nIF9BhCNnqAWjs6QKmbwelz/YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 127/207] net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split Header support
Date:   Mon,  6 Dec 2021 15:56:21 +0100
Message-Id: <20211206145614.637847627@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit f8e7dfd6fdabb831846ab1970a875746559d491b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5531,8 +5531,6 @@ static int stmmac_set_features(struct ne
 			       netdev_features_t features)
 {
 	struct stmmac_priv *priv = netdev_priv(netdev);
-	bool sph_en;
-	u32 chan;
 
 	/* Keep the COE Type in case of csum is supporting */
 	if (features & NETIF_F_RXCSUM)
@@ -5544,10 +5542,13 @@ static int stmmac_set_features(struct ne
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


