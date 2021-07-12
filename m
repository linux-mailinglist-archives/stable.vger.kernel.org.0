Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EE53C559C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhGLILM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353677AbhGLIDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CD9F6193D;
        Mon, 12 Jul 2021 07:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076649;
        bh=KlMGQ3e8uTVoH70/r1i913wVeQy3pNxxandWLFVh+yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmCqVkkI7bU4aROfxIcKKM1g+sb5OIjFHI92YNeUWZX53BbGwusb91GEOKuTcXXGZ
         oJL9f5P88yv6CTuHny6hpUmWMGp6ezlaSF8c0cEYaFopvWlh7LFJElpKreenxgqFOR
         FIeSJgTZ8Cu4gBTZ6X0O3eOl85lYPGW/CDRlSbNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 733/800] phy: uniphier-pcie: Fix updating phy parameters
Date:   Mon, 12 Jul 2021 08:12:36 +0200
Message-Id: <20210712061044.763426816@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index e4adab375c73..6bdbd1f214dd 100644
--- a/drivers/phy/socionext/phy-uniphier-pcie.c
+++ b/drivers/phy/socionext/phy-uniphier-pcie.c
@@ -24,11 +24,13 @@
 #define PORT_SEL_1		FIELD_PREP(PORT_SEL_MASK, 1)
 
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
@@ -77,11 +79,12 @@ static void uniphier_pciephy_set_param(struct uniphier_pciephy_priv *priv,
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



