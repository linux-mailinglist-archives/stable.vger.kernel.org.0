Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C7D3961CA
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhEaOqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233400AbhEaOnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EBC061C7B;
        Mon, 31 May 2021 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469287;
        bh=HiOvjCQCv3zPlI3AUKE8DHyP5utmuZ4ksqp3ezGvYmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGW1jfWcaWu/NcU53EAKUfnWNFi/OAfPjekc9vRt36wkiJDmih+4cgvx/veT642JB
         QxSMjVyvNr+pX9DKmkQJJJ9qOqrFFtfFZ9o+s1O1EsaMZNE6ag6VMtpn+M4b9mppyV
         P3tsdNuuCJ8WCYo+MrdB5mLjMvs45uYXyTU0pQcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 141/296] net: dsa: bcm_sf2: Fix bcm_sf2_reg_rgmii_cntrl() call for non-RGMII port
Date:   Mon, 31 May 2021 15:13:16 +0200
Message-Id: <20210531130708.617807416@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit fc516d3a6aa2c6ffe27d0da8818d13839e023e7e upstream.

We cannot call bcm_sf2_reg_rgmii_cntrl() for a port that is not RGMII,
yet we do that in bcm_sf2_sw_mac_link_up() irrespective of the port's
interface. Move that read until we have properly qualified the PHY
interface mode. This avoids triggering a warning on 7278 platforms that
have GMII ports.

Fixes: 55cfeb396965 ("net: dsa: bcm_sf2: add function finding RGMII register")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -775,11 +775,9 @@ static void bcm_sf2_sw_mac_link_up(struc
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		u32 reg_rgmii_ctrl;
+		u32 reg_rgmii_ctrl = 0;
 		u32 reg, offset;
 
-		reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
-
 		if (priv->type == BCM4908_DEVICE_ID ||
 		    priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
@@ -790,6 +788,7 @@ static void bcm_sf2_sw_mac_link_up(struc
 		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 		    interface == PHY_INTERFACE_MODE_MII ||
 		    interface == PHY_INTERFACE_MODE_REVMII) {
+			reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
 			reg = reg_readl(priv, reg_rgmii_ctrl);
 			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 


