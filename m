Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2658564E064
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiLOSNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiLOSMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D212ED5B
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DB77B81B0B
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77617C433D2;
        Thu, 15 Dec 2022 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127954;
        bh=Ks7Pu9BH/4SDd5cXF9QYsdfEFUtiGldA5zs/xJljKN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ky8hE1OVdDfKVb+/9+q5W6SWuQWf5NfdPUBysSriIlO1tkKucgvDof1qyFBDoc/Xt
         D2mqjFWOBt6sBlBeTXT9mCktFFRbccDjteDe8zQzwzvLwmbzBxSCAzwX+d+DIqppy7
         v90jX4a3M4tDR4ZiTrL2E8Okv49mfNAGEdCxDNL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/14] net: fec: dont reset irq coalesce settings to defaults on "ip link up"
Date:   Thu, 15 Dec 2022 19:10:47 +0100
Message-Id: <20221215172907.210669704@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit df727d4547de568302b0ed15b0d4e8a469bdb456 ]

Currently, when a FEC device is brought up, the irq coalesce settings
are reset to their default values (1000us, 200 frames). That's
unexpected, and breaks for example use of an appropriate .link file to
make systemd-udev apply the desired
settings (https://www.freedesktop.org/software/systemd/man/systemd.link.html),
or any other method that would do a one-time setup during early boot.

Refactor the code so that fec_restart() instead uses
fec_enet_itr_coal_set(), which simply applies the settings that are
stored in the private data, and initialize that private data with the
default values.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a829ba128b9d..351f7ef3bc8b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -72,7 +72,7 @@
 #include "fec.h"
 
 static void set_multicast_list(struct net_device *ndev);
-static void fec_enet_itr_coal_init(struct net_device *ndev);
+static void fec_enet_itr_coal_set(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
@@ -1163,8 +1163,7 @@ fec_restart(struct net_device *ndev)
 		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
-	fec_enet_itr_coal_init(ndev);
-
+	fec_enet_itr_coal_set(ndev);
 }
 
 static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
@@ -2760,19 +2759,6 @@ static int fec_enet_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-static void fec_enet_itr_coal_init(struct net_device *ndev)
-{
-	struct ethtool_coalesce ec;
-
-	ec.rx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.rx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	ec.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	fec_enet_set_coalesce(ndev, &ec, NULL, NULL);
-}
-
 static int fec_enet_get_tunable(struct net_device *netdev,
 				const struct ethtool_tunable *tuna,
 				void *data)
@@ -3526,6 +3512,10 @@ static int fec_enet_init(struct net_device *ndev)
 	fep->rx_align = 0x3;
 	fep->tx_align = 0x3;
 #endif
+	fep->rx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->tx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->rx_time_itr = FEC_ITR_ICTT_DEFAULT;
+	fep->tx_time_itr = FEC_ITR_ICTT_DEFAULT;
 
 	/* Check mask of the streaming and coherent API */
 	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
-- 
2.35.1



