Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C0D44A328
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbhKIB0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243211AbhKIBVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6C761B07;
        Tue,  9 Nov 2021 01:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420096;
        bh=CaBHb5y99m3Qd8zy0Hrg4tV9zHkZUHAhNx8botNcBZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLuviWrf+RMX8kA60M2ZkPA+yAp7iTsdLwEVsnSGlf8H8Mhtwfgn3u+XBxVlr8jEc
         VfFpY97T5SLRmVn2Uu7zMN5fPfvXe4ZMWlLRwY/rH9/aJTWm7/7ylvcmXJnwWq5mT4
         8AIg88WqOSQCGur1kTteyUZvMYNimtk5Hmp0o6UCyVE6bvzcP0omKL0+jeVqAMewh3
         FbeIgJApS4duQuSxL8sUDc62AlMSOkB3P0UnxMLLazERy4lVTT92pmXFDxWsxWBqu8
         bbAStyqDrbHvjer+LIao09JWtF1XPrgRLBAsMM7LHFkTvL4TLWjIiHfDuD/ahrzaKW
         zOG9hzU9K3AqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, maz@kernel.org, hauke@hauke-m.de,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/33] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 20:07:38 -0500
Message-Id: <20211109010807.1191567-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
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
index cef811755123f..d89a9bcf92c85 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -21,6 +21,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 
 #include <lantiq_soc.h>
@@ -232,6 +233,8 @@ ltq_dma_init(struct platform_device *pdev)
 	clk_enable(clk);
 	ltq_dma_w32_mask(0, DMA_RESET, LTQ_DMA_CTRL);
 
+	usleep_range(1, 10);
+
 	/* disable all interrupts */
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
-- 
2.33.0

