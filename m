Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773983C8CC4
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbhGNTmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234845AbhGNTmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55427613D3;
        Wed, 14 Jul 2021 19:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291572;
        bh=Iwss8JYoBbpqgUvs4YSAKBztaA5tyR/Exo15fPg9GUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q896TJFi457XtIVWvsAqjtqbjt675hNwqxLd5J4tsA8V4WZkrOf9cANJYCGvUk63r
         3syEcalt6I/mhObEj+IR6Go4Wn/oqH91OuD7SR+ZM4QB4fbZbRL4gf6xp3/j45XbHv
         rBe6PKfgrgoDOC9LdlGxmBXFVo4mX7dehXpiC92EyiLFQF1y9UCywKMZPSfwdlcB7m
         o4sc/4bZ64VgaOd+aNbUNuDvz1uErMi98Q5enoOlwBsOpRFGAM+b7sjDbfKby8deLp
         H6CjgLQH/6vr2WCtUJTxfgyTNanIhNzub21jGdbJPcQwGeA+y+raFeyDS6oBs4gvuu
         ASdlLe04mEd1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 063/108] memory: tegra: Fix compilation warnings on 64bit platforms
Date:   Wed, 14 Jul 2021 15:37:15 -0400
Message-Id: <20210714193800.52097-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit e0740fb869730110b36a4afcf05ad1b9d6f5fb6d ]

Fix compilation warning on 64bit platforms caused by implicit promotion
of 32bit signed integer to a 64bit unsigned value which happens after
enabling compile-testing of the EMC drivers.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra124-emc.c | 4 ++--
 drivers/memory/tegra/tegra30-emc.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
index 5699d909abc2..a21ca8e0841a 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -272,8 +272,8 @@
 #define EMC_PUTERM_ADJ				0x574
 
 #define DRAM_DEV_SEL_ALL			0
-#define DRAM_DEV_SEL_0				(2 << 30)
-#define DRAM_DEV_SEL_1				(1 << 30)
+#define DRAM_DEV_SEL_0				BIT(31)
+#define DRAM_DEV_SEL_1				BIT(30)
 
 #define EMC_CFG_POWER_FEATURES_MASK		\
 	(EMC_CFG_DYN_SREF | EMC_CFG_DRAM_ACPD | EMC_CFG_DRAM_CLKSTOP_SR | \
diff --git a/drivers/memory/tegra/tegra30-emc.c b/drivers/memory/tegra/tegra30-emc.c
index 829f6d673c96..a2f2738ccb94 100644
--- a/drivers/memory/tegra/tegra30-emc.c
+++ b/drivers/memory/tegra/tegra30-emc.c
@@ -150,8 +150,8 @@
 #define EMC_SELF_REF_CMD_ENABLED		BIT(0)
 
 #define DRAM_DEV_SEL_ALL			(0 << 30)
-#define DRAM_DEV_SEL_0				(2 << 30)
-#define DRAM_DEV_SEL_1				(1 << 30)
+#define DRAM_DEV_SEL_0				BIT(31)
+#define DRAM_DEV_SEL_1				BIT(30)
 #define DRAM_BROADCAST(num) \
 	((num) > 1 ? DRAM_DEV_SEL_ALL : DRAM_DEV_SEL_0)
 
-- 
2.30.2

