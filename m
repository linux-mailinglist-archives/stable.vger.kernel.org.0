Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AAC10BE14
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfK0Uvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbfK0Uvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:51:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3988B21871;
        Wed, 27 Nov 2019 20:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887908;
        bh=by66fafWIkFfkatStvHYRKlIhFEru2T56686wGJEHj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0XxXbDeFnHpQm3Yr1y3JgWSudMY/vRnkB+ZQ/s+DLDoq4TFiPM/SbDLD9bRGQyLj
         rW6cch3B1Ptp1zsCKY86DtQliSNM1C3l5p6h2hLPy2R8KO9Y0g22yDSw+SZO3Ty5n+
         BNbBlIjLuCFxxzNyFWyodOBzKNOvwCvfsI9zXKKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/211] i2c: uniphier-f: fix race condition when IRQ is cleared
Date:   Wed, 27 Nov 2019 21:30:33 +0100
Message-Id: <20191127203103.134044152@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit eaba68785c2d24ebf1f0d46c24e11b79cc2f94c7 ]

The current IRQ handler clears all the IRQ status bits when it bails
out. This is dangerous because it might clear away the status bits
that have just been set while processing the current handler. If this
happens, the IRQ event for the latest transfer is lost forever.

The IRQ status bits must be cleared *before* the next transfer is
kicked.

Fixes: 6a62974b667f ("i2c: uniphier_f: add UniPhier FIFO-builtin I2C driver")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-uniphier-f.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-uniphier-f.c b/drivers/i2c/busses/i2c-uniphier-f.c
index bbd5b137aa216..928ea9930d17e 100644
--- a/drivers/i2c/busses/i2c-uniphier-f.c
+++ b/drivers/i2c/busses/i2c-uniphier-f.c
@@ -143,9 +143,10 @@ static void uniphier_fi2c_set_irqs(struct uniphier_fi2c_priv *priv)
 	writel(priv->enabled_irqs, priv->membase + UNIPHIER_FI2C_IE);
 }
 
-static void uniphier_fi2c_clear_irqs(struct uniphier_fi2c_priv *priv)
+static void uniphier_fi2c_clear_irqs(struct uniphier_fi2c_priv *priv,
+				     u32 mask)
 {
-	writel(-1, priv->membase + UNIPHIER_FI2C_IC);
+	writel(mask, priv->membase + UNIPHIER_FI2C_IC);
 }
 
 static void uniphier_fi2c_stop(struct uniphier_fi2c_priv *priv)
@@ -172,6 +173,8 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 		"interrupt: enabled_irqs=%04x, irq_status=%04x\n",
 		priv->enabled_irqs, irq_status);
 
+	uniphier_fi2c_clear_irqs(priv, irq_status);
+
 	if (irq_status & UNIPHIER_FI2C_INT_STOP)
 		goto complete;
 
@@ -250,8 +253,6 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 	}
 
 handled:
-	uniphier_fi2c_clear_irqs(priv);
-
 	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
@@ -340,7 +341,7 @@ static int uniphier_fi2c_master_xfer_one(struct i2c_adapter *adap,
 		priv->flags |= UNIPHIER_FI2C_STOP;
 
 	reinit_completion(&priv->comp);
-	uniphier_fi2c_clear_irqs(priv);
+	uniphier_fi2c_clear_irqs(priv, U32_MAX);
 	writel(UNIPHIER_FI2C_RST_TBRST | UNIPHIER_FI2C_RST_RBRST,
 	       priv->membase + UNIPHIER_FI2C_RST);	/* reset TX/RX FIFO */
 
-- 
2.20.1



