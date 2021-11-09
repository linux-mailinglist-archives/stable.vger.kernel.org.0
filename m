Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2F644A369
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbhKIB0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243837AbhKIBXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:23:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F3A261A70;
        Tue,  9 Nov 2021 01:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420166;
        bh=GfOpFnXAiHmX3z8uL6XtcSjQjINziKqF1YSeaM9QeMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+fSz7zTNnrT7RwiphBOHnZziiFglJxSJ9L+CP5L0Ecb1Heabb0DvY+Z91EPcKr9i
         zzFDzILAO5HmofAks9md2I9X+CaKZ9k57Rtkv/+9mge6NaNhReGnJfNNIqhhDXJoJF
         m7htJbfIz+ISTR+ltJx5KZmnUcioL+QU12RQwexM1U0c9BykI3RFbukxOOp/tTmbGA
         Xh/Ab2MSFJ1bartdCJQ27E7vSB6+H+q91FraHJn86y77tbPSPrQu+CsGc+9oQTQJ/G
         bec9fD2EI0n+ADoL9fP0YR6TI9mGLmHPydmtMimwj9gGp99tJoq9M2jQEIYnq0AaGy
         DssYYxOUZVVqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, hauke@hauke-m.de, maz@kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/30] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 20:08:52 -0500
Message-Id: <20211109010918.1192063-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
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
index 34a116e840d8b..932161284213c 100644
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

