Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB71328A16
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239399AbhCASMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:12:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238839AbhCASF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E93B6506D;
        Mon,  1 Mar 2021 17:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619476;
        bh=tSuVcG+VWR+AgQDcsiM1UL1MY3qe/NX/+mR9jH9sh2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2TYf3VmdzW6TBb4U7qoMJ4jVwvg4GULmJ96V9QAt04dpkwihc9LZVw9QkKqSsi41
         tmbn6rmrUIiXCDYsUiM7L8ZbnWwNFYBtHGjc9AFzRZjCkANsXkDOpor/5lModV8Z3U
         UuxEMJj+p3xnvCrIcK1/EtGAZRDFuM4H7jzOPKaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <martenli@axis.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 468/663] i2c: exynos5: Preserve high speed master code
Date:   Mon,  1 Mar 2021 17:11:56 +0100
Message-Id: <20210301161205.015367163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mårten Lindahl <martenli@axis.com>

[ Upstream commit f4ff0104d4c807a7f96aa3358c03d694895ee8ea ]

When the driver starts to send a message with the MASTER_ID field
set (high speed), the whole I2C_ADDR register is overwritten including
MASTER_ID as the SLV_ADDR_MAS field is set.

This patch preserves already written fields in I2C_ADDR when writing
SLV_ADDR_MAS.

Fixes: 8a73cd4cfa15 ("i2c: exynos5: add High Speed I2C controller driver")
Signed-off-by: Mårten Lindahl <martenli@axis.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-exynos5.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 6ce3ec03b5952..b6f2c63776140 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -606,6 +606,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	u32 i2c_ctl;
 	u32 int_en = 0;
 	u32 i2c_auto_conf = 0;
+	u32 i2c_addr = 0;
 	u32 fifo_ctl;
 	unsigned long flags;
 	unsigned short trig_lvl;
@@ -640,7 +641,12 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 		int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
 	}
 
-	writel(HSI2C_SLV_ADDR_MAS(i2c->msg->addr), i2c->regs + HSI2C_ADDR);
+	i2c_addr = HSI2C_SLV_ADDR_MAS(i2c->msg->addr);
+
+	if (i2c->op_clock >= I2C_MAX_FAST_MODE_PLUS_FREQ)
+		i2c_addr |= HSI2C_MASTER_ID(MASTER_ID(i2c->adap.nr));
+
+	writel(i2c_addr, i2c->regs + HSI2C_ADDR);
 
 	writel(fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
 	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
-- 
2.27.0



