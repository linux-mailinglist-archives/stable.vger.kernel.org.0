Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15682167620
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgBUIIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732102AbgBUIIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:08:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F09720801;
        Fri, 21 Feb 2020 08:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272529;
        bh=VR/tYj5donPID9f9La1GAChsuMa4kOjV/ethBBqSGqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXQX0qazNXA4vpUM9c3/4A+xUVEngdoaWNY1RMHLWVx15pL5f38RgzVQHBUkZaOhj
         9E3ziBqZzKKmAyymD7DKjUqTTD+FAbM4d0zzWL/qLilIM8cO3ywhAAUk7WXTLUfJnX
         H26PoQjWxiDDfyIx39ADBPCY82H2Kzvtb++4vLxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/344] clk: uniphier: Add SCSSI clock gate for each channel
Date:   Fri, 21 Feb 2020 08:39:35 +0100
Message-Id: <20200221072404.963994507@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 1ec09a2ec67a0baa46a3ccac041dbcdbc6db2cb9 ]

SCSSI has clock gates for each channel in the SoCs newer than Pro4,
so this adds missing clock gates for channel 1, 2 and 3. And more, this
moves MCSSI clock ID after SCSSI.

Fixes: ff388ee36516 ("clk: uniphier: add clock frequency support for SPI")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lkml.kernel.org/r/1577410925-22021-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/uniphier/clk-uniphier-peri.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/uniphier/clk-uniphier-peri.c b/drivers/clk/uniphier/clk-uniphier-peri.c
index 9caa52944b1c5..3e32db9dad815 100644
--- a/drivers/clk/uniphier/clk-uniphier-peri.c
+++ b/drivers/clk/uniphier/clk-uniphier-peri.c
@@ -18,8 +18,8 @@
 #define UNIPHIER_PERI_CLK_FI2C(idx, ch)					\
 	UNIPHIER_CLK_GATE("i2c" #ch, (idx), "i2c", 0x24, 24 + (ch))
 
-#define UNIPHIER_PERI_CLK_SCSSI(idx)					\
-	UNIPHIER_CLK_GATE("scssi", (idx), "spi", 0x20, 17)
+#define UNIPHIER_PERI_CLK_SCSSI(idx, ch)				\
+	UNIPHIER_CLK_GATE("scssi" #ch, (idx), "spi", 0x20, 17 + (ch))
 
 #define UNIPHIER_PERI_CLK_MCSSI(idx)					\
 	UNIPHIER_CLK_GATE("mcssi", (idx), "spi", 0x24, 14)
@@ -35,7 +35,7 @@ const struct uniphier_clk_data uniphier_ld4_peri_clk_data[] = {
 	UNIPHIER_PERI_CLK_I2C(6, 2),
 	UNIPHIER_PERI_CLK_I2C(7, 3),
 	UNIPHIER_PERI_CLK_I2C(8, 4),
-	UNIPHIER_PERI_CLK_SCSSI(11),
+	UNIPHIER_PERI_CLK_SCSSI(11, 0),
 	{ /* sentinel */ }
 };
 
@@ -51,7 +51,10 @@ const struct uniphier_clk_data uniphier_pro4_peri_clk_data[] = {
 	UNIPHIER_PERI_CLK_FI2C(8, 4),
 	UNIPHIER_PERI_CLK_FI2C(9, 5),
 	UNIPHIER_PERI_CLK_FI2C(10, 6),
-	UNIPHIER_PERI_CLK_SCSSI(11),
-	UNIPHIER_PERI_CLK_MCSSI(12),
+	UNIPHIER_PERI_CLK_SCSSI(11, 0),
+	UNIPHIER_PERI_CLK_SCSSI(12, 1),
+	UNIPHIER_PERI_CLK_SCSSI(13, 2),
+	UNIPHIER_PERI_CLK_SCSSI(14, 3),
+	UNIPHIER_PERI_CLK_MCSSI(15),
 	{ /* sentinel */ }
 };
-- 
2.20.1



