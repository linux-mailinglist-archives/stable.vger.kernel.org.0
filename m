Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873AC45BFE5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346699AbhKXNCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344031AbhKXNAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A763619E4;
        Wed, 24 Nov 2021 12:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757289;
        bh=EiK1Q/68IY129PrOUGnJGHjqgdC2UACaw6JmorVVP+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1S6hUXDGzes8ZdkcNv+8Mt0W/g5poN0zs2h/iifZWZq7MLbz51JDXaJ3BLMMl8A4
         HPY2R91n0kahCMUDgEFsBKt72Aix9B+6uUFyojWu1gzzgR1KlX8YbyFb5ei23u0UiT
         eN8ndFO5m/ieUgeHyztcseyB2yrO8TwhSl996Rrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/323] MIPS: lantiq: dma: add small delay after reset
Date:   Wed, 24 Nov 2021 12:54:36 +0100
Message-Id: <20211124115721.859707303@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



