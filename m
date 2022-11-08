Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FB662151B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiKHOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiKHOIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:08:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B9377207
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:08:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A4F5B816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACD9C433D6;
        Tue,  8 Nov 2022 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916488;
        bh=mRUOpMgVsZbFretMPJn8o2SSQISLr/pV/H2BmjaycIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgOunLy6+ZTVFMWBjiEi0qGb7V4wnavHViyBW0DpikeGUqBWMiLaKYWohPNPgsRXC
         +nqcO59j62mxAWwu8CTJMz/y/zBv+Jm1sg/yRZ6JAw1PK7MSPd6EMxTEGwgSJu+oux
         eEX+lfgp9WJ1UpMnESYlQwBfMJBWzJc1jSkbliaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 037/197] net: lan966x: Fix FDMA when MTU is changed
Date:   Tue,  8 Nov 2022 14:37:55 +0100
Message-Id: <20221108133356.503691175@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 872ad758f9b7fb4eb42aebaf64e50c5b29b7ffe5 ]

When MTU is changed, FDMA is required to calculate what is the maximum
size of the frame that it can received. So it can calculate what is the
page order needed to allocate for the received frames.
The first problem was that, when the max MTU was calculated it was
reading the value from dev and not from HW, so in this way it was
missing L2 header + the FCS.
The other problem was that once the skb is created using
__build_skb_around, it would reserve some space for skb_shared_info.
So if we received a frame which size is at the limit of the page order
then the creating will failed because it would not have space to put all
the data.

Fixes: 2ea1cbac267e ("net: lan966x: Update FDMA to change MTU.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 8 ++++++--
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 69f741db25b1..407a6c125515 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -668,12 +668,14 @@ static int lan966x_fdma_get_max_mtu(struct lan966x *lan966x)
 	int i;
 
 	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		struct lan966x_port *port;
 		int mtu;
 
-		if (!lan966x->ports[i])
+		port = lan966x->ports[i];
+		if (!port)
 			continue;
 
-		mtu = lan966x->ports[i]->dev->mtu;
+		mtu = lan_rd(lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 		if (mtu > max_mtu)
 			max_mtu = mtu;
 	}
@@ -733,6 +735,8 @@ int lan966x_fdma_change_mtu(struct lan966x *lan966x)
 
 	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
 	max_mtu += IFH_LEN * sizeof(u32);
+	max_mtu += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	max_mtu += VLAN_HLEN * 2;
 
 	if (round_up(max_mtu, PAGE_SIZE) / PAGE_SIZE - 1 ==
 	    lan966x->rx.page_order)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 989e5f045d7e..4a3cb7579420 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -394,7 +394,7 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 
 	err = lan966x_fdma_change_mtu(lan966x);
 	if (err) {
-		lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(old_mtu),
+		lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(LAN966X_HW_MTU(old_mtu)),
 		       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 		dev->mtu = old_mtu;
 	}
-- 
2.35.1



