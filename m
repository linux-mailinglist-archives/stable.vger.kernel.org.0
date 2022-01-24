Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BBB49A324
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366150AbiAXXwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844746AbiAXXKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137DCC0A0289;
        Mon, 24 Jan 2022 13:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF31CB8105C;
        Mon, 24 Jan 2022 21:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11577C340E4;
        Mon, 24 Jan 2022 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059106;
        bh=eBtV3ryZiXUZattGsksT7BmwOVTZlzKcXHsLCTSvJcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDeYySaXQv6nMdJkeBNJpFn3Uhc+znhd+GBL9D5cRkZ0EwYvyOvyT93KEyfL0nnTi
         IW27OQTkTuDaN8elrJSrWPXdDTbluylV58Bf1OCW5CQtXES+FIcNS7pg1aqoDKe5TK
         AG68GRV+Thi1DP5x6HWJ8JX68L9rrJxpGoLQ+uc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0505/1039] phy: uniphier-usb3ss: fix unintended writing zeros to PHY register
Date:   Mon, 24 Jan 2022 19:38:14 +0100
Message-Id: <20220124184142.248564599@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>

[ Upstream commit 898c7a9ec81620125f2463714a0f4dea18ad6e54 ]

Similar to commit 4a90bbb478db ("phy: uniphier-pcie: Fix updating phy
parameters"), in function uniphier_u3ssphy_set_param(), unintentionally
write zeros to other fields when writing PHY registers.

Fixes: 5ab43d0f8697 ("phy: socionext: add USB3 PHY driver for UniPhier SoC")
Signed-off-by: Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1640150369-4134-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/socionext/phy-uniphier-usb3ss.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/socionext/phy-uniphier-usb3ss.c b/drivers/phy/socionext/phy-uniphier-usb3ss.c
index 6700645bcbe6b..3b5ffc16a6947 100644
--- a/drivers/phy/socionext/phy-uniphier-usb3ss.c
+++ b/drivers/phy/socionext/phy-uniphier-usb3ss.c
@@ -22,11 +22,13 @@
 #include <linux/reset.h>
 
 #define SSPHY_TESTI		0x0
-#define SSPHY_TESTO		0x4
 #define TESTI_DAT_MASK		GENMASK(13, 6)
 #define TESTI_ADR_MASK		GENMASK(5, 1)
 #define TESTI_WR_EN		BIT(0)
 
+#define SSPHY_TESTO		0x4
+#define TESTO_DAT_MASK		GENMASK(7, 0)
+
 #define PHY_F(regno, msb, lsb) { (regno), (msb), (lsb) }
 
 #define CDR_CPD_TRIM	PHY_F(7, 3, 0)	/* RxPLL charge pump current */
@@ -84,12 +86,12 @@ static void uniphier_u3ssphy_set_param(struct uniphier_u3ssphy_priv *priv,
 	val  = FIELD_PREP(TESTI_DAT_MASK, 1);
 	val |= FIELD_PREP(TESTI_ADR_MASK, p->field.reg_no);
 	uniphier_u3ssphy_testio_write(priv, val);
-	val = readl(priv->base + SSPHY_TESTO);
+	val = readl(priv->base + SSPHY_TESTO) & TESTO_DAT_MASK;
 
 	/* update value */
-	val &= ~FIELD_PREP(TESTI_DAT_MASK, field_mask);
+	val &= ~field_mask;
 	data = field_mask & (p->value << p->field.lsb);
-	val  = FIELD_PREP(TESTI_DAT_MASK, data);
+	val  = FIELD_PREP(TESTI_DAT_MASK, data | val);
 	val |= FIELD_PREP(TESTI_ADR_MASK, p->field.reg_no);
 	uniphier_u3ssphy_testio_write(priv, val);
 	uniphier_u3ssphy_testio_write(priv, val | TESTI_WR_EN);
-- 
2.34.1



