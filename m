Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493D6579904
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbiGSL5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237523AbiGSL5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:57:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6404422C4;
        Tue, 19 Jul 2022 04:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B92261658;
        Tue, 19 Jul 2022 11:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7C0C341CA;
        Tue, 19 Jul 2022 11:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231800;
        bh=tNFsWT8r4Tv5ckavuaA5jHy/y482DqnuFr8g7YAfZy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChRl3SbHKcLwrg9pLRXqn5awapfEZLVEz7l0uhUAxSaWtjpsxMXrHbb2K24weXbCd
         3Q3FiqQeCXnEZ/pH5Pi6paSpyKxdWOspi63ArJeFf/9ph3+p86f0muphE/Hf7gIVS0
         16leWfwHuE0Elx2R7JCeIEwAm2Gy7guvCzGI2/rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 07/28] net: dsa: bcm_sf2: force pause link settings
Date:   Tue, 19 Jul 2022 13:53:45 +0200
Message-Id: <20220719114457.169545594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
References: <20220719114455.701304968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream.

The pause settings reported by the PHY should also be applied to the GMII port
status override otherwise the switch will not generate pause frames towards the
link partner despite the advertisement saying otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -600,7 +600,9 @@ static void bcm_sf2_sw_adjust_link(struc
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->port_sts[port].eee;
 	u32 id_mode_dis = 0, port_mode;
+	u16 lcl_adv = 0, rmt_adv = 0;
 	const char *str = NULL;
+	u8 flowctrl = 0;
 	u32 reg;
 
 	switch (phydev->interface) {
@@ -667,10 +669,27 @@ force_link:
 		break;
 	}
 
+	if (phydev->duplex == DUPLEX_FULL &&
+	    phydev->autoneg == AUTONEG_ENABLE) {
+		if (phydev->pause)
+			rmt_adv = LPA_PAUSE_CAP;
+		if (phydev->asym_pause)
+			rmt_adv |= LPA_PAUSE_ASYM;
+		if (phydev->advertising & ADVERTISED_Pause)
+			lcl_adv = ADVERTISE_PAUSE_CAP;
+		if (phydev->advertising & ADVERTISED_Asym_Pause)
+			lcl_adv |= ADVERTISE_PAUSE_ASYM;
+		flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+	}
+
 	if (phydev->link)
 		reg |= LINK_STS;
 	if (phydev->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (flowctrl & FLOW_CTRL_TX)
+		reg |= TXFLOW_CNTL;
+	if (flowctrl & FLOW_CTRL_RX)
+		reg |= RXFLOW_CNTL;
 
 	core_writel(priv, reg, CORE_STS_OVERRIDE_GMIIP_PORT(port));
 


