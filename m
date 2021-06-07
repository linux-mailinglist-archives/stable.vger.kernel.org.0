Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5565639E349
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhFGQWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232853AbhFGQUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BD3261432;
        Mon,  7 Jun 2021 16:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082496;
        bh=jHRM/4R/pQFCnYN0/rrh37kCWN38OC6C0X+sP8BxSxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNdJHwjKumxuVoTJvLwn2FKaGLczrRVpRTWQ8FfGOil4vvVASv5MQJPfYWwTDS9Yk
         xotarzQRE70z7jm0sDdX+Rzx5PRQl3YRb+FgJu95kktBoKayl5F2meD6S1btuC6ZXs
         FTq8Qgfz0Uh4dfROMm5clkd0EJ/JJ2xG5J48un3iXszqc0HS1Nksszd/cpWyDdSXQb
         YcFfvI9irt463/3jEV/54EfW0mfxWg31YtPpSAMF0uAi6H+aJs7Eolfmb8/oyY63qs
         1GCACjNxmzE50qfQ2iwYqoH/uiYfQuEjkcC9YITnP7MAwpLka0gArkPbnIX6kDH35p
         gV8AZLVSBOnpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Liu <liuyongqiang13@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/21] ARM: OMAP2+: Fix build warning when mmc_omap is not built
Date:   Mon,  7 Jun 2021 12:14:33 -0400
Message-Id: <20210607161448.3584332-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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
index 75bc18646df6..902e9df9b8bb 100644
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

