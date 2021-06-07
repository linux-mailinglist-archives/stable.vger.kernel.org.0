Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E3C39E1FD
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhFGQOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231579AbhFGQOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11834613CA;
        Mon,  7 Jun 2021 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082359;
        bh=uU3E+HpHiuf4G518xekdhVkqedtIxnVtoN6FngjHGNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mt9OQkf8W7jZFvYuHaHTqMQ1USjEqzzy0pQlLFe5qhMeBJdJysZzx3rUWMHZPH0Yw
         lPl0ztXzrMRpLjLIEsJ8htcza7LMFTVQYMtuTJpvmBLyT4yvxLnnVETCTISJsvTeid
         ztU1fSIid3DE/CtySUngObX7bx4JEh6IiV5n7teQyME+OFKL8XOlFxRh7v4uRv2Z6X
         cMPKOw6o0zRnB7mN7EQpS/3AJBiAaC/nrR7tfYftEiEUGRRtqNsXiiZkk2TYASn2oR
         9g7NGGyMX8rynlKMNay42Kk6EKHxSdr9uLOh9pr/5SwLk/C+ZJnQEiAOVQBM62H07z
         cjcfYgYgvdVLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Liu <liuyongqiang13@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 19/49] ARM: OMAP2+: Fix build warning when mmc_omap is not built
Date:   Mon,  7 Jun 2021 12:11:45 -0400
Message-Id: <20210607161215.3583176-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index 418a61ecb827..5e86145db0e2 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -322,6 +322,7 @@ static int n8x0_mmc_get_cover_state(struct device *dev, int slot)
 
 static void n8x0_mmc_callback(void *data, u8 card_mask)
 {
+#ifdef CONFIG_MMC_OMAP
 	int bit, *openp, index;
 
 	if (board_is_n800()) {
@@ -339,7 +340,6 @@ static void n8x0_mmc_callback(void *data, u8 card_mask)
 	else
 		*openp = 0;
 
-#ifdef CONFIG_MMC_OMAP
 	omap_mmc_notify_cover_event(mmc_device, index, *openp);
 #else
 	pr_warn("MMC: notify cover event not available\n");
-- 
2.30.2

