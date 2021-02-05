Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A728311366
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhBEVW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233044AbhBEPCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8F965040;
        Fri,  5 Feb 2021 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534313;
        bh=PDRrrhcxNK6kFhlHbZPEbR65Z68ghkWZSKmDzBTTGqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+L7174IrcDp/LoOpxLXrvdaVRGVJueMkhmiuywBOR1mpW16OM4awov/rpByQ8IdO
         06OGxan3BqG0cAhaJLJ0dKoHo3PkSibGdo+BLEqdiiSFgVhe+EMTEwLzDMA7rf5VP8
         HwwzuiUI6RgmLTFhYwdYjNT2Zgq6aLKf+JV2eYgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/57] i2c: tegra: Create i2c_writesl_vi() to use with VI I2C for filling TX FIFO
Date:   Fri,  5 Feb 2021 15:07:03 +0100
Message-Id: <20210205140657.561912580@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit 2f3a0828d46166d4e7df227479ed31766ee67e4a ]

VI I2C controller has known hardware bug where immediate multiple
writes to TX_FIFO register gets stuck.

Recommended software work around is to read I2C register after
each write to TX_FIFO register to flush out the data.

This patch implements this work around for VI I2C controller.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 0727383f49402..8b113ae32dc71 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -326,6 +326,8 @@ static void i2c_writel(struct tegra_i2c_dev *i2c_dev, u32 val, unsigned int reg)
 	/* read back register to make sure that register writes completed */
 	if (reg != I2C_TX_FIFO)
 		readl_relaxed(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
+	else if (i2c_dev->is_vi)
+		readl_relaxed(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, I2C_INT_STATUS));
 }
 
 static u32 i2c_readl(struct tegra_i2c_dev *i2c_dev, unsigned int reg)
@@ -339,6 +341,21 @@ static void i2c_writesl(struct tegra_i2c_dev *i2c_dev, void *data,
 	writesl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg), data, len);
 }
 
+static void i2c_writesl_vi(struct tegra_i2c_dev *i2c_dev, void *data,
+			   unsigned int reg, unsigned int len)
+{
+	u32 *data32 = data;
+
+	/*
+	 * VI I2C controller has known hardware bug where writes get stuck
+	 * when immediate multiple writes happen to TX_FIFO register.
+	 * Recommended software work around is to read I2C register after
+	 * each write to TX_FIFO register to flush out the data.
+	 */
+	while (len--)
+		i2c_writel(i2c_dev, *data32++, reg);
+}
+
 static void i2c_readsl(struct tegra_i2c_dev *i2c_dev, void *data,
 		       unsigned int reg, unsigned int len)
 {
@@ -811,7 +828,10 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
 		i2c_dev->msg_buf_remaining = buf_remaining;
 		i2c_dev->msg_buf = buf + words_to_transfer * BYTES_PER_FIFO_WORD;
 
-		i2c_writesl(i2c_dev, buf, I2C_TX_FIFO, words_to_transfer);
+		if (i2c_dev->is_vi)
+			i2c_writesl_vi(i2c_dev, buf, I2C_TX_FIFO, words_to_transfer);
+		else
+			i2c_writesl(i2c_dev, buf, I2C_TX_FIFO, words_to_transfer);
 
 		buf += words_to_transfer * BYTES_PER_FIFO_WORD;
 	}
-- 
2.27.0



