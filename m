Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F137CDF4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbhELQ70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244060AbhELQma (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC6E61D1B;
        Wed, 12 May 2021 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835806;
        bh=lsjfootg/jtAdyH6K1xx+vOx6exyPiqV9fbXer3OXJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bZOKnx0ZE/bahg3uRMLMlq9mB3fZixiz81+KHDzJrDxiKS0xqJ2w3lfa0ePEhnBV
         Iak0gvnn31or/tqFpWWui3sLYlk+T2/H/qKpaiGF2PAsAL5vm+1LQMrGVTgQcD/HH/
         hwGqhvHpWP8aQuMF0ihp3e06sa2AaGzJ+elokfg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 457/677] net: dsa: bcm_sf2: fix BCM4908 RGMII reg(s)
Date:   Wed, 12 May 2021 16:48:23 +0200
Message-Id: <20210512144852.547104479@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6859d91549341c2ad769d482de58129f080c0f04 ]

BCM4908 has only 1 RGMII reg for controlling port 7.

Fixes: 73b7a6047971 ("net: dsa: bcm_sf2: support BCM4908's integrated switch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c      | 11 +++++++----
 drivers/net/dsa/bcm_sf2_regs.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index cd64b7f471b5..9c86cacc4a72 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -36,7 +36,12 @@ static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
 {
 	switch (priv->type) {
 	case BCM4908_DEVICE_ID:
-		/* TODO */
+		switch (port) {
+		case 7:
+			return REG_RGMII_11_CNTRL;
+		default:
+			break;
+		}
 		break;
 	default:
 		switch (port) {
@@ -1179,9 +1184,7 @@ static const u16 bcm_sf2_4908_reg_offsets[] = {
 	[REG_PHY_REVISION]	= 0x14,
 	[REG_SPHY_CNTRL]	= 0x24,
 	[REG_CROSSBAR]		= 0xc8,
-	[REG_RGMII_0_CNTRL]	= 0xe0,
-	[REG_RGMII_1_CNTRL]	= 0xec,
-	[REG_RGMII_2_CNTRL]	= 0xf8,
+	[REG_RGMII_11_CNTRL]	= 0x014c,
 	[REG_LED_0_CNTRL]	= 0x40,
 	[REG_LED_1_CNTRL]	= 0x4c,
 	[REG_LED_2_CNTRL]	= 0x58,
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index c7783cb45845..9e141d1a0b07 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -21,6 +21,7 @@ enum bcm_sf2_reg_offs {
 	REG_RGMII_0_CNTRL,
 	REG_RGMII_1_CNTRL,
 	REG_RGMII_2_CNTRL,
+	REG_RGMII_11_CNTRL,
 	REG_LED_0_CNTRL,
 	REG_LED_1_CNTRL,
 	REG_LED_2_CNTRL,
-- 
2.30.2



