Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5244A17C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242206AbhKIBKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241883AbhKIBI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:08:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30C336134F;
        Tue,  9 Nov 2021 01:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419813;
        bh=TvRybkmIZXm5b4fBW021zIQSsdc2mgGpABjth/Mi2s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr5Qj6+EcMc6umCIW5+Y2YWPhH1p1kYXYGZ4YBm6J4oOlThGD0WxeM0zR8B7wNkDP
         dwdxEsQjE3lhWqMFAoiM19jWvkOZchr8PypGgZYW3DDudKx58pcB9Scb0dyUgTm2wm
         AB80kx7lUQbB9Ot3okdVxBcmNBATA9pcS6uzWmY/GVFnRgLmTsCWUumAQ8f7KpJlph
         EeiSbiI8RBXEvSR+X5snm6xbdd05WEYNRWcPeqQbS33LZM9ld+61rZg7BaoJgY98ah
         Wj3JjiMvQTPPtZW+jKpFY/y5cFnTVJsqCemM72Ii+Kw28tk4XjLYcW57e8zRVwhSc6
         w6WU2hET0Py5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, hauke@hauke-m.de, maz@kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 010/101] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 12:47:00 -0500
Message-Id: <20211108174832.1189312-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
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
index aeb1b989cd4ee..24c6267f78698 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 
 #include <lantiq_soc.h>
@@ -221,6 +222,8 @@ ltq_dma_init(struct platform_device *pdev)
 	clk_enable(clk);
 	ltq_dma_w32_mask(0, DMA_RESET, LTQ_DMA_CTRL);
 
+	usleep_range(1, 10);
+
 	/* disable all interrupts */
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
-- 
2.33.0

