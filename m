Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D973B621B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhF1OmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43895 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235515AbhF1OkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8228C61D0E;
        Mon, 28 Jun 2021 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890793;
        bh=jHRM/4R/pQFCnYN0/rrh37kCWN38OC6C0X+sP8BxSxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1FxACTRERzp/OdIbWkyWFdnQSfMo1jmkuQRgz4YEbm+lAFYhxQEi4pVRZ9fM+ZtU
         nRPOJ3VvrXZJAs87/1r43uaRmRjWP1XdaV430H/H2oMqugzdPakT/mvjFl2czFbg/n
         7zcQhfOFg5IPID1YYyQE4UTXsQ5r/fTX0vIhLujRP+sFtus2bcdDMdPdYEDIYQP+m4
         9xJ432wTQ/RmXbGQuksewHfmCeRGIx5r5TTD6EPZAfmM9rY24/zc6zotJUgwTlKfwP
         XozV2O1vrLd9ciczNsgJMV264uRl3aSgj9jFy/B169YwYaCoHUuBPRPClVS7pP/3tU
         eKvTSckioX5sQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Liu <liuyongqiang13@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/109] ARM: OMAP2+: Fix build warning when mmc_omap is not built
Date:   Mon, 28 Jun 2021 10:31:22 -0400
Message-Id: <20210628143305.32978-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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

