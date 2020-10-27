Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4A529C054
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817166AbgJ0ROD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784047AbgJ0O6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00BB920715;
        Tue, 27 Oct 2020 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810733;
        bh=69E8Seyv6a86xHAc8p4MZ5BoA0eDue29r0e7PxX8kcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDvTwZCgyQ4J7m4y5emDB8TbWHytNgmODHz+cj3QK5/63LdCkUERzT/07kVWVoq+U
         z/2Pu2eAr8EDgzsMMvEncaNvmq5Y6LQ6qjzRHluW1qSKrdwPuWyLxZhd0VoQjtCnhb
         xnC8aIb7FxD8PnNvG7stLP6lE7IeSDE81vKD1X0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Preston <thomas.preston@codethink.co.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 213/633] pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser
Date:   Tue, 27 Oct 2020 14:49:16 +0100
Message-Id: <20201027135532.672576844@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Preston <thomas.preston@codethink.co.uk>

[ Upstream commit b445f6237744df5e8d4f56f8733b2108c611220a ]

The mcp23x17_regmap is initialised with structs named "mcp23x16".
However, the mcp23s08 driver doesn't support the MCP23016 device yet, so
this appears to be a typo.

Fixes: 8f38910ba4f6 ("pinctrl: mcp23s08: switch to regmap caching")
Signed-off-by: Thomas Preston <thomas.preston@codethink.co.uk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20200828213226.1734264-2-thomas.preston@codethink.co.uk
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08.c b/drivers/pinctrl/pinctrl-mcp23s08.c
index 151931b593f6e..5641df67bcf55 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -87,7 +87,7 @@ const struct regmap_config mcp23x08_regmap = {
 };
 EXPORT_SYMBOL_GPL(mcp23x08_regmap);
 
-static const struct reg_default mcp23x16_defaults[] = {
+static const struct reg_default mcp23x17_defaults[] = {
 	{.reg = MCP_IODIR << 1,		.def = 0xffff},
 	{.reg = MCP_IPOL << 1,		.def = 0x0000},
 	{.reg = MCP_GPINTEN << 1,	.def = 0x0000},
@@ -98,23 +98,23 @@ static const struct reg_default mcp23x16_defaults[] = {
 	{.reg = MCP_OLAT << 1,		.def = 0x0000},
 };
 
-static const struct regmap_range mcp23x16_volatile_range = {
+static const struct regmap_range mcp23x17_volatile_range = {
 	.range_min = MCP_INTF << 1,
 	.range_max = MCP_GPIO << 1,
 };
 
-static const struct regmap_access_table mcp23x16_volatile_table = {
-	.yes_ranges = &mcp23x16_volatile_range,
+static const struct regmap_access_table mcp23x17_volatile_table = {
+	.yes_ranges = &mcp23x17_volatile_range,
 	.n_yes_ranges = 1,
 };
 
-static const struct regmap_range mcp23x16_precious_range = {
+static const struct regmap_range mcp23x17_precious_range = {
 	.range_min = MCP_GPIO << 1,
 	.range_max = MCP_GPIO << 1,
 };
 
-static const struct regmap_access_table mcp23x16_precious_table = {
-	.yes_ranges = &mcp23x16_precious_range,
+static const struct regmap_access_table mcp23x17_precious_table = {
+	.yes_ranges = &mcp23x17_precious_range,
 	.n_yes_ranges = 1,
 };
 
@@ -124,10 +124,10 @@ const struct regmap_config mcp23x17_regmap = {
 
 	.reg_stride = 2,
 	.max_register = MCP_OLAT << 1,
-	.volatile_table = &mcp23x16_volatile_table,
-	.precious_table = &mcp23x16_precious_table,
-	.reg_defaults = mcp23x16_defaults,
-	.num_reg_defaults = ARRAY_SIZE(mcp23x16_defaults),
+	.volatile_table = &mcp23x17_volatile_table,
+	.precious_table = &mcp23x17_precious_table,
+	.reg_defaults = mcp23x17_defaults,
+	.num_reg_defaults = ARRAY_SIZE(mcp23x17_defaults),
 	.cache_type = REGCACHE_FLAT,
 	.val_format_endian = REGMAP_ENDIAN_LITTLE,
 };
-- 
2.25.1



