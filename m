Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02E73B6270
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhF1Orl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhF1OmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61BB961CC0;
        Mon, 28 Jun 2021 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890819;
        bh=EVrBlPelXsMPhaLqpFwS7PJEuEFvz25UUEbaqvot6Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsLyY9129uHKTm6IDfq98Dj0WzkNk1ywC1Xo2OWBVz2nwj/bHwZwvnPdWtnXNfvJd
         fp7dUwZYwPCrUEoY2Rx1jj46o2hoVt91lrk+9LG7G9vxFEZLqwP78n5acn/mWBW7+A
         Bnd2MuqaZJUzTrsBlTCyV7CaY9BnqPUPtuU4UWWhoS/QShV56JrCbnktKqbaui9QVn
         YbOzCO3fpjZ8m2+hRiuPb24rWGR6/Lwv52OAkW/R3d0/b5WizQ3WORUj/bQBKvm+Ym
         Jd8SL1XQHJJuxr7sfaIlg9a91xx8xl05ZYgMbWZCa7ImSLKA9j7Yt1CJY1h6sKkAtW
         hcgHfuA24MWog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/109] net: stmmac: dwmac1000: Fix extended MAC address registers definition
Date:   Mon, 28 Jun 2021 10:31:52 -0400
Message-Id: <20210628143305.32978-37-sashal@kernel.org>
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

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 1adb20f0d496b2c61e9aa1f4761b8d71f93d258e ]

The register starts from 0x800 is the 16th MAC address register rather
than the first one.

Fixes: cffb13f4d6fb ("stmmac: extend mac addr reg and fix perfect filering")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 184ca13c8f79..1a84cf459e40 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -86,10 +86,10 @@ enum power_event {
 #define LPI_CTRL_STATUS_TLPIEN	0x00000001	/* Transmit LPI Entry */
 
 /* GMAC HW ADDR regs */
-#define GMAC_ADDR_HIGH(reg)	(((reg > 15) ? 0x00000800 : 0x00000040) + \
-				(reg * 8))
-#define GMAC_ADDR_LOW(reg)	(((reg > 15) ? 0x00000804 : 0x00000044) + \
-				(reg * 8))
+#define GMAC_ADDR_HIGH(reg)	((reg > 15) ? 0x00000800 + (reg - 16) * 8 : \
+				 0x00000040 + (reg * 8))
+#define GMAC_ADDR_LOW(reg)	((reg > 15) ? 0x00000804 + (reg - 16) * 8 : \
+				 0x00000044 + (reg * 8))
 #define GMAC_MAX_PERFECT_ADDRESSES	1
 
 #define GMAC_PCS_BASE		0x000000c0	/* PCS register base */
-- 
2.30.2

