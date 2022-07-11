Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB96D56FBB1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiGKJet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiGKJdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECF64A805;
        Mon, 11 Jul 2022 02:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F019861211;
        Mon, 11 Jul 2022 09:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7B2C34115;
        Mon, 11 Jul 2022 09:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531089;
        bh=TpOOyILXwNDLE/XBw7fTsT1Ty6fmSAT2o3InDr9Alx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqtGRged3iFM5kZJ1FohNj81mpO7rMjg4T8PLZCBNKayhiUiFWyeFIIpAQ2HfhwtE
         XBDZN5oPhJu0ccjKrtCL671HDV6025N96tm7BgSrFl+z87XkKLaRwJKyBZz2GhfndE
         9CMpXIdCT7kikXyGVxRB2Qgnxb/z0xERx8gjFmus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 093/112] r8169: fix accessing unset transport header
Date:   Mon, 11 Jul 2022 11:07:33 +0200
Message-Id: <20220711090552.210907375@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit faa4e04e5e140a6d02260289a8fba8fd8d7a3003 ]

66e4c8d95008 ("net: warn if transport header was not set") added
a check that triggers a warning in r8169, see [0].

The commit referenced in the Fixes tag refers to the change from
which the patch applies cleanly, there's nothing wrong with this
commit. It seems the actual issue (not bug, because the warning
is harmless here) was introduced with bdfa4ed68187
("r8169: use Giant Send").

[0] https://bugzilla.kernel.org/show_bug.cgi?id=216157

Fixes: 8d520b4de3ed ("r8169: work around RTL8125 UDP hw bug")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Tested-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/1b2c2b29-3dc0-f7b6-5694-97ec526d51a0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 33f5c5698ccb..642e435c7031 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4190,7 +4190,6 @@ static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
 static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 				struct sk_buff *skb, u32 *opts)
 {
-	u32 transport_offset = (u32)skb_transport_offset(skb);
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	u32 mss = shinfo->gso_size;
 
@@ -4207,7 +4206,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 			WARN_ON_ONCE(1);
 		}
 
-		opts[0] |= transport_offset << GTTCPHO_SHIFT;
+		opts[0] |= skb_transport_offset(skb) << GTTCPHO_SHIFT;
 		opts[1] |= mss << TD1_MSS_SHIFT;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 ip_protocol;
@@ -4235,7 +4234,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 		else
 			WARN_ON_ONCE(1);
 
-		opts[1] |= transport_offset << TCPHO_SHIFT;
+		opts[1] |= skb_transport_offset(skb) << TCPHO_SHIFT;
 	} else {
 		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
 
@@ -4402,14 +4401,13 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 						struct net_device *dev,
 						netdev_features_t features)
 {
-	int transport_offset = skb_transport_offset(skb);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (skb_is_gso(skb)) {
 		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
 			features = rtl8168evl_fix_tso(skb, features);
 
-		if (transport_offset > GTTCPHO_MAX &&
+		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_ALL_TSO;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -4420,7 +4418,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 		if (rtl_quirk_packet_padto(tp, skb))
 			features &= ~NETIF_F_CSUM_MASK;
 
-		if (transport_offset > TCPHO_MAX &&
+		if (skb_transport_offset(skb) > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_CSUM_MASK;
 	}
-- 
2.35.1



