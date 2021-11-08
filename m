Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C284144A0EC
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbhKIBGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241665AbhKIBEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:04:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1A896134F;
        Tue,  9 Nov 2021 01:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419705;
        bh=5TaTadUUlRIm99JBWT3Hg8pPrx4O+pzJ82CGst/LFJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR9PtkNepNw/FQCeWeEJy9CSf/UYxciMoZF5BlG5mFCbAGxjE32wSUekvqHqsCikG
         17++obtKqpKblUy9rs+Lg/5CyO7LpgcLqWPEP2Gr8uzeRmS2OBxjxqZWdPY7Nbjjgu
         F8kP6F1dMSOVieAt9xCFVY9NqkmZkI2sOrzEsM1ZURc+YNdP3ppN+kNWgWnF0+yCQA
         Cp5YoaK9FgE30LzE/iQE45augMfrYicdoJe97ivWG0CfC7aDIAWF0e37KA0ZJo6A0k
         B2sZhkKW/n2En1o0KbE6z+g035D1Q6mGsbS8K+HcTap3WOgsf+vpvBVuiGlqYt8xAD
         0fEtB5phIGQug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, hauke@hauke-m.de, maz@kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 010/138] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 12:44:36 -0500
Message-Id: <20211108174644.1187889-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
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
index 63dccb2ed08b2..2784715933d13 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/of.h>
 
@@ -222,6 +223,8 @@ ltq_dma_init(struct platform_device *pdev)
 	clk_enable(clk);
 	ltq_dma_w32_mask(0, DMA_RESET, LTQ_DMA_CTRL);
 
+	usleep_range(1, 10);
+
 	/* disable all interrupts */
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
-- 
2.33.0

