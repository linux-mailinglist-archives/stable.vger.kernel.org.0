Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6E3AED74
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhFUQUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhFUQTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C806124B;
        Mon, 21 Jun 2021 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292257;
        bh=Yapg4lD6t4xYPn1E22R3TbAZRwFcCbf66/XU1lmptiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=We+ZioUPcjzA/Z9pcSuLdAYtY40+t9Q9eEN+2f9M2SV/8lFOQDNWJl7dFMs3nC9eL
         AHulpUnwIdefhM+X5fLq20fAXCUOAABuD1QJIBJ5qtL/nLou0bKwan3MwQkRP/05bh
         SE1BlKNxP0BWV6QTLGPCQ7JtHli0TmIZuOazLgQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/90] net: stmmac: dwmac1000: Fix extended MAC address registers definition
Date:   Mon, 21 Jun 2021 18:14:58 +0200
Message-Id: <20210621154904.916571224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b70d44ac0990..3c73453725f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -76,10 +76,10 @@ enum power_event {
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



