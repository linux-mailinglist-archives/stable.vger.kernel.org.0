Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114E8E6949
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfJ0VHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729186AbfJ0VHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:07:32 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5EF208C0;
        Sun, 27 Oct 2019 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210451;
        bh=bCP1+fHmBV8/BGs0SY8FTbr8SneORJVTftd2CEs2aCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQsauK1A8yxXvx8imC+4SJ6e06Cv3mvaJotqOeCqXhSAi6yNyaRDsTb00OvIZjBU8
         5iF4mYEcIWxUtx7nSWrc35PVahhYdd3FT/sTI8Nh4zFxTDwvJFTaOC6IF6e6njUT3b
         6w+gzNtUk/T0HU9uTZNRK0XWrfeN+5IPKYs4NFSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 020/119] net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3
Date:   Sun, 27 Oct 2019 21:59:57 +0100
Message-Id: <20191027203306.038747087@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit efb86fede98cdc70b674692ff617b1162f642c49 ]

The RGMII_MODE_EN bit value was 0 for GENET versions 1 through 3, and
became 6 for GENET v4 and above, account for that difference.

Fixes: aa09677cba42 ("net: bcmgenet: add MDIO routines")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |    1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c   |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -368,6 +368,7 @@ struct bcmgenet_mib_counters {
 #define  EXT_PWR_DOWN_PHY_EN		(1 << 20)
 
 #define EXT_RGMII_OOB_CTRL		0x0C
+#define  RGMII_MODE_EN_V123		(1 << 0)
 #define  RGMII_LINK			(1 << 4)
 #define  OOB_DISABLE			(1 << 5)
 #define  RGMII_MODE_EN			(1 << 6)
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -277,7 +277,11 @@ int bcmgenet_mii_config(struct net_devic
 	 */
 	if (priv->ext_phy) {
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
-		reg |= RGMII_MODE_EN | id_mode_dis;
+		reg |= id_mode_dis;
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			reg |= RGMII_MODE_EN_V123;
+		else
+			reg |= RGMII_MODE_EN;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
 


