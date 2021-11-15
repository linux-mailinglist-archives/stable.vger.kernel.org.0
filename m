Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FBB4527B2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbhKPCaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237108AbhKORRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:17:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC87863248;
        Mon, 15 Nov 2021 17:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996385;
        bh=TvRybkmIZXm5b4fBW021zIQSsdc2mgGpABjth/Mi2s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtIZovQaA1ftVQ02wgE1VvBhsFgWETn+3zGb1lzAaCyiJpeWhRr9a9OvVqRQTz57k
         j2OKbcRbf1zpH4ZD5pbNepgsiK7x8e+IWCeWQ/qj7lUZSWbYq3leiH5TWlEnq05sSa
         7awgMKdscXq/JDchQLT8OUKQVW2V7geDO/60dcRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/355] MIPS: lantiq: dma: add small delay after reset
Date:   Mon, 15 Nov 2021 18:00:44 +0100
Message-Id: <20211115165317.696734143@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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



