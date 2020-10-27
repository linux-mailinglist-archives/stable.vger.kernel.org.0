Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0637D29AFC2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900876AbgJ0OMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755981AbgJ0OKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:10:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C4D2072D;
        Tue, 27 Oct 2020 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807854;
        bh=hhoxEyIEZZvefeQxJwP97kWrbU1FsUOEFaAp6bXSetI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qhe4NuAT/SftHdjiMkPWs7gvr7osKQ3pkIt1R4r76M+oq8es8Q/bnwI2Hfyg3XeqQ
         14RE9EFi6SCCCUl3RAXv8QN1LePr5KwGk4HmGCt/q1z6zOrX9XjBip9v3578Qi7PHp
         jb+TGSCxkLi3YRuVsntGgk4AMXGl5x9VNYCRRd2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Preston <thomas.preston@codethink.co.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 064/191] pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser
Date:   Tue, 27 Oct 2020 14:48:39 +0100
Message-Id: <20201027134912.814390967@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
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
index 22558bf294246..12e7f7c54ffaa 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -119,7 +119,7 @@ static const struct regmap_config mcp23x08_regmap = {
 	.max_register = MCP_OLAT,
 };
 
-static const struct reg_default mcp23x16_defaults[] = {
+static const struct reg_default mcp23x17_defaults[] = {
 	{.reg = MCP_IODIR << 1,		.def = 0xffff},
 	{.reg = MCP_IPOL << 1,		.def = 0x0000},
 	{.reg = MCP_GPINTEN << 1,	.def = 0x0000},
@@ -130,23 +130,23 @@ static const struct reg_default mcp23x16_defaults[] = {
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
 
@@ -156,10 +156,10 @@ static const struct regmap_config mcp23x17_regmap = {
 
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



