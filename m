Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC2B39E3BF
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhFGQ1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234108AbhFGQZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CCA6194D;
        Mon,  7 Jun 2021 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082571;
        bh=pxaClpHo2JeNFeJc9tNtN5p4nba7pPshfC+5WI2WSIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7JnccWBKUBvqffwJrkuEouuStBtOF96DO0p8oy6MuIl74e8l2+imet0MgBVgMpku
         EztijqIhp0eHjKiFRV75WlIY4UpnCnfQZOhubebTF5DuvL0YJ3hKxR3mLBC/w5nXcU
         yqBwh2ZGpENs0pJzgb7xefBONW/5Mzv6+x4pC3kR4r6awAWUHxiFsovOF7/Id0SktR
         9hzuTzoFuEn/0aX49Fqf/CGcDlDHfI4Fooa2oMTZJfMXZOCC29G4qQN6bnrpWFW3RF
         DexxhMzUsic7WSByO6CDIW2Lo2CTL8IT9tbLPRfJ5tBKiLXsgkcKFedcwjoa2qeful
         S1wWWvK5WbxmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Liu <liuyongqiang13@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 04/14] ARM: OMAP2+: Fix build warning when mmc_omap is not built
Date:   Mon,  7 Jun 2021 12:15:55 -0400
Message-Id: <20210607161605.3584954-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161605.3584954-1-sashal@kernel.org>
References: <20210607161605.3584954-1-sashal@kernel.org>
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
index b6443a4e0c78..68af9d9566cb 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -328,6 +328,7 @@ static int n8x0_mmc_get_cover_state(struct device *dev, int slot)
 
 static void n8x0_mmc_callback(void *data, u8 card_mask)
 {
+#ifdef CONFIG_MMC_OMAP
 	int bit, *openp, index;
 
 	if (board_is_n800()) {
@@ -345,7 +346,6 @@ static void n8x0_mmc_callback(void *data, u8 card_mask)
 	else
 		*openp = 0;
 
-#ifdef CONFIG_MMC_OMAP
 	omap_mmc_notify_cover_event(mmc_device, index, *openp);
 #else
 	pr_warn("MMC: notify cover event not available\n");
-- 
2.30.2

