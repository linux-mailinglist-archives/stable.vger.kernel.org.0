Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD593A6449
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhFNLWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236107AbhFNLUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7B0661476;
        Mon, 14 Jun 2021 10:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667911;
        bh=WzbHPJH1jThMmcmFAYZbvNRc1O1KAViqzOLf2jjuhcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/QsA5h2BfYdINiJc6IacxsFO2psZgnh7QubON2x2KK5OCXiWNRn7i/oVWSGH6ejJ
         4WBxBu16GlAnjKl4XJmoiaO+2L0FMJmRP80FF0FDxG6Qsi7g9YGVxgVRiEMfCMe6ZW
         MEswisxIDp6Wj87nKXpHfCH5t1F3N8lprUIUwa7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 122/173] regulator: rtmv20: Fix .set_current_limit/.get_current_limit callbacks
Date:   Mon, 14 Jun 2021 12:27:34 +0200
Message-Id: <20210614102702.231410644@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 86ab21cc39e6b99b7065ab9008c90bec5dec535a upstream.

Current code does not set .curr_table and .n_linear_ranges settings,
so it cannot use the regulator_get/set_current_limit_regmap helpers.
If we setup the curr_table, it will has 200 entries.
Implement customized .set_current_limit/.get_current_limit callbacks
instead.

Fixes: b8c054a5eaf0 ("regulator: rtmv20: Adds support for Richtek RTMV20 load switch regulator")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/20210530124101.477727-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/rtmv20-regulator.c |   42 +++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

--- a/drivers/regulator/rtmv20-regulator.c
+++ b/drivers/regulator/rtmv20-regulator.c
@@ -103,9 +103,47 @@ static int rtmv20_lsw_disable(struct reg
 	return 0;
 }
 
+static int rtmv20_lsw_set_current_limit(struct regulator_dev *rdev, int min_uA,
+					int max_uA)
+{
+	int sel;
+
+	if (min_uA > RTMV20_LSW_MAXUA || max_uA < RTMV20_LSW_MINUA)
+		return -EINVAL;
+
+	if (max_uA > RTMV20_LSW_MAXUA)
+		max_uA = RTMV20_LSW_MAXUA;
+
+	sel = (max_uA - RTMV20_LSW_MINUA) / RTMV20_LSW_STEPUA;
+
+	/* Ensure the selected setting is still in range */
+	if ((sel * RTMV20_LSW_STEPUA + RTMV20_LSW_MINUA) < min_uA)
+		return -EINVAL;
+
+	sel <<= ffs(rdev->desc->csel_mask) - 1;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->csel_reg,
+				  rdev->desc->csel_mask, sel);
+}
+
+static int rtmv20_lsw_get_current_limit(struct regulator_dev *rdev)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->csel_reg, &val);
+	if (ret)
+		return ret;
+
+	val &= rdev->desc->csel_mask;
+	val >>= ffs(rdev->desc->csel_mask) - 1;
+
+	return val * RTMV20_LSW_STEPUA + RTMV20_LSW_MINUA;
+}
+
 static const struct regulator_ops rtmv20_regulator_ops = {
-	.set_current_limit = regulator_set_current_limit_regmap,
-	.get_current_limit = regulator_get_current_limit_regmap,
+	.set_current_limit = rtmv20_lsw_set_current_limit,
+	.get_current_limit = rtmv20_lsw_get_current_limit,
 	.enable = rtmv20_lsw_enable,
 	.disable = rtmv20_lsw_disable,
 	.is_enabled = regulator_is_enabled_regmap,


