Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914273B6311
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhF1Ova (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236459AbhF1OtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D419761D1D;
        Mon, 28 Jun 2021 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891016;
        bh=TBy26R4W5eE79CEI106NzZ33pCFVzglJfyIVJcNhHW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcCGJP0+NPJ5/xusvSs1DIA2RYJk+D+D6q6D8jD8Gt93l0Ej9eTQm2/0UgZJU0tS6
         EH4SOHy/MLcdII/6zPunbirk3WYiEM0Zl5gDBrheAxLaw3XTGe1M+8EjxCiNOxKEHq
         38MlJzpv/wxILTqWX0s1EsUr2oGMEZEwoqEG2fBYs0RR/IDkstys8F4OSSIbo51AYE
         cz5tWM3Q7yIp6Cc65Tpjo7J7O5ekM3ZNlL7njCx0QjJJI/5ncxSoPitqTOySIv2/Nh
         zSboM2shhs9DHbJ9Xi1lShPHRyS168mf3XvX2jhepWHsncuGE+a5cNu1FPF/G9fKDd
         YHD/3Q6SNuqvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/88] net: stmmac: dwmac1000: Fix extended MAC address registers definition
Date:   Mon, 28 Jun 2021 10:35:29 -0400
Message-Id: <20210628143628.33342-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index c02d36629c52..6f7ed3aaff1b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -87,10 +87,10 @@ enum power_event {
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

