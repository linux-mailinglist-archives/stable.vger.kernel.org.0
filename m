Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B1644A1DE
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbhKIBMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241899AbhKIBKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F31161A80;
        Tue,  9 Nov 2021 01:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419881;
        bh=TvRybkmIZXm5b4fBW021zIQSsdc2mgGpABjth/Mi2s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXSqYiUR/wyU+3UZXuhoChJuJmY44LvkmKcxrxd4FqEZ5TFQm6H1tN6YKe3B/4oCQ
         2f8DLts9CKD/MyY6U49nV+QvaqM7SCY1v5wxF5IePk6WSGFFG2SSdPOL2cfSumKtI0
         Y/g6UyiIbovBmRyPRO1+jpcxGSGIhUi1ukbdXBgtsv4zhgIetzAKNU8vfAy5WsQEt5
         p6+f8fHPL0jxSnAVDsciJtoW+08p3PuzfYb9jwY3uhXE8QRUvgzKnuFa+MBXHmuDbD
         CKwBa50XC95Fvc3CjErIMsbvGH9ke6ZpqDd6g/2m35i5Z/NwYQiWna5tZg+3UkA/3t
         W0u6s9oXWJ9Ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, maz@kernel.org, hauke@hauke-m.de,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/74] MIPS: lantiq: dma: add small delay after reset
Date:   Mon,  8 Nov 2021 12:48:36 -0500
Message-Id: <20211108174942.1189927-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174942.1189927-1-sashal@kernel.org>
References: <20211108174942.1189927-1-sashal@kernel.org>
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

