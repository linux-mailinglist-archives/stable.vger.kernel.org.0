Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC24044A048
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbhKIBCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237261AbhKIBCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 894A96134F;
        Tue,  9 Nov 2021 01:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419602;
        bh=5TaTadUUlRIm99JBWT3Hg8pPrx4O+pzJ82CGst/LFJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7tAlUaHYHQhfjXF6PB1BM3oGjkZN9kXfhbNeoBQeOmkXyppPs+1NWa3t8Gvv6iXq
         AV4xLvOrVWv9UOoL6A2TXkvc0GNAclHG52Sbw8H5lUbsXirX8Dz3VacI2V+u1/Tb+e
         A9cNw/bLuj4NE+INnsNjd2LJpBMWFk3y2H19pGdA9ROOwyFQsfYyuqBrboBFpG0Pny
         hGJVK8naysvHqVFc96WRTfrBpGFp5By8znzgOw6r9jsW3qzl7Gto7iws8FEWJ3S7Rf
         HaSpffWOQAhoi7FcVvB2ccRnCeD1H9W2hvgcXPLac1wDpem0y7cpBgQtauJiNO0AQM
         z6Y1eYiX40LgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, maz@kernel.org, hauke@hauke-m.de,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 012/146] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 12:42:39 -0500
Message-Id: <20211108174453.1187052-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
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

