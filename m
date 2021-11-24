Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDEB45BB7E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242788AbhKXMUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:20:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243512AbhKXMSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:18:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8651C61130;
        Wed, 24 Nov 2021 12:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755882;
        bh=CaBHb5y99m3Qd8zy0Hrg4tV9zHkZUHAhNx8botNcBZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAkG7KFw8xQy7uYRttX/UAlP2SG0AJXUddM2v3m3cWJmEQ3J1Xe5Y+9AEgnKJuYZW
         wzxRTXF0rKBOlP3ayd9v8Hm4aOa4EnbSVL9/NJgsq2tNFnsOYrAlHg5Jdii70cYRPl
         v11hUEYZRlLhEYi0KhA8yNul6D67xlHghj6MBc2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 059/207] MIPS: lantiq: dma: add small delay after reset
Date:   Wed, 24 Nov 2021 12:55:30 +0100
Message-Id: <20211124115705.838773836@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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



