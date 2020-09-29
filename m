Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B18D27C7A9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbgI2Lza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730916AbgI2Lou (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22EC206F7;
        Tue, 29 Sep 2020 11:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379890;
        bh=KZQ9f2ThrYsBwnShTY4CzWONmYeLRS/jhAQMNxl6zo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wb7qcmOttUL+PyiaOq0v7VnWC3flzAxP3VUI5cSjHiKWg0Y1dVfFqhVejlFZFaJOo
         ce6OgarpGo56PrE3Ko+ByXWjgNj9ir1hUDKAYmRg4hhtbgQk0NlXNlN5FFf+b8VyJ7
         XZoJ+UPs7zinF5K7O3KDpklqVsQ6knpIGHE/UQn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 363/388] regulator: axp20x: fix LDO2/4 description
Date:   Tue, 29 Sep 2020 13:01:34 +0200
Message-Id: <20200929110028.039156867@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit fbb5a79d2fe7b01c6424fbbc04368373b1672d61 ]

Currently we wrongly set the mask of value of LDO2/4 both to the mask of
LDO2, and the LDO4 voltage configuration is left untouched. This leads
to conflict when LDO2/4 are both in use.

Fix this issue by setting different vsel_mask to both regulators.

Fixes: db4a555f7c4c ("regulator: axp20x: use defines for masks")
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Link: https://lore.kernel.org/r/20200923005142.147135-1-icenowy@aosc.io
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/axp20x-regulator.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 16f0c85700360..7075f42b9fcf6 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -42,8 +42,9 @@
 
 #define AXP20X_DCDC2_V_OUT_MASK		GENMASK(5, 0)
 #define AXP20X_DCDC3_V_OUT_MASK		GENMASK(7, 0)
-#define AXP20X_LDO24_V_OUT_MASK		GENMASK(7, 4)
+#define AXP20X_LDO2_V_OUT_MASK		GENMASK(7, 4)
 #define AXP20X_LDO3_V_OUT_MASK		GENMASK(6, 0)
+#define AXP20X_LDO4_V_OUT_MASK		GENMASK(3, 0)
 #define AXP20X_LDO5_V_OUT_MASK		GENMASK(7, 4)
 
 #define AXP20X_PWR_OUT_EXTEN_MASK	BIT_MASK(0)
@@ -544,14 +545,14 @@ static const struct regulator_desc axp20x_regulators[] = {
 		 AXP20X_PWR_OUT_CTRL, AXP20X_PWR_OUT_DCDC3_MASK),
 	AXP_DESC_FIXED(AXP20X, LDO1, "ldo1", "acin", 1300),
 	AXP_DESC(AXP20X, LDO2, "ldo2", "ldo24in", 1800, 3300, 100,
-		 AXP20X_LDO24_V_OUT, AXP20X_LDO24_V_OUT_MASK,
+		 AXP20X_LDO24_V_OUT, AXP20X_LDO2_V_OUT_MASK,
 		 AXP20X_PWR_OUT_CTRL, AXP20X_PWR_OUT_LDO2_MASK),
 	AXP_DESC(AXP20X, LDO3, "ldo3", "ldo3in", 700, 3500, 25,
 		 AXP20X_LDO3_V_OUT, AXP20X_LDO3_V_OUT_MASK,
 		 AXP20X_PWR_OUT_CTRL, AXP20X_PWR_OUT_LDO3_MASK),
 	AXP_DESC_RANGES(AXP20X, LDO4, "ldo4", "ldo24in",
 			axp20x_ldo4_ranges, AXP20X_LDO4_V_OUT_NUM_VOLTAGES,
-			AXP20X_LDO24_V_OUT, AXP20X_LDO24_V_OUT_MASK,
+			AXP20X_LDO24_V_OUT, AXP20X_LDO4_V_OUT_MASK,
 			AXP20X_PWR_OUT_CTRL, AXP20X_PWR_OUT_LDO4_MASK),
 	AXP_DESC_IO(AXP20X, LDO5, "ldo5", "ldo5in", 1800, 3300, 100,
 		    AXP20X_LDO5_V_OUT, AXP20X_LDO5_V_OUT_MASK,
-- 
2.25.1



