Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9142039E38B
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhFGQ1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232554AbhFGQWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:22:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 433F3617C9;
        Mon,  7 Jun 2021 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082525;
        bh=6M14J6CtFD8EwL8AVyh0xyO2/A8lHu9pqqHuxDwPjv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccZcUlFzht6giexNrf9KduYyvG8XYFyQ6T4N1Jx6CTB+XYH589Q3XLA2J2VDjN8VV
         XE5Cp7BTYKabokbzCOk7uuYE8Zv+GNCfJbQAXE9fmyihZQqPq88ImmnIoB17FvoqPT
         hWYg29uErYriw05EhiLwqICgVxsjqBsLhL2fhIf+eFfA05JWIWCEdIhvXNhiY2y6pP
         j5AFTU6clOZBxvv8LViMOUKOApz/VFe3V2prv+XqapltZzaENdvaIYl7jYTBu6tfKs
         VkEn4o0fMazojXzsIefaBDQtDTxhjkTOMvzOLvakBNZgVk9bnz8e5LnINYUNZLQJz6
         aHJobr7+oN4WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Liu <liuyongqiang13@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 05/18] ARM: OMAP2+: Fix build warning when mmc_omap is not built
Date:   Mon,  7 Jun 2021 12:15:03 -0400
Message-Id: <20210607161517.3584577-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161517.3584577-1-sashal@kernel.org>
References: <20210607161517.3584577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Liu <liuyongqiang13@huawei.com>

[ Upstream commit 040ab72ee10ea88e1883ad143b3e2b77596abc31 ]

GCC reports the following warning with W=1:

arch/arm/mach-omap2/board-n8x0.c:325:19: warning:
variable 'index' set but not used [-Wunused-but-set-variable]
325 |  int bit, *openp, index;
    |                   ^~~~~

Fix this by moving CONFIG_MMC_OMAP to cover the rest codes
in the n8x0_mmc_callback().

Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/board-n8x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 20f25539d572..47abea1475d4 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -325,6 +325,7 @@ static int n8x0_mmc_get_cover_state(struct device *dev, int slot)
 
 static void n8x0_mmc_callback(void *data, u8 card_mask)
 {
+#ifdef CONFIG_MMC_OMAP
 	int bit, *openp, index;
 
 	if (board_is_n800()) {
@@ -342,7 +343,6 @@ static void n8x0_mmc_callback(void *data, u8 card_mask)
 	else
 		*openp = 0;
 
-#ifdef CONFIG_MMC_OMAP
 	omap_mmc_notify_cover_event(mmc_device, index, *openp);
 #else
 	pr_warn("MMC: notify cover event not available\n");
-- 
2.30.2

