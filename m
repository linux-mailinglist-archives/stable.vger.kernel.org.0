Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E553A846B
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhFOPut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhFOPuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB646162D;
        Tue, 15 Jun 2021 15:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772116;
        bh=Bgbq1ht1Oi0zin+wGe0RHymOtoERst08ET+KjszKzFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGSeq7avusX3oQcdl6+VugsmI9/nHiZo6xy1OmfZYz/OpxUhGoB7reOu0DAZ5UlBh
         uHmZFzdulrdKQ+4g9XxdZnTwnuKJ/WpSkxGEpHf8biq6mBDzvynqkPSEp1drKxsq1+
         xAEbwG21ZtvQ4U6zkMZtGvgZkPPuZQUWChN10Aaly/NWi9hMmb+ZeMlWwq2BUCqxnn
         K22Kg18TAXXTkB5vB09rNQRA/eUiG/YTb/maNpOm6nvGu6ImcKxjRu8bNHDn3yL+tc
         76IFQaDfsLsWyJ0u4cUS5UUkGgLcd2W22OFUELO8oUiU1DYnGinMa8rPgADG0/V2fR
         QQBk9fZKo4ZDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 09/33] regulator: rtmv20: Fix to make regcache value first reading back from HW
Date:   Tue, 15 Jun 2021 11:48:00 -0400
Message-Id: <20210615154824.62044-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 46639a5e684edd0b80ae9dff220f193feb356277 ]

- Fix to make regcache value first reading back from HW.

Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/1622542155-6373-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rtmv20-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/rtmv20-regulator.c b/drivers/regulator/rtmv20-regulator.c
index 852fb2596ffd..b37c29c9fbbb 100644
--- a/drivers/regulator/rtmv20-regulator.c
+++ b/drivers/regulator/rtmv20-regulator.c
@@ -27,6 +27,7 @@
 #define RTMV20_REG_LDIRQ	0x30
 #define RTMV20_REG_LDSTAT	0x40
 #define RTMV20_REG_LDMASK	0x50
+#define RTMV20_MAX_REGS		(RTMV20_REG_LDMASK + 1)
 
 #define RTMV20_VID_MASK		GENMASK(7, 4)
 #define RICHTEK_VID		0x80
@@ -275,6 +276,7 @@ static const struct regmap_config rtmv20_regmap_config = {
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
 	.max_register = RTMV20_REG_LDMASK,
+	.num_reg_defaults_raw = RTMV20_MAX_REGS,
 
 	.writeable_reg = rtmv20_is_accessible_reg,
 	.readable_reg = rtmv20_is_accessible_reg,
-- 
2.30.2

