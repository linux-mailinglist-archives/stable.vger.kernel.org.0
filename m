Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B685D44A29E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbhKIBTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242292AbhKIBRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:17:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B13C619F7;
        Tue,  9 Nov 2021 01:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420017;
        bh=wAcq/QbrQa58HbAyjghxl82mV4OBsMbJuIOPp79spaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0gesT3uR2z/fiHBjhR16Q6ol++mRuMUdqX4LVr1Wwv5mCp7W9XU8bz6dUkw01ugL
         i8ZsXPDiApU0QT35oNjmtsASl63Yl1Buk/mkn6aCHNU0BockEdIUZAbySL5fZoQrmR
         A4FFBcNPkT9+V9c8oc0fmOWalNQ8LDlJfRi5w1F4Ls1gAQXSVd+o3vHyjQ74NmR/tG
         6iVClAHPeCBhbwNr+NKglJcRZq963W1Q3UJT9EhC5FPpxrr00Vnm1+QV+OU2H76jBu
         Ddh3xT5T6X/l07oYQKsvlZtPE7zX0lYc9q/SCT2nbq2TakrmS9nV0UfzBb6xTWwCQA
         bnZShyeI4j0cQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, hauke@hauke-m.de, maz@kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/39] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 20:06:14 -0500
Message-Id: <20211109010649.1191041-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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
index 805b3a6ab2d60..ce7e033b4bb18 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 
 #include <lantiq_soc.h>
@@ -234,6 +235,8 @@ ltq_dma_init(struct platform_device *pdev)
 	clk_enable(clk);
 	ltq_dma_w32_mask(0, DMA_RESET, LTQ_DMA_CTRL);
 
+	usleep_range(1, 10);
+
 	/* disable all interrupts */
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
-- 
2.33.0

