Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276F13B6441
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhF1PGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235805AbhF1PEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:04:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5535A61CD4;
        Mon, 28 Jun 2021 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891394;
        bh=uz0OC/weR22y1hypAiWrhECNXa73YpaPd3rI0KJIFwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRHKFIr5VxZHwgsNsKI2Lwou9SQsnf/FWcZ08xWcEYFBLptysWJ8RURoTpYB8u7CF
         xTVEskGYMAoc4ADjJrK6vHG4GjkNehZoH1on2iIG+iTnXioROI/fQMu1CFIxHUksmH
         Dm+Se1FTZGB/g+4rFsJt47vI6hYeA3nyRmdGyv0yExw3tFX8t9nRlcAqrrZkFX/Xsa
         PV/n7gZV/xkVyRnu/NTM+sA4l5mQHG1+mlbkSvx4H3+hf/PqZx5vjg6ENbPrn6ACcy
         qTNA/hkTE1KNJhtFItZwYNF3gtxXAlOQPTt7gv+NKLjdsuAmSIENjD+brAlgRzu+6L
         P2JsVxbi+kTUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 19/57] net: stmmac: dwmac1000: Fix extended MAC address registers definition
Date:   Mon, 28 Jun 2021 10:42:18 -0400
Message-Id: <20210628144256.34524-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index b3fe0575ff6b..db2a341ae4b3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -83,10 +83,10 @@ enum power_event {
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
 
 /* PCS registers (AN/TBI/SGMII/RGMII) offset */
-- 
2.30.2

