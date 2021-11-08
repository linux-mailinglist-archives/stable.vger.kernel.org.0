Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1533644A20C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240892AbhKIBQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240313AbhKIBMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:12:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B2E61A35;
        Tue,  9 Nov 2021 01:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419924;
        bh=EiK1Q/68IY129PrOUGnJGHjqgdC2UACaw6JmorVVP+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GekT7mlBh3itipuoRlrHiFMVtTsHNwoTi4TvFPdhJdpgqAghyHb/ohyTVHrhc9/xb
         aoTzYScw9TO9Gw/vOetl/uLabNqW2UQT0Gqk71R93e+PwcX9ofUIfjly8DpkA2OQeu
         1tWp7QsTV2eecamkqoNH1C1DzsgkmeVrlD64fi75E7p1SD68mFI/VOWIGhiYIZJfgy
         jmDBjZGa6ZnQz21Mw9N2QiWIDiIK+xfKsnZgvUpmm2M3lzTPXSnnkqgj4NglhD5jOl
         1IrzxA7bO3MjPf1PIx8nFORneK3TsxQTyF/PYhiVV9Fv10LuRdNxl0TDhh09E2m2e1
         L9l0gY81jncug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, hauke@hauke-m.de, maz@kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/47] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 12:49:49 -0500
Message-Id: <20211108175031.1190422-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit c12aa581f6d5e80c3c3675ab26a52c2b3b62f76e ]

Reading the DMA registers immediately after the reset causes
Data Bus Error. Adding a small delay fixes this issue.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 664f2f7f55c1c..45a622b72cd13 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 
 #include <lantiq_soc.h>
@@ -233,6 +234,8 @@ ltq_dma_init(struct platform_device *pdev)
 	clk_enable(clk);
 	ltq_dma_w32_mask(0, DMA_RESET, LTQ_DMA_CTRL);
 
+	usleep_range(1, 10);
+
 	/* disable all interrupts */
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
-- 
2.33.0

