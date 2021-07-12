Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C523D3C4769
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbhGLGcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236190AbhGLG3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62C4C60238;
        Mon, 12 Jul 2021 06:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071223;
        bh=Kirr2XwDqQz73EXYCxaEJgvQxfZ8RscfOnn0xySKMSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaIBhInxuJXSwrdu9UA7wbrMpYpui8TG9mR/oDQcwPL/3CF38ZSXMLiMOtBrst2Z/
         vJh/x5+oHOijIDPh5i8Z1n0x2K81KTevmL67bRyhUIPtuPvQvgqhf6xKswCEwvVpNq
         oy7bekuKFxGy7lmSmGkgy3jOX4wkKDkb/f5SeBwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 327/348] phy: uniphier-pcie: Fix updating phy parameters
Date:   Mon, 12 Jul 2021 08:11:51 +0200
Message-Id: <20210712060747.532234715@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 4a90bbb478dbf18ecdec9dcf8eb708e319d24264 ]

The current driver uses a value from register TEST_O as the original
value for register TEST_I, though, the value is overwritten by "param",
so there is a bug that the original value isn't no longer used.

The value of TEST_O[7:0] should be masked with "mask", replaced with
"param", and placed in the bitfield TESTI_DAT_MASK as new TEST_I value.

Fixes: c6d9b1324159 ("phy: socionext: add PCIe PHY driver support")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1623037842-19363-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/socionext/phy-uniphier-pcie.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/socionext/phy-uniphier-pcie.c b/drivers/phy/socionext/phy-uniphier-pcie.c
index 93ffbd2940fa..0bad0e01279a 100644
--- a/drivers/phy/socionext/phy-uniphier-pcie.c
+++ b/drivers/phy/socionext/phy-uniphier-pcie.c
@@ -20,11 +20,13 @@
 
 /* PHY */
 #define PCL_PHY_TEST_I		0x2000
-#define PCL_PHY_TEST_O		0x2004
 #define TESTI_DAT_MASK		GENMASK(13, 6)
 #define TESTI_ADR_MASK		GENMASK(5, 1)
 #define TESTI_WR_EN		BIT(0)
 
+#define PCL_PHY_TEST_O		0x2004
+#define TESTO_DAT_MASK		GENMASK(7, 0)
+
 #define PCL_PHY_RESET		0x200c
 #define PCL_PHY_RESET_N_MNMODE	BIT(8)	/* =1:manual */
 #define PCL_PHY_RESET_N		BIT(0)	/* =1:deasssert */
@@ -72,11 +74,12 @@ static void uniphier_pciephy_set_param(struct uniphier_pciephy_priv *priv,
 	val  = FIELD_PREP(TESTI_DAT_MASK, 1);
 	val |= FIELD_PREP(TESTI_ADR_MASK, reg);
 	uniphier_pciephy_testio_write(priv, val);
-	val = readl(priv->base + PCL_PHY_TEST_O);
+	val = readl(priv->base + PCL_PHY_TEST_O) & TESTO_DAT_MASK;
 
 	/* update value */
-	val &= ~FIELD_PREP(TESTI_DAT_MASK, mask);
-	val  = FIELD_PREP(TESTI_DAT_MASK, mask & param);
+	val &= ~mask;
+	val |= mask & param;
+	val = FIELD_PREP(TESTI_DAT_MASK, val);
 	val |= FIELD_PREP(TESTI_ADR_MASK, reg);
 	uniphier_pciephy_testio_write(priv, val);
 	uniphier_pciephy_testio_write(priv, val | TESTI_WR_EN);
-- 
2.30.2



