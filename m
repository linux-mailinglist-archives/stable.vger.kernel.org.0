Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C760B29C4B4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758672AbgJ0R4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900081AbgJ0OUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 415D7206F7;
        Tue, 27 Oct 2020 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808440;
        bh=VBveqTQRqqFBUP5e/jtDQ/vSTg8WLW6xhy6Cknv2CPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHT/GZ9fjO+Ek0zXHupUYPWhhzrOLIp3K70Ytj2FkMR65AzMcmfIzEQ5xCEhoCgMT
         cu8E9ohGmQBpSHBUm+V9YfQrJOQeV2mHk8e5CYAXmmaknRsVCoaOMzdracyrwIlV8W
         ppTGe3E4V1yV3RMC+OGjKYFgo98ZOC1R9jQjI1QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Preston <thomas.preston@codethink.co.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/264] pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser
Date:   Tue, 27 Oct 2020 14:52:31 +0100
Message-Id: <20201027135435.062239601@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 33c3eca0ece97..5f0cea13bb5ce 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -120,7 +120,7 @@ static const struct regmap_config mcp23x08_regmap = {
 	.max_register = MCP_OLAT,
 };
 
-static const struct reg_default mcp23x16_defaults[] = {
+static const struct reg_default mcp23x17_defaults[] = {
 	{.reg = MCP_IODIR << 1,		.def = 0xffff},
 	{.reg = MCP_IPOL << 1,		.def = 0x0000},
 	{.reg = MCP_GPINTEN << 1,	.def = 0x0000},
@@ -131,23 +131,23 @@ static const struct reg_default mcp23x16_defaults[] = {
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
 
@@ -157,10 +157,10 @@ static const struct regmap_config mcp23x17_regmap = {
 
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



