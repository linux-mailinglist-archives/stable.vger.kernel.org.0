Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2D3A84B0
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhFOPvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232083AbhFOPvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F196162A;
        Tue, 15 Jun 2021 15:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772158;
        bh=Bgbq1ht1Oi0zin+wGe0RHymOtoERst08ET+KjszKzFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzhyoOi6dBesPjHRVp/s7wjTULpVjKi9Ji7PEexQnZsjnXzvo3OazeMpjOSoB+cDS
         jY5ZE+QmQt60ocxVS0DXJrO7ZUuPhjv/xcU7qCnwonkIcOcfPjnP6fwP/yagudJslA
         afTs7DZfkF2sfTUBlS5iM53GeUGus/lQZTvCXtExiZ8lkg1yc9CToeH84jb/PbLM3u
         yDoCp5lme2Z865RWFHLFeJS89rX8rVG7d62IIlerBpFjZfdHldIYyNnYxS7XQX+9sd
         Mpm1vGwFjHQEo0mL/L1hYd+m05wTvat9fWKIXmTNyLhIsodpX3gKMO9WvFvpoho/2m
         FQxye9Phoynmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 08/30] regulator: rtmv20: Fix to make regcache value first reading back from HW
Date:   Tue, 15 Jun 2021 11:48:45 -0400
Message-Id: <20210615154908.62388-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
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

